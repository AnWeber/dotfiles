if [[ $(git current) =~ ([A-Z][A-Z0-9]+-[0-9]+) ]]; then
  issue=${BASH_REMATCH[1]}
fi
echo $issue