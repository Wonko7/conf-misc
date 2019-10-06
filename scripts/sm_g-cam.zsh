#! /bin/zsh

PAGER=

random_words ()
{
  local smut=~/conf/private/smut/t-rex.words
  local words
  if [ -r "$smut" ]; then
    words=$(shuf -n 3 $smut | tr '\n' '-' | sed -e 's/-$//')
  else
    echo warning! could not find smut! falling back on fortune.
    words=$(fortune -a)
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    words=$(echo $words | sed -re "s/(--|[^-_![:alnum:]])+/ /g" -e "s/ /\n/g" | sed -re "{ /the/I d }" -ne "{ /^.{3,}/ p }")
  fi
  echo $words
}

update_private ()
{
  echo
  echo updating private:
  echo
  local sm changes commit answer

  for sm in bookmarks tmux-sessions pass history; do # FIXME
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


    # FIXME sigh $tag... should be $1.
    commit="$sm: $HOST: $tag"
    echo
    echo "commit? $commit"
    git status --short
    read answer
    if [ y != "$answer" ]; then
      popd > /dev/null
      continue
    fi

    git commit -am "$sm: $HOST: $tag"

    popd > /dev/null
  done

  git commit -am "$HOST: $tag"
  git tag "$tag" -m "$tag"
  git push
  git push --tag
}

commit_submodules ()
{
  local smodules=$(git status -s | sed -nre 's/ M // p' | tr '\n' ' ' | sed -e 's/ $//')
  local answer
  local words
  local commit
  local tag

  git s summary
  while [ y != "$answer" ]; do
    tag="$(random_words)"
    if [ ! -z "$@" ]; then
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

  git push
  git push --tag
}

commit_submodules $@
