#! /bin/zsh

PAGER=

random_words ()
{
  local smut=~/conf/private/smut/t-rex.words
  local words
  if [ -r "$smut" ]; then
    words=$(shuf -n 3 $smut | tr '\n' '-' | sed -e 's/-$//')
  else
    1>&2 echo warning! could not find smut! falling back on fortune.
    words=$(fortune -a)
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    words=$(echo $words | sed -re "s/(--|[^-_![:alnum:]])+/ /g" -e "s/ /\n/g" | sed -re "{ /the/I d }" -ne "{ /^.{3,}/ p }")
  fi
  echo $words
}

choose_tag () {
  local answer
  local tag=$1

  # keep $tag given as script arg?
  if [ ! -z "$tag" ]; then
    1>&2 echo "$tag"
    read answer
    if [ y = "$answer" ]; then
      echo $tag
      return
    fi
  fi

  # generate new one then:
  while [ y != "$answer" ]; do
    tag=$(random_words)
    1>&2 echo "$tag"
    read answer
  done
  echo $tag
}

update_private ()
{
  local tag=$1
  echo updating private:
  echo
  local sm changes commit answer

  for sm in notes bookmarks tmux-sessions pass history; do # FIXME auto commit modules.
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
    git status --short
    echo "commit? $commit"
    read answer
    if [ y != "$answer" ]; then
      popd > /dev/null
      continue
    fi

    git commit -am "$sm: $HOST: $tag"

    popd > /dev/null
  done
}

commit_root ()
{
  local tag=$1
  local root=$2

  echo
  echo "commit root:" $root
  if [ "$root" = "private" ]; then
    update_private $tag
  fi

  git commit -a -m "$HOST: $tag"
  git tag "$tag" -m "$HOST: $tag"
}

push_root ()
{
  git push
  git push # for some reason the "remote end hung up unexpectedly" happens every fucking time.
  git push --tag
}

init () {
  local root=$(basename "$PWD")
  local tag answer

  git submodule summary
  echo "===========" $root

  local tag=$(choose_tag $1)
  commit_root $tag $root

  if [ -d private/.git ]; then
    pushd private
    git submodule summary
    echo "Descend into private?"
    read answer
    if [ y = "$answer" ]; then
      commit_root $tag private
      push_root
    fi
    popd > /dev/null
  fi
  push_root
}

init $1
