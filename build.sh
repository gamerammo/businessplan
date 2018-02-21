#!/usr/bin/env bash

##
## Usage: build.sh [white]
##


set -e

rm -rf options.tex

if [ -d ".git" ]; then

SHA=`git rev-parse --short --verify HEAD`
DATE=`git show -s --format="%cd" --date=short HEAD`
REV="$SHA - $DATE"
echo "\def\businessplanVersionNumber{$REV}" >> options.tex

fi


if [ "$1" == "white" ]; then

echo "\definecolor{pagecolor}{rgb}{1,1,1}" >> options.tex

fi



echo "\newcommand{\businessplanVersionNunmber}{$REV}" > version.tex

mkdir build
pdflatex -output-directory=build -interaction=errorstopmode -halt-on-error plan.tex && \
bibtex build/plan && \
pdflatex -output-directory=build -interaction=errorstopmode -halt-on-error plan.tex && \
pdflatex -output-directory=build -interaction=errorstopmode -halt-on-error plan.tex && \
pdflatex -output-directory=build -interaction=errorstopmode -halt-on-error plan.tex
rm -rf options.tex
