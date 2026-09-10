# 修正（未發布）

**貼在同一串，回覆 Luigi Massacci**

---

Thanks — you are right and my search was on the wrong names. I grepped for `multi-index`,
`partialDeriv` and friends, which is exactly the mistake of searching for the name I imagined
rather than the shape of the thing. Correcting, and the correction is more interesting than the
original claim.

**What is actually there.** `LineDeriv.iteratedLineDerivOp` in
`Mathlib/Analysis/Distribution/DerivNotation.lean:54`, with the notation `∂^{v}`:

```lean
def iteratedLineDerivOp {n : ℕ} : (Fin n → V) → E → E :=
  Nat.recOn n (fun _ ↦ id) (fun _ rec y ↦ LineDeriv.lineDerivOp (y 0) ∘ rec (tail y))
```

So it takes `Fin n → V`, an **ordered list of directions**, and repeated differentiation in one
direction is a repeated entry — there is a lemma for exactly that,
`iteratedLineDerivOp_const_eq_iter_lineDerivOp` at :89. It needs `[LineDeriv V E E]`, and in this
mathlib the instances are for `𝓓(Ω,F)`, `𝓓'(Ω,F)`, `𝓢'(E,F)` and `𝓢(E,F)` only — which is your
point about bare functions having no instance.

**So the substantive part of what I said survives, but for a different reason than I gave.** The
gap is not that the notation is missing; it is that `Fin n → V` is a list, not a multi-index, and
nothing in this mathlib is indexed by `ι → ℕ` or `ι →₀ ℕ` for the purpose of differentiation. I
searched by shape this time rather than by name: `→₀` intersected with `deriv` in `Analysis` gives
zero hits; `→ ℕ` intersected with `deriv` gives only two incidental hits inside the Faà di Bruno
file; `MvPolynomial.pderiv` has a `σ →₀ ℕ` but that is a monomial exponent, not a differentiation
multi-index, and it has no iterated form. Going from a list to a multi-index is still the symmetry
step, and that is still only available at `C^ω` (`ContDiffWithinAt.domDomCongr_iteratedFDerivWithin`
in `Analysis/Analytic/IteratedFDeriv.lean`), not at `C^∞`.

**One thing I found while checking that seems worth flagging for this thread specifically.** There
is already a bridge from the list-indexed operator to `iteratedFDeriv`, in
`Analysis/Distribution/SchwartzSpace/Deriv.lean:153`:

```lean
theorem iteratedLineDerivOp_eq_iteratedFDeriv {n : ℕ} {m : Fin n → E} {f : 𝓢(E, F)} {x : E} :
    ∂^{m} f x = iteratedFDeriv ℝ n f x m
```

That is precisely the identification the Clay-versus-Lean comparison needs — for Schwartz maps.
Clay's force condition is Schwartz-like, rapid decay of every derivative, but the domain in the
formalization is `univ ×ˢ Ici 0` rather than all of space-time, so `𝓢(E,F)` does not apply
directly. Whether the right move is a `LineDeriv` instance for bundled `C^k` functions, as you
suggest, or a `within` variant of that bridge, I do not have a view worth defending — you and
@Tomas Skrivan are better placed to judge which is worth having.

Either way, the operator-norm bound I posted is unaffected: it is about ordered tuples throughout
and needs neither the notation nor the symmetry.
