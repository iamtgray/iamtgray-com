---
title: "Securing your CI/CD Pipelines"
date: 2022-03-14T08:54:14+01:00
draft: true
---

When speaking to customers about security, I always try to raise the topic of shifting security left.  This relatively moden practice and thinking comes from the dual need to not only (a) de-burden the security team from the low-value tasks of approving individual changes, and (b) allowing the software engineering teams inside the organisation to increase the speed of change, while keeping the security bar high.

It takes a real shift in mindset for most organisations (and the security teams within them) to start moving security left.  Often customers ask what exactly is meant by "shifting left" in this context.  To help make the phrase "shift left" real in a customers mind, I commonly point them to their CI/CD pipeline. 

Take the below example of a common CI/CD pipeline pattern:

![Example CI/CD Pipeline](/img/ci-cd-pipelines/pipeline-example.png)

Looking at the example given above, normally security would be inserted (manually) just after the "Auto Test" step.  Security tickets would be cut, and a representative from infosec might review the changes being made to production, they might run a vulnerability scan against the application, and possibly even review some code before approving the release.

The concept of shifting left literally moves this step leftwards in the pipeline, rather than security teams being involved in the process just before the release to production (and more often than not, stopping the pipeline and causing changes to back-up while they gather an understanding of the scope of change, and the risk to the business) they are instead involved at an earlier stage.

Often teams do this by bringing a security engineer into the team, so that they can be involved in sprint ceremonies, or other workflow events to "ensure the security bar" - this can sometimes lead however to changes being slowed sooner rather than later, rather than a speeding up of the overall pipeline (although externally to the business, it may feel faster because there are fewer release pauses).

A more practical answer to keep the speed high and the quality high, is to automate as much as possible of the work that the security engineer might perform, so that when they are involved they are presented with high quality, accurate information in a timely manner, and they can use their specialist skills and expertise to home-in on the problem faster.  This can be further extended by the use of automated tooling to help the developers in the team get security feedback faster.

This blog post will focus on this last aspect. The goal of building security practice into the CI/CD system is to ensure that we minimise production change risk in security by ensuring that a minimum security bar is met.  This free's security engineers up to perform more exploritory analysis and add more intrisic value to teams based on their skill sets.

## Choosing your tooling

In the market today, there are hundreds of different peieces of software to help you automate aspects of security for your workload, with that choice available in the market this blog post cannot cover all use cases in all programming langauges being deployed to all environments.

Instead we have chosen a mixture of open source tools and AWS services that we believe represent a good start for security tooling for a variety of workloads.  As with all decisions in security, you should examine your specific workload and the threat model to your organisation before choosing the tooling you wish to choose, there are enumerate open source and commercial software tools that can assist in this process, and you should therefore choose those that work best for your workload and organisation.

## Our sample application

To deliver a concrete example of these processes, we have chosen the following AWS QuickStart as the basis for our workload, and have built our security tooling around that.



