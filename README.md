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
autocmd FileType ruby nnoremap <silent><buffer> % :<C-u>call cuculus#jump()<CR>
```

Advanced Usage: Display pair code with popup window

```vim
autocmd CursorMoved *.rb call cuculus#display_pair_to_popup()
```
