#! /bin/sh

CONF_SUBMODULES="doom vim zsh ergodox misc s6-services xmonad"

init () {
  git checkout master
  git remote add trantor nostromo.underage.wang:/trantor/repos/conf/conf-$1
  git remote add hub git@github.com:Wonko7/conf-$1
  git remote add lab git@gitlab.com:wonko7/conf-$1
  #git remote add all nostromo.underage.wang:/trantor/repos/conf/conf-$1
  #git remote set-url --add --push all nostromo.underage.wang:/trantor/repos/conf/conf-$1
  #git remote set-url --add --push all git@gitlab.com:wonko7/conf-$1
  #git remote set-url --add --push all git@github.com:Wonko7/conf-$1
}

clone () {
  git clone --recurse-submodules -j 10 nostromo.underage.wang:/trantor/repos/conf/conf-root

  cd conf-root
  git checkout master

  init root

  for i in $CONF_SUBMODULES; do
    pushd $i > /dev/null
    echo $i
    init $i
    popd > /dev/null
  done

  git clone --recurse-submodules -j 10 nostromo.underage.wang:/trantor/repos/conf/private/private-root private

  pushd private
  git checkout master
  for i in *; do
    pushd $i > /dev/null
    git checkout master
    popd > /dev/null
  done
}

push_all () {
  # this is the opposite of letting git intelligently finding what's out of date and needs to be pushed.
  for i in $CONF_SUBMODULES; do
    echo $i
    pushd $i > /dev/null
    git push --all all
    popd > /dev/null
  done

  pushd private > /dev/null
  for i in *; do
    echo $i
    pushd $i > /dev/null
    git push --all
    popd > /dev/null
  done
  echo private-root
  git push --all
  popd > /dev/null

  echo conf-root
  git push --recurse-submodules=no all
}

$@
