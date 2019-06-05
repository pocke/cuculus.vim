let s:self_path=expand("<sfile>")
execute "ruby require '" . s:self_path . ".rb'"

function! cuculus#jump() abort
  let pair = s:find_pair()
  if type(pair) == type([])
    call cursor(pair[0], pair[1]+1)
  endif
endfunction

function! cuculus#display_pair_to_popup() abort
  let code = s:pair_code_of_line()
  if type(code) != type("")
    return
  endif

  let code = "# " . trim(code)

  let col = len(getline('.')) + 3
  call popup_create(code, { "moved": "any", "line": "cursor", "col": col, "highlight": "Comment" })
endfunction

function! s:pair_code_of_line() abort
  let pair = s:find_pair()
  if type(pair) != type([])
    return v:null
  endif

  let line = pair[0]
  return getline(line)
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
    if pair
      Vim.command 'let s:result = ' + JSON.generate([pair.line, pair.column])
    else
      Vim.command 'let s:result = v:null'
    end
RUBY
  let l:result = s:result
  unlet s:result

  return l:result
endfunction
