# Licences and attribution

## These documents

MIT, see `LICENSE`. They are prose and contain no code from any dependency.

## What applies if the formalization itself is released later

The formalization is not part of this repository. When any of it is released, the following
applies and is recorded here so the decision is not made twice:

| component | licence | consequence |
|---|---|---|
| this project's own Lean sources | MIT | — |
| `mathlib` | Apache-2.0 | attribution and notice must be preserved in derived files |
| the `DeGiorgi` dependency package | Apache-2.0 | same |

MIT and Apache-2.0 are compatible for this purpose. Apache-2.0 carries an attribution and notice
requirement that MIT does not, so any file derived from either dependency must keep its notice, and
a combined distribution must carry both licence texts. This has no effect on the present documents;
it matters for a later release of the mathematics.

## Sources whose results are formalized

The formalization follows published mathematics. Results are restated in the project's own words
with page and equation numbers; no text from the sources is reproduced, and the source PDFs are not
distributed. See `REFERENCES.md`.

## Third-party material examined

The audit examines `openai/NavierStokesAndEuler` (Apache-2.0) and, through it,
`google-deepmind/formal-conjectures`, from which that repository takes its problem statements. The
audit quotes short identifiers, statements and build output for the purpose of verification, and
attributes them.
