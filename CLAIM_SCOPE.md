# Claim scope

*This page states what this work claims and, more importantly, what it does not. It is meant to be
read before anything else in the repository. If any other document here appears to claim more than
this page allows, this page is correct and that document is wrong.*

## The one-paragraph version

This is a Lean 4 + mathlib formalization of parts of the local regularity theory for the
three-dimensional incompressible Navier–Stokes equations, following Lin (1998) and Vasseur (2007).
It proves a quantitative dichotomy that is one ingredient of that theory, together with the
singular-integral apparatus underneath it. It does **not** prove ε-regularity, it does **not**
prove partial regularity, it says nothing about global existence or smoothness, and it has no
bearing on the Clay Millennium Prize problem. Everything here is conditional on a solution class
whose only exhibited inhabitant is the zero solution.

## What is proved

Every item below is machine-checked, and every declaration in the repository is followed by
`#print axioms`. Where a statement is conditional, the condition is a named hypothesis in the
statement itself, not an assumption buried in prose.

- **A quantitative form of Lin's Theorem 3.3 on ℝ³.** For the scaled quantities `A` (velocity
  energy) and `D` (pressure), writing `X = A^{3/2} + D²`, there is an absolute `θ₀ ≤ 1/8` and a
  finite constant `C` such that, when the scaled dissipation is small at the ambient scale, either
  `X` at least halves at the next scale or `X` is already bounded by `C · B^{3/2}`. A second form
  takes Lin's `limsup` hypothesis and produces the dichotomy at every radius below some `r₀`.
- **The three inequalities it composes**, each on ℝ³: Lin's (3.17) in the sharp exponent, his
  centred energy budget (3.19), and his centred pressure recurrence (3.20).
- **A Calderón–Zygmund and Riesz layer on ℝ³**: dyadic cubes with a stopping time, the
  decomposition, a weak (1,1) bound, the double Riesz operator, its boundedness on `L^{3/2}`, and
  the identification of the multiplier with the homogeneous kernel.
- **The elementary layer of Vasseur's De Giorgi route**: his level sets and shrinking cylinders,
  his iteration lemma, the pointwise content of his Lemma 10, and a reduction of the chain rule for
  `‖v‖` to its regularised (smooth outer function) case.

## What is not proved, stated as flatly as possible

- **No ε-regularity.** The step that would convert smallness of scaled quantities into a bound on
  the velocity is not attempted anywhere in this repository.
- **No partial regularity.** Nothing here bounds the size of a singular set. In particular nothing
  here reaches the conclusion of Caffarelli–Kohn–Nirenberg.
- **No global existence, no global smoothness, no Clay conclusion.** The Clay problem asks about
  smooth solutions for all time. This work does not address it, and a result about partial
  regularity would not address it either, since a singular set of measure zero is not an empty one.
- **No existence theorem for the class.** The solution class is defined axiomatically. The only
  inhabitant exhibited in this repository is the zero solution. There is no Leray–Hopf existence
  theorem here, so every statement should be read as "for any object satisfying these axioms",
  not as "for the solutions of Navier–Stokes that are known to exist".
- **The De Giorgi route is not complete.** Its central obligation, the level-set energy inequality,
  is not proved and is not even stated, because stating it requires a modelling decision about the
  pressure term that has not been made. The chain rule it needs is carried as a named open
  hypothesis, `CknVasseurAbsChainRule`, reduced but not discharged.

## Conditionality, in one place

| Item | Depends on |
|---|---|
| The Theorem 3.3 dichotomy | the axiomatic solution class, including its local energy inequality |
| The De Giorgi pointwise layer | the same class |
| Anything downstream of the chain rule | `CknVasseurAbsChainRule`, an open hypothesis |

## How it was produced

The great majority of this development was written by AI agents under a human-directed campaign,
with each unit gated before it was accepted: recompiled independently of the agent that wrote it,
checked for non-standard axioms, and accompanied by negative controls in which a single statement
is mutated and required to break the proof. The gate numbers are recorded per unit. The controls
themselves are not currently part of the published tree.

This should be taken into account when reading the repository. Machine checking establishes that
the proofs follow from the statements; it establishes nothing about whether the statements are the
right ones, and the statements are where the human judgement, and therefore the risk, lives.

## Independent verification of other work

This repository also contains an audit of a third party's public formalization. That audit reports
only what was measured on this machine: file-level comparison against the upstream statements it
reuses, the axioms its theorems depend on, and whether it builds. It is not a mathematical review
of that work, and one build failure reported during the audit was traced to this machine's own
concurrent builds and retracted.

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
