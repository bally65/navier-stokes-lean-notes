# One open Lean statement: the chain rule for `‖v‖` under a bespoke weak-gradient hypothesis

*Draft for the Lean Zulip / a repository issue. Not sent. Prepared 2026-09-10.*

## What this is

We are formalizing the Caffarelli–Kohn–Nirenberg partial-regularity theory for the
three-dimensional Navier–Stokes equations in Lean 4 + mathlib, following Lin (1998) for the
quantitative half and Vasseur (2007) for the De Giorgi route toward ε-regularity. We are stuck on
one statement, and it looks like a statement other people may already know how to do.

**What is proved so far, and nothing beyond it.** A quantitative version of Lin's Theorem 3.3 on
ℝ³ (a geometric dichotomy for `A^{3/2} + D²`), the Calderón–Zygmund and Riesz apparatus underneath
it, and the elementary layer of Vasseur's Lemma 10. **Not** ε-regularity, **not** partial
regularity, and the whole development is conditional on a solution class whose only exhibited
inhabitant is the zero solution.

## The statement

The solution class carries its weak gradient as a field, characterised by integration by parts
against smooth compactly supported test functions on a cylinder `Q`:

```lean
weak_gradient_identity : ∀ (i j : Fin 3) (φ : CKNLocalTest Q),
    ∫ z in Q.set, gradient z (i, j) * φ.value z
      = - ∫ z in Q.set, velocity z i * φ.spatialGradient z j
```

We need the chain rule for the Euclidean norm of the velocity. Because `‖·‖` is not differentiable
at the origin we regularise, and the open statement is the regularised one, where the outer
function is smooth:

```lean
def CknVasseurAbsChainRuleEps (s : CKNLocalSuitableWeakSolution Q ν) : Prop :=
  ∀ ε : ℝ, 0 < ε → ∀ (j : Fin 3) (φ : CKNLocalTest Q),
    ∫ z in Q.set, cknVasseurGradAbsEps ε s.velocity s.gradient z j * φ.value z
      = - ∫ z in Q.set, cknVasseurNormEps ε s.velocity z * φ.spatialGradient z j
```

where `cknVasseurNormEps ε u z = √(‖u z‖² + ε²) − ε` and
`cknVasseurGradAbsEps ε u G z j = (∑ i, u z i * G z (i,j)) / √(‖u z‖² + ε²)`.

**We have already reduced the unregularised case to this one.** `cknVasseurAbsChainRule_of_eps`
proves that the `ε > 0` family implies the `ε = 0` statement, by dominated convergence: the
regularised gradient obeys a Cauchy–Schwarz bound uniform in `ε`, and converges pointwise
everywhere, including where the field vanishes (there the numerator is identically zero, so it is
algebra rather than a limit). The control that reverses that implication fails to compile, so the
reduction carries content.

So the whole remaining question is: **a chain rule for a smooth outer function composed with a
vector field that is only known to have a weak gradient in the above sense.**

## Why it is not immediate here

Measured on our tree (mathlib pinned in `lake-manifest.json`), with the commands in the repository:

| searched for | files in mathlib |
|---|---|
| `HasWeakDeriv`, `WeakDeriv`, `SobolevSpace`, `MemW` | 0 |
| mollification (`mollif`) | 0 |
| `ContDiffBump` | 8 |

The one chain rule available to us is `sobolev_chain_rule` in the `DeGiorgi` dependency package,
but it is stated for a **univariate** outer function `Φ : ℝ → ℝ` composed with a **scalar** Sobolev
function on a **ball**, with its own `MemW1pWitness`. Our outer function is multivariate, our field
is vector-valued in space-time, and our weak-gradient notion is the class's own.

## What we are asking

1. Is there an existing route to this in mathlib that we have missed? A wrong absence claim is the
   single most common error in this project's log, so we would rather be corrected than proceed.
2. If it genuinely is not there, what should it look like? The natural general statement is a chain
   rule for `C¹` outer functions against a distributional-gradient hypothesis, which would want a
   mollification API that mathlib does not currently have. Would that be welcome upstream, and in
   what form?
3. Separately: the ℝ³ Calderón–Zygmund decomposition, weak (1,1) bound and Riesz operator we built
   underneath this have no counterpart in **mathlib** (measured: zero files for Calderón, Zygmund,
   weak type, Riesz transform, maximal function). They are not without precedent in **Lean**,
   however: `fpvandoorn/carleson` develops Calderón–Zygmund theory in the doubling metric measure
   setting, and its `WeakCalderonZygmund` file carries no `sorry`. We have not yet measured how
   much of our layer that subsumes once specialised to ℝ³, and that measurement should come before
   we propose anything upstream. Pointers welcome.

## Reproducing

Lean toolchain and mathlib revision are pinned in the repository. The statement above is in
`ContactGeometryLean/C3571_R3VasseurAbsChainRuleReduction.lean`, the reduction is
`cknVasseurAbsChainRule_of_eps` in the same file, and every declaration is followed by
`#print axioms`, all reporting only `propext`, `Classical.choice`, `Quot.sound`.

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
