
alias jito='cmd.exe /c start "${JIRA_URL}/browse/${1:-$(git jira)}" &> /dev/null'
alias jiv='jira issue view "${1:-$(git jira)}" | bat'
alias jis='jira issue view "${1:-$(git jira)}" | bat'