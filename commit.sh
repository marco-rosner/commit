#!/bin/bash
## Bash script to use git
## 
## Usage: bash commit.sh
## 
## Copyleft 2015 Jacques Sauvé and Marco Rosner
## Last revised 10/10/2015
##
## https://github.com/marcorosner/commit

error(){
    echo $* >&2
    exit 1
}
MASTER=master
currentBranch=$(git rev-parse --abbrev-ref HEAD)

# Commit

if git status | grep "nothing to commit" >/dev/null; then
    echo "Nothing to commit"
else

    # Creating branch

    if [ $currentBranch == $MASTER ]; then

        echo "WARNING: You are on *master*!"
        echo "I will help you to create a branch with your changes."
        echo "But, in the next time, I will leave you crash! ¬¬'"
        echo "What the name of your branch? "
        read resp

        currentBranch=$(echo $resp | sed -e "s/ /-/g")
        git stash
        git stash branch $currentBranch

    fi

    echo "Committing branch $currentBranch"
    git add -A && git commit

fi

# If exist, fetch upstream

if git remote -v | grep "upstream" >/dev/null; then
    echo -n "Would you like to fetch upstream? [y|n]?"
    read resp
    if [ "$resp" == 'y' ]; then

        git fetch upstream
        git checkout master

        # Merge upstream in the master branch

        git merge upstream/master

    fi
fi

# If diferent, merge branch in the master branch

if [ $currentBranch != $MASTER ]; then
    echo -n "Would you like to merge your branch $currentBranch into master [y|n]?"
    read resp
    if [ "$resp" == 'y' ]; then
        git checkout master
        git merge $currentBranch
        currentBranch=$MASTER
    fi
fi

# Push

git diff $MASTER origin/$MASTER -s --exit-code
difference=$?
if [ $currentBranch == $MASTER -a $difference -eq 1 ]; then
    echo -n "Would you like to push the master branch to origin [y|n]?"
    read resp
    if [ "$resp" == 'y' ]; then

        git push origin $currentBranch

    else
        echo "Push does not executed!"
    fi
fi

# Tag

echo -n "Would you like to make a tag [y|n]?"
read resp

if [ "$resp" == 'y' ]; then
    newversion=
    version=$(git describe --abbrev=0 --tags)
    arr=(${version//./ })
    newversion=${arr[0]}.${arr[1]}.$((${arr[2]}+1))
    echo "Main version: $version"
    echo -n "Number of the new version vn.m [entra=${newversion}]? "
    read resp
    [ "$resp" != "" ] && newversion=$resp
    echo New version: $newversion
    git tag $newversion
    git push origin $currentBranch --tags
    echo New version $(git describe --abbrev=0 --tags)
fi