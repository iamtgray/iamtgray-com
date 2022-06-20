---
title: "Securing your CI/CD Pipelines"
date: 2022-06-20T16:10:14+01:00
draft: false
---

When speaking to customers about security, I always try to raise the topic of shifting security left.  This relatively moden practice and thinking comes from the dual need to not only (a) de-burden the security team from the low-value tasks of approving individual changes, and (b) allowing the software engineering teams inside the organisation to increase the speed of change, while keeping the security bar high.

It takes a real shift in mindset for most organisations (and the security teams within them) to start moving security left.  Often customers ask what exactly is meant by "shifting left" in this context.  To help make the phrase "shift left" real in a customers mind, I commonly point them to their CI/CD pipeline. 

Take the below example of a common CI/CD pipeline pattern:

![Example CI/CD Pipeline](/img/ci-cd-pipelines/basic-ci-cd-pipeline.png) 

Looking at the example given above, normally security would be inserted (manually) just after the "Auto Test" step.  Security tickets would be cut, and a representative from infosec might review the changes being made to production, they might run a vulnerability scan against the application, and possibly even review some code before approving the release.

The concept of shifting left literally moves this step leftwards in the pipeline, rather than security teams being involved in the process just before the release to production (and more often than not, stopping the pipeline and causing changes to back-up while they gather an understanding of the scope of change, and the risk to the business) they are instead involved at an earlier stage.

Often teams do this by bringing a security engineer into the team, so that they can be involved in sprint ceremonies, or other workflow events to "ensure the security bar" - this can sometimes lead however to changes being slowed sooner rather than later, rather than a speeding up of the overall pipeline (although externally to the business, it may feel faster because there are fewer release pauses).

A more practical answer to keep the speed high and the quality high, is to automate as much as possible of the work that the security engineer might perform, so that when they are involved they are presented with high quality, accurate information in a timely manner, and they can use their specialist skills and expertise to home-in on the problem faster.  This can be further extended by the use of automated tooling to help the developers in the team get security feedback faster.

This blog post will focus on this last aspect. The goal of building security practice into the CI/CD system is to ensure that we minimise production change risk in security by ensuring that a minimum security bar is met.  This free's security engineers up to perform more exploritory analysis and add more intrisic value to teams based on their skill sets.

## Choosing your tooling

In the market today, there are hundreds of different peieces of software to help you automate aspects of security for your workload, with that choice available in the market this blog post cannot cover all use cases in all programming langauges being deployed to all environments.

This post does not focus on the specific tools (there are dive-deep posts for that) but instead focuses on the overall goal, and how it can be achieved.


### Different tooling types

1. SAST: Static Analysis Security Testing is the most common, basic and well-used automated security testing tool in CI/CD pipelines.  SAST analysis examines the code in the application, and attempts to determine through fixed rules or models if an application has inherent security flaws.  SAST tooling is excellent for detecting basic configuration errors, but is also capable (when using the right tools) of detecting more advanced threats such as inputs that are not cleaned, or overflow attacks
2. DAST: Dynamic Analysis Security Testing is a less common but still effective method of detecting security vulnerabilities in software. DAST tooling is designed to work in concert with a running application, and through monitoring the flow of data throgh the software, can help to uncover potential bugs and security flaws with how (for example) data is handled as it flows around the application
3. Dependency Scanning: There are a numebr of different tools (both inside and outside of the AWS ecosystem) to help track and scan application dependencies.  Given the prevelance and risk of supply chain attacks, many organisations face tough decisions when attempting to choose between giving the engineering teams the freedom to use libraries to help them perform their work more effecively, and managing the inherent risk of bringing 3rd party code into your application.  Dependency scanning tools (examples of which can be found below) can help to mitigate some of these risks, and along with SAST and DAST tooling can help to further reduce the risk.


# A more expansive pipeline

If we want to integrate greater security controls into our CI/CD pipeline, then we need to look at a pipeline and consider the best place to bring those kind of controls in, take the below picture as a starting point:

![Example CI/CD Pipeline](/img/ci-cd-pipelines/ci-cd-pipeline-example-automation.png)


## Before commit

We want to perform as many checks as practical before the engineer commits any code to repo - this is due to our need to reduce alert fatigue and keep our team functioning at a high velocity.

### IDE Linting

This can be an excellent control for any organisation, your IDE gives you instant feedback when writing software, and bringing linting that works to maintain and enhance your security posture can give real benefits and gains to your team members.

The exceptionally short feedback cycle reduces mental fatigue on the team, and reduces frustration with security controls 'getting in the way of work'

### SAST Scanning

Another on-machine scan that can easily be performed as pre-commit hook would be a basic SAST scan, this in combination with linting in the IDE can give early feedback to your users.  Choosing a SAST scanner that can look at specific files will mean the scans can run quickly, and giving users that feedback as early as possbile will help to reduce fatigue.

*Note* While a pre-commit hook is a mechanism to have a scan performed before merge, this can still increase frustration in your engineers, so choose your rule-set wisely, each rule must have a business purpose, applying a set of defaults and forgetting about it is likely to cause normalisation of deviance.

## Post-commit checks

For all the checks that we could perform on the user's machine, we now have likely eliminated the most obvious errors and threats in our codebase - SAST scanning on individual files likely means we have ensured that no secrets are hard coded, no basic input manipulation bugs are present.

Now are checks are likely to take longer, but occur in a timescale in which our customer (the engineer) is expecting minutes of time, not tenths of a second.

### Library version scanning

An argument can be made that this scan can be performed on the engineers machine during their work as fixing a library being out-of-date will require additional testing to ensure that no breaking changes are being brought in.

Checking the versions of all of the dependencies of your applications to ensure there are no reported vulnerabilities can be a simple way to apply a level of mitigation (though not absoloute) to supply-chain attacks.

N.b. Important to note that library scanning tools check versions and don't generally perform SAST or DAST checks, so your supply chain can still be broken for a period before a vulerability is reported agasinst the library you use.

### Deep SAST scanning

While not an official term in the industry, I use the term "Deep SAST" to differentiate a SAST scan that will be run across the entire codebase, libraries and dependencies.  This is to try to mitigate further supply-chain based vectors, and ensure compliance.  These SAST scans will need to focus not on code quality (which was what we checked pre-commit) but more on obvious vulnerabilities.


### IaC code scanning

If you are using IaC (which you should be) to manage your deployed environment, then an easy way to implement organisational controls into your engineering and ensure guard-rails are properly applied before they get into the environment, is to implement a set of IaC Code Scanning tools. 

For more detail on this - check out the [post I have created on IaC code scanning](/bring-controls-into-ci-cd-with-iac-scanning/)

## Post pull-request changes

Assuming that your engineering team operates on a pull-request model, where changes are peer reviewed before being merged into the development branch (which is a generally reccomended practice) then you can perform further and more intensive compliance checks in the build system.

It is expected by engineers that builds will take minutes at least, and are generally a great time to go off and grab a hot beverage of choice, in this time we can run more intrusive and time/compute intensive checks

### DAST Scanning

At build time can be a great time to run DAST tooling against your application - you've got an integrated built/compiled application at this point, so you can trigger a DAST scan against your application.

N.b. this scan will likely find more complex bugs/vulernabilities - but you are still testing components in isolation rather than integration, consider running further scans post-integration (see Automated pen testing).

### Security Regression testing

This one is frequently missed by high-speed engineering teams, but can be vitally important to ensuring compliance - having a regression pack not only for normal failures in an application discovered, but also for security incidents discovered can be vitally important.

Having this pack seperate from your normal automated DAST/SAST/Pen Test pack ensures that changes to the underlying scanning engines do not stop or change detection on previously detected vulnerbailities


## Deployment

Once you have a build codebase that has now been deployed to some kind of testing environment, you can now perform security integration tests against your workload.  This is the time to bring in fuzzing and rules based testing systems that act on all inputs to your application to ensure that the application continues to behave as expected

### Automated pen testing

Using tools to run an automated application vulnerability assessment on your application can provide continuous assurance to the information security function in the organisation that continous compliance is being upheld


### Special mention: Automated load testing

A special mention here (and a favorite of mine) is automating load testing at this stage.  Having a basic performance pack run against your application ensures that if your application comes under a DoS attack that you know how your application will respond.

While not directly part of the compliance of the application - having an awareness of how your application behaves can be advantagoes, and will allow you to spot patterns and trends in changes to application behavior under load.


# Summary

This post has focused on the pipeline itself, and has steered away from specific tooling that can be used.  The purpose of not focusing on the tools is that you as the user must choose the tools that meet your compliance requirements and orgnisational goals - while the 'dive deep' articles like the [infrastructure as code scanning](/bring-controls-into-ci-cd-with-iac-scanning/) do go deeper into the available tools - these sets of best practices allow you to see where you can aim for, without getting bogged down in tooling selection.

Elevating your thinking to solving the overarchiing problem of compliance in your CI/CD pipelines is nessesary to not get bogged down in detail, and forget the organisational goal.