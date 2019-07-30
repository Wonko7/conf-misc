#! /bin/zsh

_col ()
{
  read l
  a=$(echo $l | cut -d' ' -f1)
  b=$(echo $l | cut -d' ' -f2)
  c=$(echo $l | cut -d' ' -f3)
  d=$(echo $l | cut -d' ' -f4)
  printf '%-15s %-15s %-15s %-15s\n' "$a" ""$b "$c" "$d"
}

push_fn ()
{
  name=$1
  branch=$2
  tags=$3

  if echo "$branch" | grep -q '(HEAD detached at'; then
    echo $name can\'t touch this | _col
  elif [ -z $tags ]; then
    /usr/bin/time -f "$name $branch %e seconds" git push -q 2>&1 | _col || echo "/!\\" $i $b failed
  else
    /usr/bin/time -f "$name --tags %e seconds" git push --tags -q 2>&1 | _col || echo "/!\\" $i $b failed
  fi
}

cd $conf
for i in ergo git kernel-config misc vim zsh zsh/tmux-sessions zsh/bookmarks .; do
  cd $i
  b=$(git b | sed -nre "s/^\* //p")
  push_fn $i $b&
  if [ "$i" = "." ]; then
    push_fn $i $b tag &
  fi
  cd - > /dev/null
done | column -t
