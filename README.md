# Matrix Market files for Russell benchmarks

<p align="left">
  <a href="https://github.com/cpmech/russell"><img alt="Russell" src="https://img.shields.io/badge/Russell-cpmech%2Frussell-1f425f?logo=rust"></a>
  <a href="https://github.com/cpmech/benchmark-russell"><img alt="Benchmarks" src="https://img.shields.io/badge/benchmarks-cpmech%2Fbenchmark--russell-1f425f"></a>
  <a href="https://doi.org/10.1002/nme.7545"><img alt="DOI" src="https://img.shields.io/badge/DOI-10.1002%2Fnme.7545-blue"></a>
</p>

This repository contains the **44 Matrix Market matrices** used by the
[Russell](https://github.com/cpmech/russell) sparse-solver benchmarks: 34 real and
10 complex matrices, totaling **13.565 GB** uncompressed.

The files are compressed with `tar` + `xz -9e` and split into seven independent
archives. The split keeps every download below **2.29 GB** (the size of the largest
matrix, `pres-cylin-3d-tet10-fine`) and is intended for uploading and transferring
the data in chunks.

## Downloads

Archives are attached to the latest GitHub release:

| Archive | Compressed | Extracted | Files | Download |
|:---:|---:|---:|---:|:---:|
| `01` | 583.4 MB | 2.288 GB | 1 | [01.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/01.tar.xz) |
| `02` | 153.9 MB | 1.617 GB | 1 | [02.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/02.tar.xz) |
| `03` | 435.1 MB | 1.927 GB | 11 | [03.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/03.tar.xz) |
| `04` | 317.6 MB | 1.928 GB | 8 | [04.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/04.tar.xz) |
| `05` | 484.8 MB | 1.939 GB | 8 | [05.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/05.tar.xz) |
| `06` | 433.6 MB | 1.933 GB | 7 | [06.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/06.tar.xz) |
| `07` | 162.5 MB | 1.933 GB | 8 | [07.tar.xz](https://github.com/cpmech/matrix-market/releases/latest/download/07.tar.xz) |
| **Total** | **2.571 GB** | **13.565 GB** | **44** | |

The two files larger than 1 GiB are isolated in their own archives:

- `01` — `pres-cylin-3d-tet10-fine`
- `02` — `Flan_1565`

The remaining files are balanced across archives `03`–`07`.

## What is inside each archive

| Archive | Matrices |
|:---:|:---|
| `01` | `pres-cylin-3d-tet10-fine` |
| `02` | `Flan_1565` |
| `03` | `dielFilterV2real`, `Emilia_923`, `Chevron4`, `Goodwin_127`, `stomach`,<br>`oilpan`, `pres-cylin-3d-tet10-coarse`, `rdb5000`, `mhd1280b`,<br>`bwm2000`, `pmsim-hex8-27` |
| `04` | `Transport`, `memchip`, `torso1`, `tmt_unsym`, `ASIC_680k`, `xenon1`,<br>`fp`, `mplate` |
| `05` | `fem_hifreq_circuit`, `inline_1`, `mono_500Hz`, `marine1`, `rma10`,<br>`helm2d03`, `twotone`, `boyd2` |
| `06` | `dielFilterV3clx`, `PFlow_742`, `kim2`, `pre2`, `Goodwin_071`,<br>`vfem`, `RFdevice` |
| `07` | `Freescale1`, `rajat31`, `atmosmodd`, `atmosmodl`, `fem_filter`,<br>`Raj1`, `darcy003`, `Goodwin_040` |

## Matrix metadata

[`matrices.json`](matrices.json) describes all 44 matrices in one JSON array. Each
entry contains:

| Field | Meaning |
|:---|:---|
| `Name` | Matrix name, matching the `.mtx` file and Russell scripts |
| `Group` | SuiteSparse collection group |
| `Num Rows`, `Num Cols` | Matrix dimensions |
| `Nonzeros` | SuiteSparse numerical nonzero count for the full matrix |
| `Pattern Entries` | Full-pattern entry count, including explicit zeros |
| `Stored Entries` | Entry count in the `.mtx` header |
| `Kind` | Problem category |
| `Symmetric` | `Yes` or `No` (real or complex symmetric) |
| `Hermitian` | `Yes` or `No` (complex Hermitian) |
| `Positive Definite` | `yes` or `no` |
| `Type` | `real` or `complex` |
| `Description` | Short description |

`Stored Entries` is the count written in the Matrix Market header. For symmetric
or Hermitian matrices, the file stores only one triangle, so this is smaller than
`Pattern Entries`. For example, `pmsim-hex8-27` stores 3,369 entries but has
6,581 pattern entries; `mhd1280b` stores 12,029 entries but has 22,778 pattern
entries.

For the real symmetric benchmark matrices, SPD means both:

```text
Symmetric == "Yes" && Positive Definite == "yes"
```

For complex Hermitian matrices, use `Hermitian == "Yes"` together with
`Positive Definite == "yes"`. `mhd1280b` is the only Hermitian matrix in the set.

## Quick start

Download and extract everything into one flat directory with
[`download.sh`](download.sh):

```bash
bash download.sh ~/Downloads/matrix-market
```

If no destination is given, the script uses the current directory.

Each archive contains a top-level directory named after it, so extracting one is
simply:

```bash
tar xf 03.tar.xz
# creates 03/
```

> **Note:** the split is only for transfer. `run_solve_matrix_market.bash` expects
> all `.mtx` files in a single `INPUT_DIR`; merge the extracted directories before
> running it.

## Using with Russell

After flattening the files:

```bash
export INPUT_DIR="$PWD/matrix-market"
cd /path/to/russell/russell_sparse/src/bin

# Run every available solver and solve the systems:
./run_solve_matrix_market.bash -G -s

# Or limit the study to the first 10 real matrices:
./run_solve_matrix_market.bash -G -s -f 10
```

Useful options:

| Option | Meaning |
|:---|:---|
| `-G` | run every available genie |
| `-g <name>` | run one solver (`faer`, `mumps`, `umfpack`, `qdldl`, `basiclu`, `cg`, `bicgstab`, `gmres`) |
| `-f <n>` | first `n` real matrices |
| `-F <n>` | first `n` complex matrices |
| `-1` … `-5` | number of runs per matrix |
| `-s` | solve the systems (otherwise only print matrix information) |

## Provenance

Most matrices come from the
[SuiteSparse Matrix Collection](https://sparse.tamu.edu/). A few matrices used by
the Russell scripts are project-specific and are not fetched by the SuiteSparse
download script.

These files are used to reproduce results in:

> Pedroso DM (2024) **Caveats of three direct linear solvers for finite element
> analyses**, *International Journal for Numerical Methods in Engineering*.
> [doi:10.1002/nme.7545](https://doi.org/10.1002/nme.7545)

```bibtex
@article{Pedroso2024,
  author  = {Pedroso, Dorival M.},
  title   = {Caveats of three direct linear solvers for finite element analyses},
  journal = {International Journal for Numerical Methods in Engineering},
  year    = {2024},
  doi     = {10.1002/nme.7545}
}
```

## Checksums

Verify the downloaded archives with [`SHA256SUMS`](SHA256SUMS):

```bash
sha256sum -c SHA256SUMS
```

<details>
<summary><b>SHA-256 checksums</b></summary>

```text
2fe0acfb5a3430a47d949e2655cfa94b5be56fb36ba89a7444314bd231933a55  01.tar.xz
eaf29682baa5f8cde27491703fdf3a5929143d5930910bdd60355256816c87fa  02.tar.xz
5c4fa787f8787dc2cb8e3df3f476a23a79c49ab5b6b86637dfcd49a035f59206  03.tar.xz
df9ee45108a48ba84e93a8f6f0790fb4db598722642740e9639229d06f70288e  04.tar.xz
3e0e68b99aa94db80e42ebe169abd9f3e4ace62ae6a654508562ebeedd89be3f  05.tar.xz
98f7d69b9c95b563fb6fd3298f110ac3d43d33094780c393654bffaacc0d86bf  06.tar.xz
645a4e802f90f71e274a2fc96e2bfbf5bd1ebb483dff35817652f07ee3d3f2e3  07.tar.xz
```

</details>

## Maintenance note

GitHub rejects files larger than **100 MiB** in a normal Git push. All seven
archives exceed that limit, so they are intended to be attached to a GitHub
Release rather than committed directly. The download links above use the
`releases/latest/download/` form.

If you prefer to keep them in the repository, use **Git LFS** and change the
download links to relative paths such as `01.tar.xz`.
