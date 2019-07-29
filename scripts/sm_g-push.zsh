#! /bin/zsh

cd $conf
for i in ergo git kernel-config misc vim zsh zsh/tmux-sessions zsh/bookmarks .; do
  cd $i
  b=$(git b | sed -nre "s/^\* //p")
  echo $i $b
  #(/usr/bin/time -f "$i %e seconds" git push -q  2> $err || echo "/!\\" $i $b failed ) &
  (/usr/bin/time -f "$i %e seconds" git push -q || echo "/!\\" $i $b failed ) &
  if [ "$i" = "." ]; then
    (/usr/bin/time -f ". %e seconds" git push -q --tags  || echo "/!\\" $i $b failed ) &
  fi
  cd - > /dev/null
done | column -t
