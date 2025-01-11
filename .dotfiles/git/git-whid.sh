


user=$(git config get user.name)

days=$1
if  [[ $1 == '' ]]; then
 days=7
fi
git log --color --author="$user" --graph --since=-"$days days" --pretty=format:'%C(blue)%cs%Creset %C(magenta)|%Creset %s'