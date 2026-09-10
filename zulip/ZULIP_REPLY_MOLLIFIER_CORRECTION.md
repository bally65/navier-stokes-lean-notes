# 第二次修正（未發布；帳號被限制期間備著）

**貼在同一串**

---

A second correction to something I said above, and it is the same mistake twice, which is worth
saying out loud since this thread is partly about how statements get checked.

I claimed mathlib has no mollification, on the basis that grepping for `mollif` returns zero files.
That is searching for a name rather than for a thing. mathlib has the machinery:

- bump functions in `Analysis/Calculus/BumpFunction/`,
- convolution and its smoothness, `HasCompactSupport.contDiff_convolution_right` in
  `Analysis/Calculus/ContDiff/Convolution.lean`,
- convergence of mollifications, `convolution_tendsto_right_of_continuous` and
  `ae_convolution_tendsto_right_of_locallyIntegrable` in
  `Analysis/Calculus/BumpFunction/Convolution.lean`,
- continuous functions dense in `L^p`, `MeasureTheory/Function/ContinuousMapDense.lean`.

So the earlier framing — that a chain rule against a distributional-gradient hypothesis "would want
a mollification API mathlib does not have" — was too pessimistic. What I could not find, searching
this time by shape rather than by name, is narrower: `L^p` convergence of mollifications, and any
lemma relating convolution to a **weak** derivative. Those two are what such an argument would
actually consume, and they look like the real gap rather than mollification as such.

I mention it because it changes the size of the problem, and because @Luigi Massacci already caught
me doing the same thing with `LineDeriv.iteratedLineDerivOp`. Two wrong absence claims in one
thread, both from grepping for the name I had in mind. If either of these is also wrong, I would
rather hear it than leave it standing.
