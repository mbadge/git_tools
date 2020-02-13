#! UNTESTED
NEW_PROJECT_DIR="/mnt/d/documents/R/my-pkgs/committee updates/"
GIT_URL="git@git.nak.co:mabadgeley/committee-updates.git"  # Create project on gitlab

cd $NEW_PROJECT_DIR
git init
git remote add origin ${GIT_URL}
git add .
git commit -m "Initial Commit"
git push -u origin master
mr register
cd ..
mr s
