# References

## Mathematics formalized or followed

- L. Caffarelli, R. Kohn, L. Nirenberg, *Partial regularity of suitable weak solutions of the
  Navier–Stokes equations*, Comm. Pure Appl. Math. 35 (1982), 771–831. The theory this project is
  aimed at, and which it does not reach.
- F.-H. Lin, *A new proof of the Caffarelli–Kohn–Nirenberg theorem*, Comm. Pure Appl. Math. 51
  (1998), 241–257. The quantitative half of the development follows its section 3.
- A. Vasseur, *A new proof of partial regularity of solutions to Navier–Stokes equations*, NoDEA 14
  (2007), 753–785. The De Giorgi route followed here.
- C. L. Fefferman, *Existence and smoothness of the Navier–Stokes equation*, official problem
  description, Clay Mathematics Institute. Used in the audit, including its errata.

## Software depended on or examined

- mathlib, the Lean 4 mathematical library. Apache-2.0.
- The `DeGiorgi` package (elliptic De Giorgi–Nash–Moser theory in Lean 4), a dependency of this
  project. Apache-2.0.
- `google-deepmind/formal-conjectures`, source of the Navier–Stokes problem statements used by the
  audited repository. Apache-2.0.
- `openai/NavierStokesAndEuler`, the subject of the audit. Apache-2.0.

Precise commits and revisions are pinned in the formalization's `lake-manifest.json` and, for the
audited repository, quoted in the audit itself.
