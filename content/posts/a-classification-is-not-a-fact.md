---
title: "A Classification Is Not a Fact"
date: 2026-08-21T09:00:00+00:00
draft: false
---

When two countries both stamp a document "SECRET", they are not describing the same thing, and it appears that often they are not even describing the same _kind of thing_. I want to lay out the thinking here and the research I've done across a series of posts - because while I've been working on this I've come across some really interesting bits of information.

Most of us treat "SECRET" as a property of the information, the way "boiling" is a property of water (at sea level) at 100 degrees centigrade. But, a classification marking is the output of a _risk judgement_. It is a statement that someone decided the information belongs to a defined *category of risk*, so the label really describes the decision rather than the document itself.

That distinction is then interesting because a risk judgement has more than one dimension, and a single word (or in this case, classification) smooshes all of those varied dimensions into a single one.

If you pull a classification apart then there seem to be three separable components:

* The first is *how bad* compromise would be: severity, the ladder from RESTRICTED up to the top tier, the "grave damage" and "exceptionally grave damage" wording that most national systems share. 
* The second is *what kind* of harm it is: a threat to someone's life, an economic loss, a diplomatic problem, a privacy breach. These might all have the same severity, but very different harm
* The third is *how long* the harm lasts, which is the component almost no system writes down.

As I've been researching the comparison of different classification systems, patterns and practices that countries use - they seem to broadly agree on the first one (how bad) and really diverge on the last two..

Duration is the clearest example. A unit's position on a battlefield is lethal _now_ and worthless _in a week_. A human intelligence source can be exposed and killed decades after the fact. Those two secrets are opposites in how long they stay dangerous, and both can carry the same top-tier marking that (by itself) can't tell the two things apart.

This matters if you build or secure IT systems, because it exposes a habit that customers have.. We protect data by its label, attaching controls to the word SECRET: this bucket, this network, this key management, this hosting regime. What we rarely do is protect data by the actual shape of its risk, or by how long it is genuinely worth protecting. We inherit the marking and treat it as the whole story, when it is a compressed summary that has discarded two of its three dimensions.

You can't translate a classification by matching the word between (or even inside) countries. The UK, the US, France and Greece do not even run the same number of classification levels. France has two national levels, the UK and US have three, Greece keeps a fifth tier above the top. And the three-tier systems are not the same three: UK SECRET absorbs two of NATO's bands, so a partner reading "UK SECRET" cannot tell from the label alone whether the underlying sensitivity is peer-level SECRET or would sit a rung lower elsewhere. Now in practice this is a solved problem, people exposed to such information might have systems that help them understand where the different classification systems sit together - and there really aren't many people I could imagine who might have simultanious access to multiple countries classified files and _not_ have them standardised against a coalition (NATO/FVEYS or something else) classification system.

Apart from that though, countries actually disagree as to what classification is *for*. Take the principle that you "classify to protect the nation and never to spare yourself embarrassment". The US has an EO around this: [Executive Order 13526](https://www.archives.gov/isoo/policy-documents/cnsi-eo.html) that prohibits classifying to conceal wrongdoing or avoid embarrassment, but that is a US position rather than a universal rule.. The UK's OFFICIAL-SENSITIVE marking explicitly covers damage to the reputation of the organisation or of the government. So the same document can be a legitimate secret in one country and an abuse of the system in another..

So the label is not a measurement, instead it's a category of risk that a particular country (with its own rules and its own idea of what harm even counts) decided the information belongs to. Change the country and you change the category, sometimes the number of categories, and occasionally whether the category is permitted to exist at all.

We're going to go on a bit of a journey together as these posts evolve (and so does my thinking I've no doubt) as my research deepens.

Fundamentally what I want to do, is when I say to a customer "go off, start thinking about risk/reward trade-off and threat based thinking when it comes to your data" and they say "how", I have a better answer than to say: "go look at what Country X did"..