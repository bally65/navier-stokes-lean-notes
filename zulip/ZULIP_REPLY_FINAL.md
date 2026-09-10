# 貼文（回覆既有討論串，未發布）

**貼在**：`general` → `Independent verification of OpenAI NavierStokesAndEuler`
（不要開新主題；Jason Rute 已經在請大家把散落的訊息集中到這串）

---

Two small things I can add, and an attempt at the question @Tomas Skrivan and @Bilal raised about
`iteratedFDerivWithin` versus Clay's mixed partials, since that seems to be the open one.

**1. The copy is exact, not almost.** I diffed `NavierStokes/ComparatorDefinitions.lean` against the
upstream `FormalConjectures/Millenium/NavierStokes.lean` at the commit it pins, `8bf45ed7`: the
definition block is 152 upstream lines against 151 local, and the only difference is that upstream
continues into its theorem statements while the copy ends with `end`. The two shipped theorem
statements are character-identical to the upstream ones.

**2. One condition that is stricter than the printed problem, and correctly so.** The periodic
solution predicate additionally requires the pressure to be periodic. That is not in the printed
(10)/(11). It is in the official errata to Fefferman's problem description: *"The further condition
`p(x + eⱼ, t) = p(x, t)` should be made explicit in Eqn (8)."* Since the theorems are negations, a
stricter solution predicate makes the claim weaker, so this is a place worth being explicit about —
but it follows the corrected official statement, and it comes from the upstream formalization rather
than from the submission.

**3. On `iteratedFDerivWithin` versus `∂_x^α ∂_t^m f`.** I think the equivalence goes through, and
the norm-equivalence intuition is the right one, but the part that actually needs checking is not
the norms — it is the quantifier shape and the boundary. Concretely:

- Clay bounds each mixed partial separately, indexed by `(α, m)`. The Lean condition bounds
  `‖iteratedFDerivWithin ℝ n (↿f) (univ ×ˢ Ici 0) (x,t)‖` for each total order `n`. Each mixed
  partial with `|α| + m = n` is that iterated derivative evaluated at basis vectors, so it is
  bounded by the operator norm: Clay's condition follows from Lean's, with the same constant.
- Conversely the `n`-th iterated derivative is multilinear on a finite-dimensional space, so its
  operator norm is bounded by a finite sum of the `|∂_x^α ∂_t^m f|` with `|α| + m = n`, times a
  combinatorial constant depending only on `n` and the dimension — not on the point. Since both
  statements are "for every order and every `K` there exists a constant", that constant is absorbed.
  So Lean's condition follows from Clay's too.
- The part I would actually want checked in Lean, rather than argued: the `within` on
  `univ ×ˢ Ici 0`. At interior times this is the ordinary derivative; at `t = 0` it is one-sided,
  which matches Clay's `[0, ∞)`. For `iteratedFDerivWithin` to be the canonical object here one
  needs `UniqueDiffOn ℝ (univ ×ˢ Ici 0)`, which holds since that set is convex with nonempty
  interior — but that is exactly the kind of side condition where a formalization can silently
  differ from the intended statement, so it seems worth stating explicitly rather than assuming.

If it would help, the direction that is not just norm equivalence is the second bullet, and it is a
finite sum over multi-indices; I am happy to write that one out properly if nobody else has.

For what it is worth, I also built both targets independently on one machine: `NavierStokes` 9407
jobs and `Euler` 10603 jobs, no errors, no `sorry` warnings, and all four theorems reporting only
`propext`, `Classical.choice`, `Quot.sound` — consistent with what @Sebastián Rodrigo found. One
correction on my own side, since a false report is worse than none: my first `Euler` build failed
with five missing-`.olean` errors, and that turned out to be my own three concurrent builds writing
into one directory, not a problem with the repository. A single-process rerun passed.

Write-up with the commands: https://github.com/bally65/navier-stokes-lean-notes
