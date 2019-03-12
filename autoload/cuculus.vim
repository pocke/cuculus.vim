let s:self_path=expand("<sfile>")
execute "ruby require '" . s:self_path . ".rb'"

function! cuculus#jump() abort
  let pair = s:find_pair()
  echom string(pair)
  if type(pair) == type([])
    call cursor(pair[0], pair[1]+1)
  endif
endfunction

function! s:find_pair() abort
  ruby <<RUBY
    # TODO: encoding, multi-bytes character count
    source = Vim.evaluate("getbufline('%', 1, '$')").join("\n")
    pair = Cuculus.pair_range(
      code: source,
      line: Vim.evaluate('line(".")'),
      column: Vim.evaluate('col(".")'),
    )
    res = pair ? [pair.line, pair.column] : nil
    Vim.command 'let s:result = ' + JSON.generate(res)
RUBY
  let l:result = s:result
  unlet s:result

  return l:result
endfunction
