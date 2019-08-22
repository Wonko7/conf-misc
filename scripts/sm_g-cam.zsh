#! /bin/zsh

PAGER=

random_words ()
{
  words=$(fortune -a)
  words="$words $(fortune -a)"
  words="$words $(fortune -a)"
  words="$words $(fortune -a)"

  words=$(echo $words | sed -re "s/(--|[]\[\"\`().,;:\\/[:space:]])+/ /g" -e "s/ /\n/g" | sed -re "{ /the/I d }" -ne "{ /^.{3,}/ p }")
  ws=$(echo $words | shuf -n 3 | tr '\n' ' ') ## FIXME ^^
  for w in $ws; do
    l+=${(C)w}
  done

  echo $l
}

commit_submodules ()
{
  local smodules=$(git status -s | sed -nre 's/ M // p' | tr '\n' ' ' | sed -e 's/ $//')
  local answer
  local words
  local commit
  local tag

  while [ "$answer" != y ]; do
    words="$(random_words)"
    commit="$(echo $words | sed -re 's/ $//'): $smodules"
    tag="$(echo "$words" | sed -re 's/[^[:digit:][:alpha:]]//g')"
    git s summary
    if [[ "$@" != "" ]]; then
      commit="$commit: $@"
    fi
    echo "$commit"
    echo "$tag"
    read answer
  done
  git commit -a -m "$commit"
  git tag "$tag" -m "$commit"
}

commit_submodules $@
