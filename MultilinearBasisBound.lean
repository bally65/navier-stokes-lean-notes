/-
Copyright (c) 2026 Lean contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib

/-!
# Bounding the operator norm of a multilinear map by its values on a spanning family

A continuous multilinear map is determined by its values on a spanning family, and this file
turns that qualitative statement into a quantitative one: if every vector `x` of `E` can be
written as `∑ i, c x i • v i` for a finite family `v : ι → E` whose coordinate functionals
satisfy `‖c x i‖ ≤ ‖x‖`, then the operator norm of a continuous multilinear map
`f : E [×n]→L[𝕜] F` is at most `(Fintype.card ι) ^ n` times the supremum of the values
`‖f (v (j 1), …, v (j n))‖` over multi-indices `j : Fin n → ι`.

## Main results

* `MultilinearBasisBound.opNorm_le_of_coord_bound`: the general bound.
* `MultilinearBasisBound.euclidean_coord_bound`: the coordinate hypothesis on a Euclidean space.
* `MultilinearBasisBound.norm_iteratedFDeriv_le_basis`: the resulting bound for an iterated
  Fréchet derivative on `EuclideanSpace ℝ (Fin d)` in terms of its values along the coordinate
  directions.

## Comparison with existing results

`Module.Basis.opNorm_le` is the `n = 1` case: for a continuous *linear* map it bounds `‖u‖` by
`Fintype.card ι • ‖v.equivFunL.toContinuousLinearMap‖ * M`. Here the hypothesis `hc` replaces the
norm of the coordinate isomorphism by the explicit bound `‖c x i‖ ≤ ‖x‖`, which makes the constant
explicit and avoids the `CompleteSpace 𝕜` assumption. `Module.Basis.ext_multilinear` is the
qualitative counterpart: two multilinear maps agreeing on all tuples of basis vectors are equal.

## Implementation notes

The proof expands each argument over the family with `MultilinearMap.map_sum`, pulls the
resulting scalars out with `MultilinearMap.map_smul_univ`, and bounds the `(Fintype.card ι) ^ n`
summands individually. The factor `(Fintype.card ι) ^ n` is the cardinality of the index type
`Fin n → ι` of multi-indices, and is in general not optimal: for an orthonormal family in an
inner product space one expects a smaller constant.
-/

open Finset

namespace MultilinearBasisBound

variable {𝕜 : Type*} [NontriviallyNormedField 𝕜]
variable {E F : Type*} [NormedAddCommGroup E] [NormedSpace 𝕜 E]
  [NormedAddCommGroup F] [NormedSpace 𝕜 F]

/-- If every vector expands over a finite family with coordinates bounded by its norm, then the
operator norm of a continuous multilinear map is controlled by its values on that family. -/
theorem opNorm_le_of_coord_bound {ι : Type*} [Fintype ι] [DecidableEq ι]
    (v : ι → E) (c : E → ι → 𝕜)
    (hspan : ∀ x : E, ∑ i, c x i • v i = x)
    (hc : ∀ (x : E) (i : ι), ‖c x i‖ ≤ ‖x‖)
    {n : ℕ} (f : ContinuousMultilinearMap 𝕜 (fun _ : Fin n => E) F)
    {M : ℝ} (hM0 : 0 ≤ M) (hM : ∀ j : Fin n → ι, ‖f (fun k => v (j k))‖ ≤ M) :
    ‖f‖ ≤ (Fintype.card ι : ℝ) ^ n * M := by
  refine ContinuousMultilinearMap.opNorm_le_bound (mul_nonneg (by positivity) hM0) fun m => ?_
  -- Expand every argument over the family and pull the scalars out of `f`.
  have hexp : f m = ∑ j : Fin n → ι, (∏ k, c (m k) (j k)) • f (fun k => v (j k)) := by
    have hm : m = fun k => ∑ i, c (m k) i • v i := funext fun k => (hspan (m k)).symm
    calc f m = f.toMultilinearMap (fun k => ∑ i, c (m k) i • v i) := by
              rw [ContinuousMultilinearMap.coe_coe, ← hm]
      _ = ∑ j : Fin n → ι, f.toMultilinearMap (fun k => c (m k) (j k) • v (j k)) :=
              f.toMultilinearMap.map_sum (fun k i => c (m k) i • v i)
      _ = ∑ j : Fin n → ι, (∏ k, c (m k) (j k)) • f (fun k => v (j k)) := by
              refine Finset.sum_congr rfl fun j _ => ?_
              rw [f.toMultilinearMap.map_smul_univ, ContinuousMultilinearMap.coe_coe]
  -- Each of the `(Fintype.card ι) ^ n` summands is bounded by `(∏ k, ‖m k‖) * M`.
  have hterm : ∀ j : Fin n → ι,
      ‖(∏ k, c (m k) (j k)) • f (fun k => v (j k))‖ ≤ (∏ k, ‖m k‖) * M := by
    intro j
    rw [norm_smul, norm_prod]
    exact mul_le_mul (Finset.prod_le_prod (fun k _ => norm_nonneg _) fun k _ => hc (m k) (j k))
      (hM j) (norm_nonneg _) (Finset.prod_nonneg fun k _ => norm_nonneg _)
  calc ‖f m‖ = ‖∑ j : Fin n → ι, (∏ k, c (m k) (j k)) • f (fun k => v (j k))‖ := by rw [hexp]
    _ ≤ ∑ j : Fin n → ι, ‖(∏ k, c (m k) (j k)) • f (fun k => v (j k))‖ := norm_sum_le _ _
    _ ≤ ∑ _j : Fin n → ι, (∏ k, ‖m k‖) * M := Finset.sum_le_sum fun j _ => hterm j
    _ = (Fintype.card ι : ℝ) ^ n * M * ∏ k, ‖m k‖ := by
        rw [Finset.sum_const, Finset.card_univ, Fintype.card_fun, Fintype.card_fin,
          nsmul_eq_mul, Nat.cast_pow]
        ring

#print axioms MultilinearBasisBound.opNorm_le_of_coord_bound

/-- The Euclidean instance of the coordinate hypothesis. -/
theorem euclidean_coord_bound {d : ℕ} (x : EuclideanSpace ℝ (Fin d)) (i : Fin d) :
    ‖x i‖ ≤ ‖x‖ := PiLp.norm_apply_le x i

#print axioms MultilinearBasisBound.euclidean_coord_bound

/-- The corollary for iterated Fréchet derivatives on a Euclidean space: the operator norm of the
`n`-th derivative is bounded by its values along coordinate directions. -/
theorem norm_iteratedFDeriv_le_basis {d : ℕ} {F : Type*} [NormedAddCommGroup F]
    [NormedSpace ℝ F] (f : EuclideanSpace ℝ (Fin d) → F) (n : ℕ)
    (z : EuclideanSpace ℝ (Fin d)) {M : ℝ} (hM0 : 0 ≤ M)
    (hM : ∀ j : Fin n → Fin d,
      ‖iteratedFDeriv ℝ n f z (fun k => EuclideanSpace.single (j k) (1 : ℝ))‖ ≤ M) :
    ‖iteratedFDeriv ℝ n f z‖ ≤ (d : ℝ) ^ n * M := by
  have hspan : ∀ x : EuclideanSpace ℝ (Fin d),
      ∑ i, x i • EuclideanSpace.single i (1 : ℝ) = x := by
    intro x
    ext j
    simp [EuclideanSpace.single, Pi.single_apply, mul_ite]
  have key := opNorm_le_of_coord_bound (𝕜 := ℝ) (E := EuclideanSpace ℝ (Fin d))
    (fun i => EuclideanSpace.single i (1 : ℝ)) (fun x i => x i) hspan
    (fun x i => euclidean_coord_bound x i) (iteratedFDeriv ℝ n f z) hM0 hM
  rwa [Fintype.card_fin] at key

#print axioms MultilinearBasisBound.norm_iteratedFDeriv_le_basis

end MultilinearBasisBound
