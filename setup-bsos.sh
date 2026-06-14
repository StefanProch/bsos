#!/usr/bin/env bash
set -euo pipefail

PROJECT="/media/berlin/windows/Programy/Orca-najnowszy"
GH_REPO="git@github.com:StefanProch/bsos.git"
GH_NAME="StefanProch"
GH_EMAIL="stefan.proch@int.pl"
KEY="$HOME/.ssh/id_ed25519_bsos"

cd "$PROJECT"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$KEY" ]; then
    ssh-keygen -t ed25519 -C "$GH_EMAIL" -f "$KEY" -N ""
fi

chmod 600 "$KEY"
chmod 644 "$KEY.pub"

echo
echo "Dodaj ten klucz do GitHub:"
echo "GitHub -> Settings -> SSH and GPG keys -> New SSH key"
echo
cat "$KEY.pub"
echo
read -rp "Po dodaniu klucza naciśnij Enter..."

cat > .gitignore <<'EOF'
build/
build-*/
cmake-build-*/
out/
dist/
install/
_deps/
vcpkg_installed/

CMakeCache.txt
CMakeFiles/
cmake_install.cmake
compile_commands.json
build.ninja
.ninja_deps
.ninja_log

*.o
*.obj
*.a
*.so
*.dylib
*.dll
*.exe
*.app
*.log

.DS_Store
Thumbs.db

.vscode/
.idea/
EOF

git init
git config user.name "$GH_NAME"
git config user.email "$GH_EMAIL"
git config core.sshCommand "ssh -i $KEY -o IdentitiesOnly=yes"

git branch -M main

if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "$GH_REPO"
else
    git remote set-url origin "$GH_REPO"
fi

git add -A
git commit -m "Initial public test source"
git push -u origin main

echo
echo "OK:"
echo "https://github.com/StefanProch/bsos"
