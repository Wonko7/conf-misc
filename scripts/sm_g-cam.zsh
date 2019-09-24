#! /bin/zsh

PAGER=

random_words ()
{
  words=$(fortune -a)
  words="$words $(fortune -a)"
  words="$words $(fortune -a)"
  words="$words $(fortune -a)"

  words=$(echo $words | sed -re "s/(--|[^-_!?[:alnum:]])+/ /g" -e "s/ /\n/g" | sed -re "{ /the/I d }" -ne "{ /^.{3,}/ p }")
  words=$(echo $words | shuf -n 3 | tr '\n' '-' | sed -e 's/-$//')
  echo $words
}

update_private ()
{
  echo
  echo updating private:
  echo

  for sm in */; do
    sm=$(basename $sm)
    echo $sm
    pushd $sm

    git pull || exit 42
    git add .

    changes=$(git status --short)
    if [ -z "$changes" ]; then
      popd > /dev/null
      continue
    fi

    commit="$sm: $HOST: $tag"
    echo
    echo "commit? $commit"
    git status --short
    read answer
    if [ "$answer" != y ]; then
      popd > /dev/null
      continue
    fi

    git commit -am "$sm: $HOST: $tag"

    popd > /dev/null
  done

  git commit -am "$HOST: $tag"
  git commit -a -m "$commit"
  git tag "$tag" -m "$tag"
  git push
}

commit_submodules ()
{
  local smodules=$(git status -s | sed -nre 's/ M // p' | tr '\n' ' ' | sed -e 's/ $//')
  local answer
  local words
  local commit
  local tag

  while [ "$answer" != y ]; do
    tag="$(random_words)"
    git s summary
    if [[ "$@" != "" ]]; then
      commit="$tag: $@"
    fi
    echo "$tag"
    read answer
  done
  git commit -a -m "$tag"
  git tag "$tag" -m "$tag"

  if [ -d private/.git ]; then
    pushd private
    update_private "$tag"
    popd > /dev/null
  fi
}

commit_submodules $@
git push
