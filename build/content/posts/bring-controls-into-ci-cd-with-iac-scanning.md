---
title: "Bringing security controls into CI/CD with IaC scanning"
date: 2022-06-20T17:10:14+01:00
draft: false
---

In a [recent blog post](/posts/secure-ci-cd-pipelines/) I wrote about the overall controls that can be built into your CI/CD pipelines to increase your security posture.
 
This post aims to dive deeper into the specifics of IaC (Infrastructure as Code) scanning, and explore *some* of the tools available to you.
 
# Preface
 
Before diving into how to resolve the problem, let's frame the problem that exists in the entire security landscape, and is especially true in highly automated environments, that is the problem of "normalisation of deviance" (or "normalization of deviance" for my American collegues).
 
Normally when I'm talking to customers, I might get standard list of challenges from the team I’m talking too, they might be something like: 

“My security org can’t keep up with us”
“We’re doing agile now, how does security fit in”
“Security team have blocked us”

These challenges are common and by that there are mechanisms we can use to reduce the internal cost of these - and work to keep the velocity of the engineering teams high, while also maintaining or (usually) the security bar.

These kind of problems (and many like them) tend to breed a normalisation of deviance in the team.  Normalisation of deviance can be defined as “The gradual process through which unacceptable practice or standards becomes acceptable.”  To continue on this the original author of this quote (and the concept in general) Dr Diane Vaughan further added “as the deviant behaviour is repeated with catastrophic results, it becomes the social norm for the organisation” 

To make that sentence a little more real, you could define it like this:

“
New person joins the team
New person: wtf wtf wtf wtf WTF WTF WTF
Old hand: Yeah we know, we’re concerned about it
New person: WTF WTF WTF wtf wtf wtf wt…
New person gets used to it
New person #2 joins
New person #2: WTF WTF WTF
New person: Yeah we know, we’re concerned about it.

I like the above structure, because it actually reminds me both of me being the new guy into a team, and me being the old hand in the team - I’ve been in both of those roles in the past and challenging the behaviours I showed then is how I approach handling this with customers.

The difference for those responsible for organisational security compliance in these situations - is that of awareness. Most security engineers that I’ve worked with don’t come from development backgrounds, and those that do are as rare as hen’s teeth.  Therefore the organisation needs to provide other mechanisms and controls to ensure that the compliance and governance goals of the organisation are met.

For a lot of customers, this comes in the form of stricter policies.  More review steps required before changes go-live, increased spend with 3rd party penetration testing organisations, and a general reduction in team velocity.  I’ve also seen companies go the other way on this, and simply try to ignore the problem - scoping down their compliance to only focus on what they can tightly control, and drawing organisational boundaries to meet compliance requirements.   As you would expect, neither of these have worked well in my experience, and both lead to challenges for the people involved.

One of the ways of breaking that circle, reducing the likelihood of a normalisation of deviance and increasing organisational control while still maintaining velocity - is that of automating the controls and governance of the organisation.  The more can be automated, and policy can be codified - the less organisational velocity will be lost by the need to implement those controls.

Let’s take for example a small subset of an imagined organisational controls - let’s say they have taken the sensible step of wanting to ensure that no users can escalate their own privilege, and they need their audit to reliably demonstrate this.

Below is a sample set of control requirements:

Stop all users being able to escalate their role / amount of privilege inside the environment
Stop the creation of high privilege roles that have a higher set of permissions than the user creating them
Ensure that all users or roles are created by the CI/CD system and are therefore subject to the organisations policies
Remediate all users or roles that are created without the correct boundaries on their permissions

# The tools

To be able to meet this and other compliance goals, there are a number of tools you can use.  The tools below focus heavily on the AWS Cloud, but some are mentioned (and noted) that support one or more cloud vendors, or are agnostic of the underlying cloud platform.

## CFN Nag

CFN Nag is a great linting tool (and executes quickly, so you can and should use it on an engineering machine rather than just in CI/CD).

CFN Nag is useful for detecting indications of insecure or incorrectly configured infrastructure as code.  Examples of this include IAM rules that are overly permissive, security group rules that are overly permissive - but also extends to access logs or encryption that’s disabled and even password literals found in the code.

## CFN Guard

CFN Guard is the real meat on the IaC compliance when it comes to AWS CloudFormation (and even Terraform at a push) 

It's a tool that has been developed by AWS SA's to take in an given set of rules, and parse a CloudFormation template against the given rules.  It has it's own custom DSL (sigh) but implements basic operands and comparitors that allow you to write a functional rule set.  Take the below CloudFormation and corresponding set of business rules as an example:

```yaml

AWSTemplateFormatVersion: "2010-09-09"
Description: "Demo CFN for creating roles/users in this example for a sample DynamoDB Lambda Execution"

Resources:


  TestRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      PermissionsBoundary: arn:aws:iam:::policy/PermissionBoundary
      RoleName: EC2S3Access
      Description: Test role that implements the right controls
      ManagedPolicyArns: 
        - arn:aws:iam::aws:policy/DynamoS3AccessPolicy

  DynamoS3AccessPolicy:
    Type: AWS::IAM::ManagedPolicy
    Properties: 
      Description: Managed Policy..
      ManagedPolicyName: DynamoS3Access
      Path: /
      PolicyDocument: 
        Version: "2012-10-17"
        Statement:
          - Effect: Allow
            Action:
              - 'dynamodb:Query'
              - 'dynamodb:Scan'
              - 's3:*'
            Resource: '*'
      Roles: 
        - !Ref TestRole

```

There are (if you've written any CloudFormation before) a number of key issues with this, while it is valid and will deploy - it has a tightly coupled policy to role (meaning replacement of one requires replacement of the other) as well as a number of * allow conditions across actions and resources.  This kind of CloudFormation is the style we want to stop entering our environments - to do this we can write some basic rules in CFNGuard that stop this bad practice:

```javascript
# CFN Guard Rules designed to assist in the prevention of privilege escalation attacks inside AWS.

let aws_iam_role_user_resources = Resources.*[
  Type in [ /IAM::Role/,
            /IAM::User/ ]
]

let iam_policies = Resources.*[ Type == /IAM::Policy/ ]
let iam_managed_policies = Resources.*[ Type == /IAM::ManagedPolicy/ ]

rule aws_iam_role_user_resources when %aws_iam_role_user_resources !empty {
  # Ensure that they are setting a permission boundary
  %aws_iam_role_user_resources.Properties.PermissionsBoundary !empty
  # Ensure that the permission boundary set is the GeneralPermissionBoundary
  %aws_iam_role_user_resources.Properties.PermissionsBoundary == /policy\/PermissionBoundary/
  #  Stop people creating cicd- roles directly
  %aws_iam_role_user_resources.Properties.RoleName != /^cicd-/
}

rule managed_policies_not_called_permission_boundary when %iam_managed_policies !empty {

  when %iam_managed_policies.Properties.ManagedPolicyName exists {
    %iam_managed_policies.Properties.ManagedPolicyName != /GeneralPermissionBoundary/
  }
}

rule policies_not_called_permission_boundary when %iam_policies !empty {
  when %iam_policies.Properties.PolicyName exists {
    %iam_policies.Properties.PolicyName != /GeneralPermissionBoundary/
  }
}

let iam_policies_allowing = Resources.*[
    Type in [/IAM::Policy/, /IAM::ManagedPolicy/]
    some Properties.PolicyDocument.Statement[*] {
         some Action[*] == /:\*/
    }
]

rule iam_policies_cannot_allow_stars when %iam_policies_allowing !empty {
  %iam_policies_allowing.Properties.PolicyDocument.Statement[*].Effect == "Deny" <<You cannoy have an allow *, * is only allowed during a deny>>
  %iam_policies_allowing.Properties.PolicyDocument.Statement[*].Resource == /^\*/ <<You cannot apply IAM policies to all resources, they must be down-scoped>>
}
```

# Other tools (some commercial)

## Sentinel - Hashicorp

Released by Hashicorp, sentinel is an IaC scanning tool that's specifically designed for Terraform/Vault/Consul/Nomad policies as code.

Much the same as CFN Guard, you can define your organisational policies and controls once, and use a tool like Sentinel to enforce those policies as early as possible in the development lifecycle.

## Checkov

This one is similar to CFN Nag but is built for multiple cloud providers and IaC providers.  There are more than 1000 default rules in Checkov, but that's spread across AWS/GCP/Azure with seperate rule sets for CFN, TF and the others

It's not overly simple (though possible) to extend the rule set given, but it's a great one for multi-cloud out of the box.

## Open Policy Agent 

OPA (oh-paa) the Open Policy Agent is attempting to decouple the build from runtime policy - this is a really interesting and head scratching policy enforcement agent.  

As a direct quote from their website: 

```text
The Open Policy Agent (OPA, pronounced “oh-pa”) is an open source, 
general-purpose policy engine that unifies policy enforcement 
across the stack. OPA provides a high-level declarative language
that lets you specify policy as code and simple APIs to offload 
policy decision-making from your software. You can use OPA to 
enforce policies in microservices, Kubernetes, CI/CD pipelines, 
API gateways, and more.

```

# Summary

There are many _many_ *_many_* tools available to you and your organisation for IaC, I would suggest you start small, trying to go 'the whole hog' will be a lot of change very soon, and implementing the right kind of policy as-code controls will take time for any security function.   I would reccomend starting with an open source tool that has inbuilt rules, then expanding your custom rules and policies from there.

