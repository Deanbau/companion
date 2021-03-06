#!/bin/bash


function parse_git_dirty() {
	git diff --quiet --ignore-submodules HEAD 2>/dev/null; [ $? -eq 1 ] && echo ""
}

# gets the current git branch
function parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

# get last commit hash prepended with @ (i.e. @8a323d0)
function parse_git_hash() {
	git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/"
}

function release() {
	cat package.json |grep \"version\"|cut -f4 -d\"
}

# DEMO
GIT_BRANCH=$(release)-$(parse_git_hash)

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
	mv -vf electron-output/Companion*.zip electron-output/companion-${GIT_BRANCH}-osx.zip
elif [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
	mkdir electron-linux-output
	cp electron-output/*.tar.gz electron-linux-output/companion-${GIT_BRANCH}-linux.tar.gz
elif [[ "$TRAVIS_OS_NAME" == "win64" ]]; then
	mv -f electron-output/*.exe electron-output/companion-${GIT_BRANCH}-win64.exe
fi
