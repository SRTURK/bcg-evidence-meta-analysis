# Install into this repository only; do not modify a user's global library.
dir.create('.Rlibrary',showWarnings=FALSE)
.libPaths(c(normalizePath('.Rlibrary'),.libPaths()))
needed <- c('digest','metafor','metadat')
missing <- needed[!vapply(needed,requireNamespace,logical(1),quietly=TRUE)]
if(length(missing)) install.packages(missing,lib='.Rlibrary',repos='https://cloud.r-project.org')
cat('Installed versions:\n');print(sapply(needed,function(p)as.character(packageVersion(p))))
cat('Reference versions are recorded in reports/package_versions.csv. Run tests after any package upgrade.\n')
