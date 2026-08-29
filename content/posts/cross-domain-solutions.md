---
title: "Cross-Domain Solutions: Explaining What Nobody Would"
date: 2026-04-22T16:54:17+03:00
draft: false
---

Cross-domain solutions are one of those topics where the gap between "people who know" and "people who need to know" is enormous. If you're an architect or engineer who's been told you need a CDS in your design, good luck finding a clear explanation of what that actually means.

I hit this wall repeatedly. The academic literature is thorough but dense — PhD papers on information flow control, formal verification of guard policies, covert channel analysis. Valuable work, but not what you need when you're trying to understand whether your architecture needs a data diode or a guard, or what a protocol break actually does to your data flow.

I wanted something that would explain to an architect or engineer: what is a CDS, how does it differ from a firewall, what are the three types (access, transfer, and multi-level), what does a protocol break actually do, what are the twelve-plus treatment types in a CDS pipeline, and how does security enforcement work with labels and access control.

So I built [xdomainsolutions.org](https://xdomainsolutions.org).

The site starts from first principles — the definition, the history, why it exists — and builds up to the technical detail. It covers data flow models (unidirectional, bidirectional, multi-level), the mechanics of protocol break, content inspection and transformation, and security label standards like NATO STANAGs 4774 and 4778.

If you're designing systems that cross security boundaries — whether that's classification levels, organisational boundaries, or regulatory domains — I hope this helps fill the gap that frustrated me for so long, it's definitely not fished yet (at the time of writing) I still want to build out some labs that let you create practical examples in the cloud of things like protocol breaks and the like - but it's a start, and I hope it's useful!
