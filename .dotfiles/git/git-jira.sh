if [[ $(git rev-parse --abbrev-ref HEAD) =~ ([A-Z][A-Z0-9]+-[0-9]+)\/([A-Z][A-Z0-9]+-[0-9]+) ]]; then
  issue=${BASH_REMATCH[-1]}
  echo $issue
  exit
fi

if [[ $(git rev-parse --abbrev-ref HEAD) =~ ([A-Z][A-Z0-9]+-[0-9]+) ]]; then
  issue=${BASH_REMATCH[-1]}
fi
echo $issue