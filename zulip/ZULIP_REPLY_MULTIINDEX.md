# 後續回覆：把那個 bullet 寫完整（未發布）

**貼在同一串**：`general` → `Independent verification of OpenAI NavierStokesAndEuler`

---

Writing out the direction that is not just norm equivalence, since it is short and the constant is
explicit.

Write `E := EuclideanSpace ℝ (Fin 3) × ℝ` for space-time, `d = 4`, and let `(e₁, …, e_d)` be the
standard basis, three spatial and one temporal. Fix a point `z = (x, t)` and an order `n`.

**Clay's condition implies the Lean one.** `D^n f(z)` is a continuous `n`-linear map `E^n → ℝ³`, so
for unit vectors `v₁, …, vₙ`, expanding each `vᵢ = Σⱼ vᵢʲ eⱼ` and using multilinearity,

```
D^n f(z)(v₁, …, vₙ)  =  Σ_{j₁,…,jₙ}  v₁^{j₁} ⋯ vₙ^{jₙ} · D^n f(z)(e_{j₁}, …, e_{jₙ}).
```

Each coefficient satisfies `|vᵢʲ| ≤ ‖vᵢ‖ = 1` — for the Euclidean factor because a coordinate is
bounded by the norm, and for the product because mathlib gives `Prod` the sup norm. Each term
`D^n f(z)(e_{j₁}, …, e_{jₙ})` is the iterated directional derivative along those basis vectors,
which for a `C^∞` function equals the mixed partial `∂_x^α ∂_t^m f(z)` where `α` records how many
of the `jᵢ` are each spatial direction and `m` how many are temporal, so `|α| + m = n`. Taking
absolute values over the `dⁿ` tuples,

```
‖D^n f(z)‖  ≤  4ⁿ · max_{|α| + m = n} |∂_x^α ∂_t^m f(z)|.
```

Now fix `n` and `K`. There are exactly `C(n+3, 3)` multi-indices with `|α| + m = n`, a finite set,
so putting `C_{n,K} := 4ⁿ · max` over that finite set of Clay's constants `C_{α,m,K}` gives

```
‖D^n f(z)‖  ≤  C_{n,K} · (1 + ‖x‖ + t)^{-K},
```

which is the Lean condition. The converse is the trivial direction: each mixed partial is
`D^n f(z)` evaluated at unit basis vectors, so it is bounded by the operator norm with constant `1`.

**So the equivalence holds, and the two things I would actually check in Lean rather than argue
are these.**

*Symmetry.* The bound above does not need it, but the identification of an ordered iterated
directional derivative with a multi-index partial does. That is Clairaut/Schwarz, fine for `C^∞`,
but it is a real step: without it the tuples `(j₁, …, jₙ)` are ordered compositions rather than
multi-indices, and Clay indexes by multi-indices.

*The boundary.* Everything above is about `iteratedFDeriv`. The formalization uses
`iteratedFDerivWithin` on `univ ×ˢ Ici 0`. At interior times the two agree; at `t = 0` the within
version is the one-sided derivative, which is what Clay's `[0, ∞)` means, so this matches — but for
`iteratedFDerivWithin` to be the canonical object at all one needs `UniqueDiffOn ℝ (univ ×ˢ Ici 0)`.
That holds because the set is convex with nonempty interior. It is exactly the kind of side
condition where a formalization can silently differ from the intended statement, so it seems worth
having stated rather than assumed.

A statement one could put in Lean, if anyone wants to make this precise rather than take it as
folklore:

```lean
theorem opNorm_iteratedFDeriv_le_mixed_partials
    {f : EuclideanSpace ℝ (Fin 3) × ℝ → EuclideanSpace ℝ (Fin 3)}
    (hf : ContDiff ℝ ⊤ f) (n : ℕ) (z : EuclideanSpace ℝ (Fin 3) × ℝ) :
    ‖iteratedFDeriv ℝ n f z‖
      ≤ 4 ^ n * ⨆ (v : Fin n → Fin 4), ‖iteratedFDeriv ℝ n f z (fun i => stdBasis (v i))‖
```

with the right-hand side then re-indexed by multi-indices using symmetry. I have not checked which
of the pieces already exist under those names; `ContinuousMultilinearMap.le_opNorm` and the
`iteratedFDeriv_succ_apply_left` family look like the relevant handles.

I am happy to try formalizing this if it is wanted and nobody else has started — it is a bounded
piece and independent of the rest of the verification effort.
