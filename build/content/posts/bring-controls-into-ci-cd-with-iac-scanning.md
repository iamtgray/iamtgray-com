---
title: "Bringing security controls into CI/CD with IaC scanning"
date: 2022-06-20T17:10:14+01:00
draft: false
---

In a [recent blog post](/secure-ci-cd-pipelines/) I wrote about the overall controls that can be built into your CI/CD pipelines to increase your security posture.
 
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
