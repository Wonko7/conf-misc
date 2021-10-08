#! env zsh

PAGER=

source $misc/scripts/random_words.zsh

update_private ()
{
  local tag=$1
  echo updating private:
  echo
  local sm changes commit answer

  for sm in bookmarks tmux-sessions pass history; do # FIXME auto commit modules.
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
    if is_answer_affirmative "$answer"; then
      git commit -am "$sm: $HOST: $tag"
    fi

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

  local tag=$(choose_tags 10 $1)
  commit_root $tag $root

  if [ -d private/.git ]; then
    pushd private
    git submodule summary
    echo "Descend into private?"
    read answer
    if is_answer_affirmative "$answer"; then
      commit_root $tag private
      push_root
    fi
    popd > /dev/null
  fi
  push_root
}

init $1
