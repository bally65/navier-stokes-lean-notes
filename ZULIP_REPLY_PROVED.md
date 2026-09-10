# 回覆：那條界證出來了（未發布）

**貼在同一串**

---

Formalized, compiles, three standard axioms. Two things to report, one of which is that I
duplicated something that was already there.

**What is genuinely absent from mathlib.** The multilinear-map-from-a-basis bound. The closest
things I found are `Module.Basis.opNorm_le` (`Analysis/Normed/Module/FiniteDimension.lean`), which
is the `n = 1` linear case with a `CompleteSpace 𝕜` hypothesis, and `Module.Basis.ext_multilinear`
(`LinearAlgebra/Multilinear/Basis.lean`), which is the qualitative "determined by values on a
basis" statement without norms. Nothing that bounds an operator norm multilinearly from basis
values.

**What I duplicated.** My second lemma, `‖x i‖ ≤ ‖x‖` on `EuclideanSpace`, is exactly
`PiLp.norm_apply_le` (`Analysis/Normed/Lp/PiLp.lean:708`). I found that only after proving it. So
the coordinate-bound hypothesis below is free for any `PiLp`, and I should have looked harder
first.

The statement, in the general form rather than hard-wired to `EuclideanSpace`, since the hypothesis
that actually matters is "a spanning family whose coordinates are bounded by the norm" — which
covers both a Euclidean factor and a sup-normed product:

```lean
theorem opNorm_le_of_coord_bound {ι : Type*} [Fintype ι] [DecidableEq ι]
    (v : ι → E) (c : E → ι → 𝕜)
    (hspan : ∀ x : E, ∑ i, c x i • v i = x)
    (hc : ∀ (x : E) (i : ι), ‖c x i‖ ≤ ‖x‖)
    {n : ℕ} (f : ContinuousMultilinearMap 𝕜 (fun _ : Fin n => E) F)
    {M : ℝ} (hM0 : 0 ≤ M) (hM : ∀ j : Fin n → ι, ‖f (fun k => v (j k))‖ ≤ M) :
    ‖f‖ ≤ (Fintype.card ι : ℝ) ^ n * M
```

and the corollary for iterated derivatives:

```lean
theorem norm_iteratedFDeriv_le_basis {d : ℕ} (f : EuclideanSpace ℝ (Fin d) → F) (n : ℕ)
    (z : EuclideanSpace ℝ (Fin d)) {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ j : Fin n → Fin d,
      ‖iteratedFDeriv ℝ n f z (fun k => EuclideanSpace.single (j k) (1 : ℝ))‖ ≤ M) :
    ‖iteratedFDeriv ℝ n f z‖ ≤ (d : ℝ) ^ n * M
```

The proof is the expected one: `opNorm_le_bound`, expand each argument with
`MultilinearMap.map_sum`, pull scalars out, and bound the `(card ι)^n` summands. It needs no
symmetry and no multi-indices — that was the point of separating it from the `∂^α` question.

Full file, 3 declarations, `#print axioms` after each, all three reporting only
`propext, Classical.choice, Quot.sound`, plus six mutation controls: attached / in the notes repo.

Two caveats I would rather state than have found. The constant `(card ι)^n` is crude; the sharp
constant is smaller and I did not chase it. And this bounds the operator norm by values on ordered
tuples, which is the direction that was not just norm equivalence — it says nothing about whether
those tuple values can be re-indexed by multi-indices, which is the `C^∞` symmetry gap I mentioned
above and which mathlib still does not have.

Happy for this to be adapted, renamed, or replaced by something better if it is wanted in mathlib;
I have no attachment to the formulation.
