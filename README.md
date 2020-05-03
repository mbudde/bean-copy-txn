# bean-copy-txn

(Neo)vim plugin for copying previous [Beancount](http://furius.ca/beancount/)
transactions with fuzzy search via [fzf](https://github.com/junegunn/fzf/).

## Dependencies

- [fzf](https://github.com/junegunn/fzf/)
- [Rust compiler](https://www.rust-lang.org/)

## Installation

With [vim-plug](https://github.com/junegunn/vim-plug/):

  Plug 'mbudde/bean-copy-txn', { 'rtp': 'vim', 'do': 'cd bin && cargo build --release' }
