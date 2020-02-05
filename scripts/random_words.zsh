#! /bin/zsh

is_answer_affirmative ()
{
  local answer=$1

  if [ "$answer" = yes -o "$answer" = y -o -z "$answer" ]; then
    return 0
  fi
  return 1
}

is_answer_negative ()
{ # needed because if not is_answer_affirmative $answer; can't work because not does not know about our function.
  if is_answer_affirmative "$1"; then
    return 1
  fi
  return 0
}

random_words ()
{
  local smut
  local words
  local nb_tags
  local nb_words
  local nl="
"

  if [ -z "$1" ]; then
    nb_tags=1
  else
    nb_tags=$1
  fi
  nb_words=$(( nb_tags * 3 ))

  if [ -r "$SMUT" ]; then
    smut=$SMUT
  else
    smut=~/conf/private/smut/t-rex.words
  fi

  if [ -r "$smut" ]; then
    shuf -n $nb_words $smut | tr '\n' '-' | sed -re "s/(([^-]+-){2,2}([^-]+))-/\1#/g" | tr '#' '\n'
  else
    1>&2 echo warning! could not find smut! falling back on fortune.
    words=$(fortune -a)
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    words="$words $(fortune -a)"
    echo $words | sed -re "s/(--|[^-_![:alnum:]])+/ /g" -e "s/ /\n/g" | sed -re "{ /the/I d }" -ne "{ /^.{3,}/ p }"
  fi
}

choose_tag () {
  local answer=no
  local tag=$1

  # keep $tag given as script arg?
  if [ ! -z "$tag" ]; then
    1>&2 echo "$tag"
    read answer
    if is_answer_affirmative "$answer"; then
      echo $tag
      return
    fi
  fi

  # generate new one then:
  while is_answer_negative "$answer"; do
    tag=$(random_words 1)
    1>&2 echo "$tag"
    read answer
  done
  echo $tag
}

choose_tags () {
  local answer=no
  local tag=$2
  local nb_tags=$1

  # keep $tag given as script arg?
  if [ ! -z "$tag" ]; then
    1>&2 echo "tag? $tag"
    read answer
    if is_answer_affirmative "$answer"; then
      echo $tag
      return
    fi
    answer=no
  fi


  # generate new one then:
  while is_answer_negative "$answer"; do
    tag=$(random_words $nb_tags | sk)
    if [ ! -z $tag ]; then
      1>&2 echo "tag? $tag"
      read answer
    fi
  done
  echo $tag
}
