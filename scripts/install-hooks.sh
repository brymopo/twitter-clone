#!/bin/sh

GIT_DIR=$(git rev-parse --git-dir)

echo "Installing hooks..."
# this command creates symlink to our pre-commit script
ln -s -f ../../scripts/pre-commit.sh ./$GIT_DIR/hooks/pre-commit
# ln -s ../../scripts/pre-push.bash $GIT_DIR/hooks/pre-push
echo "Done!"