Cuculus.vim
===

`%` for Ruby.

Requirements
---


* if_ruby
* parser gem

Configuration
---

```vim
" Load Cuculus.vim with a plugin manager
NeoBundle 'pocke/cuculus.vim'

" Define a keymap
autocmd FileType ruby nmap <buffer> % :<C-u>call cuculus#jump()<CR>
```
