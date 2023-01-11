---
title: "Giving MSP's access to your keys? They should be automating.."
date: 2023-01-10T20:11:14+01:00
draft: false
---


Recently reading a [blog post on the NCSC blog](https://www.ncsc.gov.uk/blog-post/using-msps-to-administer-your-cloud-services) regarding how organisations should choose their managed service proviers (MSP's) I found the guidance (while appropriate) not as in-depth as I would want to be in recipt of if I was a public sector customer looking to choose an MSP that was 'right for me'.

So let's do a quiz of 'is this MSP the right MSP for me to go to bed with'?

# 1. Do they seperate their customers?

MSP's are a deeper and more attractive target for attckers because of the nature of their multiplied connections in to end-customers environments.  Therefore the controls and guardrails that they need to have in place as organisations are likely higher than what ever organisation you're operating in.  AWS say that "data has gravity" that's true in a computational sense as much as it is in security. 

In my experience, many MSP's don't seperate out the controlling powers for their customer environments - for example they might have an operational team, and that team might have a single device that grants access to all customer environments through the use of role federation - while that's not a bad practice in and of itself (it's actually reccomended practice) it opens a security challenge that needs to be thought about.

Assuming that the MSP has access to control your high level environment, then if the MSP suffers a severe breach that allows an attacker to escalate themselfes into the management account for their organisation, and your accounts sit under that management account, then the attacker can gain control of your accounts. 

Doing so however requires some prequisities, and putting in controls to prevent this is relatively easy:

## 1.1 Least privilige MSP

Does your MSP's environment need priviliges to deploy into your AWS account? If so, can you limit those privileges to only what's needed?  Traditionally using the AWS for example the `OrganizationAccountAccessRole` has the `AdministratorAccess` role on your AWS account, consider changing the privileges associated with the role used by the MSP to access your account to limit the privileges

## 1.2 Applying guard rails

Have the MSP apply limits to what services they can use (called service control policies in AWS) to prevent modification of things like root MFA, or account level details without a break-glass requirement.


# 2. Do they operate at arms length?

Too often I see MSP's operate highly manual processes and controls - they rely on well-documented run-books and human action over automation as it's cheaper to implement (up-front) and easier for everyone to understand.  You don't need specialists if their role requires only to follow a set of prescribed steps.

What I like about MSP's who use automation on the other hand, is that not only do they employ specialists - but most likely they have had to think about 'the corner cases' more than the writer of a given run-book.  If they are experienced in running managed services, then they have automation that should cover the vast majority of standard change that they perform (think ITIL standard here) 

# 3. What's their view on reviews?

When I'm talking about reviews here, I am thinking about reviews provided by your cloud supplier (think Well-Architected for example) these reviews can be incredibly powerful in ensuring that you've got the right operational readiness between you and your MSP.

It's also difficult to hide your practices that are less optimal in an end-to-end review of their service menagement status.

# 4. Check their partner status

If the MSP you're chosing is a partner of a large cloud provider like AWS, then ensure that they have the appropriate certifications from that cloud provider.  In the example of an AWS based MSP, AWS offer the "Managed Service Provider" competency and "Security managed service provider" competency - having completed numerous reviews of businesses wanting to achieve or renew their certification in both or either, I can personally speak to the extremely high bar that is required to maintain this certification.

A simple way to describe it, should be that the AWS Solutions Architect who is working on the review "should be impressed" by the methodologies, automation and practices of the partner hoping to achieve MSP status.


