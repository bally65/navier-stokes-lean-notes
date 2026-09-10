# Zulip 貼文草稿（未發布）

**貼在哪**：https://leanprover.zulipchat.com → 串流 `#Is there code for X?`
**標題（Topic）**：`chain rule for the norm of a vector field with a weak gradient`

貼文內容（從下面這行以下整段複製）：

---

I'm formalizing part of the local regularity theory for 3D Navier–Stokes (Lin 1998 for the
quantitative half, Vasseur 2007 for a De Giorgi route), and I'm stuck on one statement that feels
like it should already exist somewhere.

I have a vector field `u : E → EuclideanSpace ℝ (Fin 3)` whose weak gradient `G` is given only
through integration by parts against smooth compactly supported test functions. I need the chain
rule for a smooth outer function applied to it — concretely, for `ε > 0`,

```lean
∫ z in Q, (∑ i, u z i * G z (i,j)) / √(‖u z‖^2 + ε^2) * φ.value z
  = - ∫ z in Q, (√(‖u z‖^2 + ε^2) - ε) * φ.spatialGradient z j
```

The unregularised case (`ε = 0`, with `∇‖u‖` defined by the usual formula and `0` where `u`
vanishes) I've already reduced to this one by dominated convergence, so the smooth-outer-function
case is the whole remaining question.

What I measured before asking: mathlib has nothing under `HasWeakDeriv`, `WeakDeriv`,
`SobolevSpace`, `MemW`, and no mollification. The closest thing I found is `sobolev_chain_rule` in
the DeGiorgi package, but that is univariate (`Φ : ℝ → ℝ`) on a scalar function over a ball, so it
doesn't reach a vector field with a multivariate outer function.

Questions:
1. Is there an existing route I've missed? Wrong absence claims are the most common error in my own
   log, so I'd genuinely rather be corrected.
2. If it isn't there, what should the general statement look like — a chain rule for `C¹` outer
   functions against a distributional-gradient hypothesis? That seems to want a mollification API
   mathlib doesn't have. Would that be welcome upstream?

Separately, and while I'm here: I built a Calderón–Zygmund decomposition, weak (1,1) bound and
Riesz operator on ℝ³ for this. mathlib has none of that, but I'm aware `fpvandoorn/carleson` does
CZ theory in the doubling metric measure setting with no `sorry` in its `WeakCalderonZygmund` file.
I haven't measured how much of mine that subsumes once specialised to ℝ³ — if someone already
knows, that would save me the experiment.

Notes and the exact statement are here (documents only, no formalization):
https://github.com/bally65/navier-stokes-lean-notes — https://doi.org/10.5281/zenodo.22684542

To be clear about scope: this proves no ε-regularity, no partial regularity, and has no bearing on
the Clay problem. The claim scope page says so at more length.

---

**貼之前的三個檢查**
- [ ] 串流選的是 `#Is there code for X?`，不是 `#general`
- [ ] Topic 用英文，簡短
- [ ] Zulip 是實名社群，用你平常的名字

**貼完之後**
有人回覆時你會收到 email。不想回也沒關係，但如果有人指出 mathlib 裡已經有現成的東西，那句「我漏看了，謝謝」值得回一句，那是這個社群的規矩。
