# bean-copy-txn

(Neo)vim plugin for copying previous [Beancount](http://furius.ca/beancount/)
transactions with fuzzy search via [fzf](https://github.com/junegunn/fzf/).

![Demo](https://github.com/mbudde/bean-copy-txn/raw/master/demo.gif)

## Dependencies

- [fzf](https://github.com/junegunn/fzf/)
- [Rust compiler](https://www.rust-lang.org/)

## Installation

With [vim-plug](https://github.com/junegunn/vim-plug/):

    Plug 'mbudde/bean-copy-txn', { 'do': './install.sh --build' }

Or download pre-built binaries (only 64-bit linux):

    Plug 'mbudde/bean-copy-txn', { 'do': './install.sh --download' }

