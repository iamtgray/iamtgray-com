---
title: "Data-Centric Security: Building a Knowledge Resource"
date: 2026-02-26T22:28:34+00:00
draft: false
---

I've been working in and around data-centric security for a while now. It's a topic that matters enormously — especially in coalition and multi-national contexts where you need data to flow between organisations at different classification levels, while the security travels *with* the data rather than relying on perimeter controls.

The problem I kept running into was that the available information fell into two camps. On one side, you have academic papers — brilliant thinking about zero-trust data formats, attribute-based access control, and federated key management — but written without the reality of having to actually implement these things on real infrastructure. On the other side, you have vendors who've built products that solve a piece of the puzzle, but whose documentation is (understandably) focused on selling you their solution rather than explaining the underlying concepts.

Nobody could just explain to me what data-centric security *is*, how the three levels work (labelling, access control, encryption), what NATO STANAGs like ACP-240 actually require, or how you'd go about building this on cloud infrastructure.

So I built [datacentricsecurity.org](https://datacentricsecurity.org).

The site covers the fundamentals — what DCS is, why it matters, and the three progressive levels of implementation. But it also includes hands-on labs that walk you through building each level on AWS, reference architectures with Terraform, and operational scenarios that describe real coalition data-sharing challenges.

The goal is to show what *is* possible using cloud technologies today. You can implement DCS Level 1 (labelling) with S3 object tags and Lambda. Level 2 (access control) works with Amazon Verified Permissions evaluating user attributes against data labels. Level 3 (encryption) uses OpenTDF on ECS with AWS KMS for persistent cryptographic protection that follows the data wherever it goes.

There are gaps — federated key management across sovereign boundaries is still hard, and STANAG compliance in tactical disconnected environments needs more work. But the site lays out what's achievable now and where the boundaries are.

If you work in defence, intelligence, or any domain where information sharing across trust boundaries matters, I hope it's useful. The source is open and contributions are welcome.
