function! cmp_vimtex#invoke(func, args) abort
  if a:func =~# '^v:lua\.'
    return luaeval(printf('%s(_A[1], _A[2], _A[3])', matchstr(a:func, '^v:lua\.\zs.*')), a:args)
  endif
  return nvim_call_function(a:func, a:args)
endfunction

function! cmp_vimtex#count(container, item) abort " {{{1
  " Necessary because in old Vim versions, count() does not work for strings
  try
    let l:count = count(a:container, a:item)
  catch /E712/
    let l:count = count(split(a:container, '\zs'), a:item)
  endtry

  return l:count
endfunction
