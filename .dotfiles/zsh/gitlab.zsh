alias gyml="glab api /projects/:fullpath/ci/lint | yq .merged_yaml | bat -l yml"
alias ciyml="glab api /projects/:fullpath/ci/lint | yq .merged_yaml | bat -l yml"