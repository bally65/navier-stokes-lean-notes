# 回覆「mathlib 有沒有多重指標導數」（未發布）

**貼在同一串**

---

I went and checked rather than guessing, and the answer is worse than "no": the thing that is
missing is not notation, it is a theorem.

**mathlib has no multi-index derivative.** Searching `Mathlib/Analysis/` for `multi-index`,
`multiIndex`, `MultiIndex`, `partialDeriv`, `partial_deriv`, `iteratedPartial` returns zero files.
What exists is `iteratedFDeriv`, the `n`-th derivative as a continuous multilinear map, and you get
at a partial derivative by evaluating it on a tuple of basis vectors:
`iteratedFDeriv ℝ n f z ![e_{j₁}, …, e_{jₙ}]`. That is an **ordered tuple**, not a multi-index.

**To turn ordered tuples into multi-indices you need symmetry of the `n`-th derivative, and mathlib
has that only for analytic functions.** What is there:

- `IsSymmSndFDerivWithinAt` and friends in `Analysis/Calculus/FDeriv/Symmetric.lean` — the **second**
  derivative, at `C²`-ish regularity. This is the classical Schwarz theorem.
- `ContDiffWithinAt.domDomCongr_iteratedFDerivWithin` and
  `ContDiffAt.domDomCongr_iteratedFDeriv` in `Analysis/Analytic/IteratedFDeriv.lean`, which do give
  invariance under an arbitrary `σ : Perm (Fin n)` — but their hypothesis is `ContDiffWithinAt 𝕜 ω`,
  and `ω` is the analytic level, above `∞` in mathlib's scale. Not `C^∞`.

So for a `C^∞` function, mathlib currently gives symmetry in two slots and not in `n`. Defining
`∂^α` for `C^∞` functions means proving that
`iteratedFDeriv ℝ n f z (v ∘ σ) = iteratedFDeriv ℝ n f z v` for every `σ : Perm (Fin n)` at
`C^∞` regularity, which should follow from the second-derivative case since adjacent transpositions
generate `Perm (Fin n)` and `iteratedFDeriv` is built by iterating `fderiv` — but it does not appear
to be there, and "should follow" is exactly the phrase this thread is trying to eliminate.

**Two consequences, which I think separate cleanly.**

*The operator-norm bound does not need any of this.* It is a statement about ordered tuples:
`‖D^n f(z)‖ ≤ 4ⁿ · max over tuples ‖D^n f(z)(e_{j₁}, …, e_{jₙ})‖`, with the reverse direction from
`ContinuousMultilinearMap.le_opNorm`. No symmetry, no multi-indices. I am formalizing it in the
general form — a spanning family whose coordinates are bounded by the norm, which covers both the
Euclidean factor and the sup-normed product — and will post it when it compiles. mathlib has
`opNorm_le_bound` and `le_opNorm` but nothing that bounds the operator norm from values on a basis,
as far as I can tell.

*Stating Clay's condition faithfully does need it*, if one wants `∂^α` as an object rather than a
family of tuples. There is a cheaper route: read Clay's "for all `α`, `m`" as "for all ordered
tuples", since the map from tuples to multi-indices is surjective and Clay quantifies universally
either way. That is defensible, but it is a modelling decision that should be written down rather
than passed over, because it is precisely the place where the informal and formal statements are
being identified.

If someone wants it, the missing mathlib lemma seems worth having on its own:
`n`-th order symmetry of `iteratedFDeriv` at `C^∞` rather than `C^ω`. That is a self-contained
target and it is what would let `∂^α` be defined properly.
