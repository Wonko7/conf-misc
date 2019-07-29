#! /bin/zsh

cd $conf
for i in pass-audit ergo git kernel-config misc vim zsh zsh/tmux-sessions zsh/bookmarks; do
  cd $i
  b=$(git b | sed -nre "s/^\* //p")
  echo $i $b
  (git push || echo "/!\\" $i $b failed &) >&2 &
  cd - > /dev/null
done | column -t
