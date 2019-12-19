#! /bin/zsh

random_words ()
{
  local smut
  local words

  if [ -r "$SMUT" ]; then
    smut=$SMUT
  else
    smut=~/conf/private/smut/t-rex.words
  fi

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
