# Independent audit of `openai/NavierStokesAndEuler`

*Performed 2026-09-09/10 on one machine. Everything below was measured here; the commands are given
so it can be re-run. This is a verification report, not a mathematical review.*

## What was audited

A shallow clone of the repository: 2486 `.lean` files, 616276 lines, Lean `v4.34.0-rc2`, mathlib and
batteries as dependencies, Apache-2.0, a single commit. Top-level directories `NavierStokes/`,
`Euler/`, `ComparatorChallenges/`.

## 1. Where the statements come from

`NavierStokes/ComparatorDefinitions.lean` states in its header that it is a copy of
`FormalConjectures/Millenium/NavierStokes.lean` from `google-deepmind/formal-conjectures`, pinned at
commit `8bf45ed70d48b2b2a501de9c00b26bfa38c573ee`. We fetched that upstream file and compared the
definition block directly:

```
upstream lines 115–266 (152 lines)  vs  local copy lines 95–246 (151 lines)
only difference: upstream continues into its theorem statements, the copy ends with `end`
```

The two shipped theorem statements, `navier_stokes_breakdown_R3` and
`navier_stokes_breakdown_periodic`, are character-identical to the upstream ones (upstream carries a
`@[category research open]` attribute and a `sorry` proof). **The statements were not authored by
the claimant.** That materially reduces the risk that they were shaped to be provable.

## 2. Do the statements match the official problem

Read from the Clay problem description (Fefferman) directly, extracted with `pdftotext`.

| Lean definition | Official condition |
|---|---|
| `InitialVelocityConditionDecay`: divergence-free, `ContDiff ℝ ∞`, and for every derivative order and every rate, a constant with `‖iteratedFDeriv m u₀ x‖ ≤ C/(1+‖x‖)^K` | (4) |
| `ForceConditionDecay`: `ContDiffOn ℝ ∞` on `univ ×ˢ Ici 0`, and `≤ C/(1+‖x‖+t)^K` for every order and rate | (5), the full decay, not weakened |
| the equation, divergence-free for all `t ≥ 0`, the initial condition, and both velocity and pressure `ContDiffOn ℝ ∞` | (1), (2), (3), (6) |
| `MemLp 2` at each time, and `∃ E, ∀ t ≥ 0, ∫ ‖v‖² < E` | (7) |

The theorems are negations, so a *stricter* solution predicate makes the claim *weaker*. The only
place the predicate is stricter than the printed problem is the periodic case, which also requires
the pressure to be periodic. That is not an addition by the claimant: the official errata says the
condition `p(x + eⱼ, t) = p(x, t)` should be made explicit. We read that errata in the Clay PDF.

## 3. The trust base

| checked | result |
|---|---|
| `axiom` declarations | 0 |
| `native_decide`, `implemented_by`, `extern`, `unsafe` | 0 |
| options that weaken kernel checking | 0 |
| `sorry` / `admit` | 5, all in `ComparatorChallenges/`, which the file itself documents as intentional reference placeholders; the proof files contain none |

## 4. Building it, and the axioms

```
lake build NavierStokes → Build completed successfully (9407 jobs), 0 errors, 0 sorry warnings
lake build Euler        → Build completed successfully (10603 jobs), 0 errors, 0 sorry warnings

'NavierStokes.Comparator.navier_stokes_breakdown_R3'       [propext, Classical.choice, Quot.sound]
'NavierStokes.Comparator.navier_stokes_breakdown_periodic' [propext, Classical.choice, Quot.sound]
'Euler.euler_breakdown_R3'                                 [propext, Classical.choice, Quot.sound]
'Euler.exists_compact_smooth_euler_singularity'            [propext, Classical.choice, Quot.sound]
```

**A correction we are recording rather than removing.** Our first Euler build failed with five
missing-object errors. That was our own fault: to keep a long build alive we had launched it three
times, and two of those runs were writing into the same build directory. A single-process rerun
passed. We nearly published a build failure as a finding about someone else's work.

## 5. The Euler statement is the stronger one

Besides "no global smooth solution", the repository carries a quantitative theorem: nonzero,
compactly supported, rapidly decaying initial data; a maximal lifespan `T* ∈ (0,1]`; closed-interval
solutions in the stated Sobolev class existing **if and only if** `T < T*`; the `C¹` norm's `limsup`
at `T*` equal to `⊤`; and the Beale–Kato–Majda vorticity integral divergent. Two-way maximality
together with blow-up quantities for a concrete solution is not a shape that is easy to satisfy
vacuously. Note that Euler is not on the Clay list; the official problem description says so.

## 6. What this audit does and does not establish

It establishes that the statements are the intended ones, taken verbatim from an independent
third-party formalization and matching the official problem including its errata, and that the
proofs pass the Lean kernel depending only on the three standard axioms.

It does not establish that 616276 lines correspond to a proof a human referee would find
intelligible. Formalization removes doubt about the proof and concentrates it on the statement; the
statement layer is the part we checked.

One framing point, since it is frequently lost: alternatives (C) and (D) are the **forced** breakdown
statements. The official text does ask for a proof of one of the four, so they qualify, but they do
not answer whether unforced Navier–Stokes stays smooth, which is (A) and (B).

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
