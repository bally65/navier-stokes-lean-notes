# 加入既有討論的短版（未發布）

**先做這件事**：把 `general` 頻道那串「Independent verification of OpenAI NavierStokes...」19 則讀完。
判斷標準很簡單——下面四項，如果已經有人做過而且貼了數字，就不要重貼，改成回一句確認就好。

我們手上有、別人未必有的四項：
1. 把 `NavierStokes/ComparatorDefinitions.lean` 的定義區塊，對 `google-deepmind/formal-conjectures`
   釘住的 commit `8bf45ed7` 做逐行比對（結果：152 行對 151 行，唯一差異是上游繼續往下寫定理）
2. 週期情形多要求壓力週期這件事，對到 Clay 官方 PDF 的 Errata 原文
3. 兩個 target 都完整建置：9407 + 10603 jobs，0 error，0 sorry 警告
4. 四條定理的 `#print axioms` 輸出

---

## 如果那串還沒有這些，貼這段（英文）

I built and checked this independently on one machine yesterday; posting the receipts in case they
are useful, and one correction of my own.

Statement provenance: `NavierStokes/ComparatorDefinitions.lean` says it copies
`FormalConjectures/Millenium/NavierStokes.lean` from `google-deepmind/formal-conjectures` at
commit `8bf45ed7`. I fetched that upstream file and diffed the definition block: 152 upstream lines
against 151 local, the only difference being that upstream continues into its theorem statements.
The two shipped theorem statements are character-identical to the upstream ones.

Against the official problem: the force condition is Fefferman's full decay condition, not a
weakened one. The periodic case additionally requires the pressure to be periodic, which is not in
the printed (10)/(11) — it is in the official errata ("the further condition p(x + eⱼ, t) = p(x, t)
should be made explicit in Eqn (8)"), which I read in the Clay PDF.

Trust base: 0 `axiom` declarations, 0 `native_decide` / `implemented_by` / `extern` / `unsafe`, and
the only 5 `sorry` are in `ComparatorChallenges/`, which that file documents as intentional
reference placeholders.

Builds, both targets:

```
lake build NavierStokes → 9407 jobs,  0 errors, 0 sorry warnings
lake build Euler        → 10603 jobs, 0 errors, 0 sorry warnings

navier_stokes_breakdown_R3                [propext, Classical.choice, Quot.sound]
navier_stokes_breakdown_periodic          [propext, Classical.choice, Quot.sound]
euler_breakdown_R3                        [propext, Classical.choice, Quot.sound]
exists_compact_smooth_euler_singularity   [propext, Classical.choice, Quot.sound]
```

My own correction, worth stating because I nearly published it as a finding: my first Euler build
failed with five missing-`.olean` errors. That was my fault, not theirs — I had three builds
writing into one build directory. A single-process rerun passed.

What this does not establish: whether 616k lines correspond to a proof a referee would find
intelligible. It checks that the statements are the intended ones and that the kernel accepts the
proofs.

Full write-up with the commands: https://github.com/bally65/navier-stokes-lean-notes

---

## 如果那串已經有人做過同樣的事

就回一句話，例如：

> I ran the same checks independently yesterday and got the same numbers (9407 + 10603 jobs, three
> standard axioms, statements byte-identical to the pinned formal-conjectures upstream). Confirming
> rather than adding.

確認也有價值，而且不佔別人版面。

---

## 另外那條鏈規則的問題

那是不同的事，貼在 `Is there code for X?`，草稿在 `ZULIP_POST_DRAFT.md`。兩件不要混在同一串。
