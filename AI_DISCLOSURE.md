# Disclosure of machine assistance

Most of the Lean development behind these notes was written by AI agents working under a
human-directed process, and much of the prose in this repository was drafted the same way. This is
stated here rather than in a footnote because it changes how the work should be read.

## What that does and does not mean

Every Lean unit was accepted only after being recompiled independently of the agent that produced
it, checked for non-standard axioms, and accompanied by negative controls in which a single
statement is mutated and required to break the proof. Those gate numbers are recorded per unit.

Machine checking establishes that each proof follows from its statement. It establishes nothing
about whether the statement is the intended one. Statement design is where the human judgement, and
therefore the risk, lies, and `GATING_AI_GENERATED_LEAN.md` describes the ways this project's own
gate has been fooled.

## Authorship

The author listed in `CITATION.cff` directed the work, made the route and statement decisions, and
is responsible for the claims. AI systems are tools here and are not listed as authors, in line with
the position taken by most journals. Individual commits in the underlying repository carry a
co-authorship trailer identifying the assisting model, which is a provenance record, not a claim of
authorship.

## What has not been decided

Affiliation, corresponding-author details, acknowledgements, and any funding statement are left
blank deliberately. They are for the author to supply and were not filled in on his behalf.
