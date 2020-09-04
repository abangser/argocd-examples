if [[ -z $(git diff-index --name-only HEAD --) ]]; then
  echo empty
else
  echo not-empty
fi
