#!/usr/bin/env bash

set -e

SHA=`git rev-parse --verify HEAD`

git config user.name "$COMMIT_AUTHOR"
git config user.email "$COMMIT_AUTHOR_EMAIL"
git checkout --orphan gh-pages
git rm --cached -r .
echo "# Automatic build" > README.md
echo "Built pdf from \`$SHA\`. See https://github.com/gamerammo/businessplan/ for details." >> README.md
echo "The generated pdf is here: https://gamerammo.github.io/plan.pdf" >> README.md
echo '<html><head><meta http-equiv="refresh" content="0; url=plan.pdf" /></head><body></body></html>' > index.html
mv build/plan.pdf plan.pdf
git add -f README.md index.html plan.pdf
git commit -m "Built pdf from {$SHA}."

ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $encrypted_acb03761bdb0_key -iv $encrypted_acb03761bdb0_iv -in deploy_rsa.enc -out deploy_rsa -d
chmod 600 deploy_rsa
eval `ssh-agent -s`
ssh-add deploy_rsa

git push -f "$PUSH_REPO" gh-pages
