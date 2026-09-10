# Gating AI-generated Lean at scale: the failure modes we actually measured

*A methods note. Everything below is something that happened in this project and was recorded, not
a list of things that could go wrong in principle.*

## The problem this addresses

When most of a Lean development is written by AI agents, the kernel still guarantees exactly what
it always guaranteed: that each proof follows from its statement. It guarantees nothing about
whether the statement is the one you meant, whether the harness that reported "green" actually
compiled anything, or whether a hypothesis is so strong that nothing satisfies it. At volume, those
three gaps are where all the damage is.

Our response is a per-unit gate and a set of negative controls. What follows is the gate, and then
the ways we have watched it be fooled.

## The gate

Every unit is recompiled **by the reviewer, not by the agent that wrote it**, and seven numbers are
read from that compile:

| number | what it catches |
|---|---|
| `errors` | the obvious case, matched as `error[:(]` because Lean also emits `error(lean.xxx):` |
| `sorryAx` | a proof that reached the kernel with a hole |
| `axioms` | **whether anything compiled at all** |
| `unused` | hypotheses the proof never consumes |
| `sorryWarn` | the elaborator's own warning |
| `srcSorry` | the token in the source, comments included |
| `noFile` | a missing file, which otherwise reads exactly like a clean compile |

The third and last deserve emphasis. `errors=0` on a file that does not exist is indistinguishable
from `errors=0` on a clean file. Counting `#print axioms` lines is what separates them: zero axiom
lines means nothing elaborated, regardless of what the error count says.

## Failure modes we measured

**The harness reports green because it did not run.** An agent removed the `#print axioms` lines
from its control files; the controls then reported zero axioms, which the reviewer initially read
as a red. Both readings were wrong for the same reason: the number no longer measured anything.

**A naive check on the gate itself is a failure mode.** Lean's printer wraps a long axiom list
across several lines. A one-line `grep` for the standard triple then reports a non-standard axiom
that is not there. This happened to us today, on a file that was in fact clean.

**A red can be your own tooling.** Auditing another group's public repository, we saw a build fail
with five missing-object errors. The cause was our own three overlapping builds writing into one
build directory. A single-process rerun passed. Three of this session's four reds were tooling, not
mathematics, and one of them was very nearly published as a finding about someone else's work.

**Controls that break syntactically before they break mathematically.** Mutating the conclusion of
a long calculational proof usually breaks the first `rewrite` that mentions it. The proof does
fail, which is what the control asks for, but the failure demonstrates linkage rather than
falsity. When it matters, check the mutated statement by hand: for one of ours we exhibited
explicit values at which the mutated inequality is false.

**Mutations that leave a true statement.** One of our controls weakened an integrability hypothesis
in a way that was still provable from a different field of the class. The control still failed to
compile, so it looked good, but it proved only that the proof was wired to the hypothesis we
touched. Its partner control, which produced a genuinely false statement, is the one carrying the
evidence.

**Reversible implications.** For a reduction of the form "A implies B", we run a control that
reverses it. If the reversed statement also compiles, the reduction carries no content. Ours failed
with twenty-seven errors, which is the outcome you want.

**Decorative hypotheses.** Six times in this campaign, an agent proved a statement with hypotheses
its proof never used. The unused-variable linter catches these, which is why `unused` is in the
gate and why we do not silence it. Each time the reviewer dropped the binder in the unit and in
every control, rather than accepting a statement weaker than it looks.

**Proxied shell tools.** On this machine `grep` and `diff` are wrapped by a tool that summarises
their output. A `diff` between two genuinely different files reported them identical. All checks
now call `/usr/bin/grep` and `/usr/bin/diff` by absolute path.

## What controls cannot do

A mutation control tests whether a **statement** is load-bearing for its **proof**. It is blind to
a statement that is vacuous, or that is true for a reason unrelated to the intended content. We
have measured a theorem passing three mutation controls while being equivalent to its own
conclusion. Two things address that, and neither is a control:

- **A satisfiability leg**: exhibit a concrete object that satisfies every hypothesis. If you
  cannot write one, the hypothesis may be unsatisfiable, and the theorem is then vacuously true.
- **An adversarial audit of the statement itself**, before any proof is attempted. In this project
  a frozen hypothesis quantified over the whole domain of a periodic map once made a lemma read
  `0 = 0`; only a statement-level audit saw it.

## The discipline that made the rest work

Freeze the statement first, and check it elaborates with `sorry` before any agent is dispatched.
Have the reviewer recompile rather than trusting the builder's own report. Read the verdict only
from the gate's own numbers. And when a hypothesis cannot be proved, name it, carry it explicitly
in the statements that use it, and say in the header that it is assumed. We have discharged such a
hypothesis three units after freezing it, and we currently carry another one that is still open.

No epsilon regularity, no partial regularity, no global smoothness, and no Clay conclusion.
