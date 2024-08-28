# offline_installer.R

download_r_packages <- function(cran_pkgs=NULL,
                                github_repos=NULL,
                                bioc_pkgs=NULL,
                                dest_dir) {
  if (!dir.exists(dest_dir)) {
    dir.create(dest_dir, recursive = TRUE)
  }

  if (!is.null(cran_pkgs)) {
    utils::install.packages(cran_pkgs, lib=dest_dir, dependencies=TRUE, type="source", repos="https://cran.rstudio.com/")
    utils::download.packages(cran_pkgs, destdir=dest_dir, type="source", repos="https://cran.rstudio.com/")
  }

  if (!is.null(github_repos)) {
    for (repo in github_repos) {
      devtools::install_github(repo, lib=dest_dir, dependencies=TRUE, upgrade="never", INSTALL_opts="--no-multiarch", type="source")
    }
    for (repo in github_repos) {
      pkgs <- remotes::package_deps(repo, repos="https://cran.rstudio.com/", dependencies=TRUE)
      utils::download.packages(pkgs$package, destdir=dest_dir, type="source", repos="https://cran.rstudio.com/")
    }
  }

  if (!is.null(bioc_pkgs)) {
    BiocManager::install(bioc_pkgs, lib=dest_dir, dependencies=TRUE, ask=FALSE, update=FALSE)
    installed_pkgs <- utils::installed.packages(lib.loc=dest_dir)
    for(pkg in rownames(installed_pkgs)) {
      utils::download.packages(pkg, destdir=dest_dir, type="source", repos="https://cran.rstudio.com/")
    }
  }
}


generate_install_script <- function(dest_dir) {
  script <- '
    install.packages(list.files(path = "PKG_DIR", pattern = "*.tar.gz", full.names = TRUE), repos = NULL, type = "source")
    devtools::install_local(list.files(path = "PKG_DIR", pattern = "*.zip$", full.names = TRUE))
    cat("All pkgs are installed successfully! \\n")
  '

  script <- gsub("PKG_DIR", dest_dir, script)
  script_path <- file.path(dest_dir, "install_r_packages.R")
  writeLines(script, script_path)
  cat("Generate script for installing pkgs: ", script_path, "\n")
}

#' @title download r pkgs
#' @param cran_pkgs vectors of pkgs installed from R-Cran
#' @param github_repos vectors of github_repos from GitHub
#' @param bioc_pkgs vectors of pkgs installed from BioConductor
#' @param dest_dir fold for saving all pkgs
#' @param bundle_name name of the pkgs
#' @import utils
#' @export
package_offline_bundle <- function(cran_pkgs=NULL,
                                   github_repos=NULL,
                                   bioc_pkgs=NULL, dest_dir, bundle_name) {
  download_r_packages(cran_pkgs, github_repos, bioc_pkgs, dest_dir)
  generate_install_script(dest_dir)
  zip_file <- paste0(bundle_name, ".zip")
  zip(zipfile=zip_file, files=list.files(dest_dir, full.names=TRUE))
  cat("Generate offline pkgs: ", zip_file, "\n")
}
