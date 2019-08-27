#! /bin/sh

R1=git@gitlab.com:wonko7
R2=git@github.com:Wonko7

get_current_repo_name ()
{
  git config --get remote.origin.url | sed -nre 's:.*/::p'
}

list_relative_submodules () {
  grep "url = ../" -B 1 .gitmodules | sed -nre 's:.*path = ::p'
}

init_relative_submodule ()
{
  r=$(get_current_repo_name)
  lab="$R1/$r"
  hub="$R2/$r"
  echo $r:
  echo $lab
  echo $hub
  echo
  git remote add lab "$lab"
  git remote add hub "$hub"
  git remote set-url --add --push origin "$lab"
  git remote set-url --add --push origin "$hub"
}

r=$(get_current_repo_name)
if [ "$r" != conf-root -a "$r" != conf-root.git ]; then
  echo And the worms ate into his brain
  exit 1
fi
init_relative_submodule

for root_project in $(find . -name .gitmodules); do
  pushd $(dirname $root_project) > /dev/null
  root_project_name=$(get_current_repo_name)
  echo $root_project_name:
  for sm in $(list_relative_submodules); do
    pushd $sm > /dev/null
    echo $sm: relative submodule of $root_project_name
    init_relative_submodule
    popd > /dev/null
  done
  popd > /dev/null
done
