# Drafts for the Lean Zulip discussion

These are the working drafts behind the messages posted to the Lean Zulip thread *Independent
verification of OpenAI NavierStokesAndEuler*, kept here rather than deleted.

They are published for two reasons. `AI_DISCLOSURE.md` states that most of the prose in this project
was drafted by AI under human direction; these files make that concrete rather than abstract, since
anyone can see what was drafted and what was checked. And they record the corrections in sequence,
including one where a claim of mine about mathlib was made on the wrong search surface and had to be
withdrawn — which is more useful to a reader than a tidy final version would be.

They contain instructions in Chinese addressed to the repository owner, telling him what to verify
before posting each one. That is what they were for.

| file | what it became |
|---|---|
| `ZULIP_REPLY_FINAL.md` | the first message: statement provenance, the Clay errata, the build receipts, and a retraction of a build failure that was our own concurrency |
| `ZULIP_REPLY_MULTIINDEX.md` | the multi-index argument, written out with the explicit constant |
| `ZULIP_REPLY_MULTIINDEX_Q.md` | the answer to whether mathlib has multi-index derivatives |
| `ZULIP_REPLY_CORRECTION.md` | the correction after Luigi Massacci pointed at `LineDeriv.iteratedLineDerivOp`, which the earlier search had missed |
| `ZULIP_REPLY_PROVED.md` | the message accompanying `MultilinearBasisBound.lean` |
| `ZULIP_POST_DRAFT.md` | a separate question for `#Is there code for X?`, about the chain rule; not posted at the time of writing |
| `ZULIP_REPLY_DRAFT.md` | an earlier, superseded version of the first message |

Nothing here is a claim. The claims are in `CLAIM_SCOPE.md`.
