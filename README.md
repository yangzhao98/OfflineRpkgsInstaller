
# OfflineRpkgsInstaller

<!-- badges: start -->
<!-- badges: end -->

The goal of OfflineRpkgsInstaller is to ...

## Installation

You can install the development version of OfflineRpkgsInstaller from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("yangzhao98/OfflineRpkgsInstaller")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(OfflineRpkgsInstaller)
## basic example code
package_offline_bundle(
  cran_pkgs=c("devtools","remotes"),
  github_repos=c("yangzhao98/OfflineRpkgsInstaller"),
  bioc_pkgs=c("BiocManager"),
  dest_dir="D:/r_pkgs",
  bundle_name="r_pkgs_install"
)
```

