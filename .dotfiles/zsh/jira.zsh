
alias jito='cmd.exe /c start "${JIRA_URL}/browse/$(git jira)" &> /dev/null'
alias jiv='jira issue view "$(git jira)" | cat'
alias jis='jira issue view "$(git jira)" | cat'