#!/bin/bash

cd bin;

if [[ $1 == '--build' ]]; then
    cargo build --release
elif [[ $1 == '--download' ]]; then
    mkdir -p target/release
    tag=$(git describe --tags --match="v*" --abbrev=0)
    wget -q https://github.com/mbudde/bean-copy-txn/releases/download/${tag}/bean-copy-txn -O target/release/bean-copy-txn
    chmod +x target/release/bean-copy-txn
else
    echo 'usage: install.sh --build'
    echo '       install.sh --download'
fi
