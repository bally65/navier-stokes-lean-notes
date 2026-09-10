# Notes from a Lean formalization of Navier–Stokes local regularity theory

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.22684542.svg)](https://doi.org/10.5281/zenodo.22684542)


This repository contains four documents. It does not contain the formalization itself, which is not
ready to publish. What is here is the part that stands on its own: an independent verification of
someone else's public work, a methods note on gating AI-generated Lean, and one open Lean statement
we are stuck on and would like help with.

**Read the claim scope first.** [`CLAIM_SCOPE.md`](CLAIM_SCOPE.md) states what the underlying work
proves and, at more length, what it does not. The short version: it proves a quantitative dichotomy
that is one ingredient of Caffarelli–Kohn–Nirenberg theory, together with the singular-integral
apparatus underneath it. It does **not** prove ε-regularity, it does **not** prove partial
regularity, it says nothing about global existence or smoothness, and it has no bearing on the Clay
Millennium Prize problem. Everything is conditional on a solution class whose only exhibited
inhabitant is the zero solution.

## The documents

**[`OPEN_PROBLEM_CHAIN_RULE.md`](OPEN_PROBLEM_CHAIN_RULE.md)** — the one we would most like a reply
to. A chain rule for a smooth outer function composed with a vector field known only to have a weak
gradient, stated in Lean. We have already reduced the unregularised case to this one, and the
control that reverses that reduction fails to compile, so the reduction carries content. We also
measured that mathlib currently has no weak-derivative or Sobolev theory under the obvious names
and no mollification. If we have missed an existing route, we would rather be corrected than
proceed: wrong absence claims are the single most common error in this project's log.

**[`AUDIT_OPENAI_NAVIERSTOKES_EULER.md`](AUDIT_OPENAI_NAVIERSTOKES_EULER.md)** — an independent
audit of `openai/NavierStokesAndEuler`, performed on one machine with the commands given. Its
statements are byte-identical to the `google-deepmind/formal-conjectures` upstream at a pinned
commit; the periodic pressure condition matches the official Clay errata; the trust base contains
no axioms, no `native_decide`, and no `sorry` outside documented placeholders; both targets build,
20010 jobs in total, and all four theorems depend only on `propext`, `Classical.choice` and
`Quot.sound`. It also records a build failure we reported and then traced to our own concurrent
builds, because a retraction that is deleted is not a retraction.

**[`GATING_AI_GENERATED_LEAN.md`](GATING_AI_GENERATED_LEAN.md)** — how we gate units written by AI
agents, and every way we have watched that gate be fooled: harnesses reporting green because they
never ran, an axiom check defeated by a wrapped log line, controls that break syntactically before
they break mathematically, mutations that leave a true statement, decorative hypotheses, and shell
tools that summarise their own output. It ends with what mutation controls cannot do at all, which
is detect a vacuous statement.

## Why these three and not the code

The formalization is large and mostly the record of a superseded approach. Publishing it as a dump
would not let anyone evaluate it in ten minutes, and would invite exactly the overclaim reading the
claim scope is written to prevent. These three documents can be checked on their own terms: the
audit by re-running its commands, the methods note against your own experience, and the open problem
by anyone who knows the relevant mathlib.

## Citing

If you refer to these notes, cite the archived record:

> Li, Wei-Ting (2026). *Notes from a Lean formalization of Navier–Stokes local regularity theory:
> claim scope, an independent audit, a methods note, and one open statement*. Zenodo.
> https://doi.org/10.5281/zenodo.22684542

The DOI above resolves to the latest version. `CITATION.cff` carries the machine-readable form.

## Contact

Open an issue. Corrections are more useful to us than agreement, particularly on the open problem
and on anything in the audit that does not reproduce.

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
