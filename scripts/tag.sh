#! /bin/sh

source $misc/scripts/random_words.sh

echo $PWD
echo $SMUT
git status --short

tag=$(choose_tag)
git tag -s "$tag" -m "$tag"
