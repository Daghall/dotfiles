let s:mapped = {}

function! s:OnJumpToFrame() abort
  if has_key( s:mapped, string( bufnr() ) )
    return
  endif

  nmap <silent> <buffer> J <Plug>VimspectorStepOver
  nmap <silent> <buffer> L <Plug>VimspectorStepInto
  nmap <silent> <buffer> H <Plug>VimspectorStepOut
  nmap <silent> <buffer> K <Plug>VimspectorStepOut
  nmap <silent> <buffer> C <Plug>VimspectorContinue
  nmap <silent> <buffer> I <Plug>VimspectorBalloonEval
  nmap <silent> <buffer> E :call vimspector#Reset()<CR>
  nmap <silent> <buffer> R <Plug>VimspectorRestart

  let s:mapped[ string( bufnr() ) ] = { 'modifiable': &modifiable }

  setlocal nomodifiable

endfunction

function! s:OnDebugEnd() abort

  let original_buf = bufnr()
  let hidden = &hidden
  augroup VimspectorSwapExists
    au!
    autocmd SwapExists * let v:swapchoice='o'
  augroup END

  try
    set hidden
    for bufnr in keys( s:mapped )
      try
        execute 'buffer' bufnr
        silent! nunmap <buffer> J
        silent! nunmap <buffer> L
        silent! nunmap <buffer> H
        silent! nunmap <buffer> K
        silent! nunmap <buffer> C
        silent! nunmap <buffer> I
        silent! nunmap <buffer> E
        silent! nunmap <buffer> R

        let &l:modifiable = s:mapped[ bufnr ][ 'modifiable' ]
      endtry
    endfor
  finally
    execute 'noautocmd buffer' original_buf
    let &hidden = hidden
  endtry

  au! VimspectorSwapExists

  let s:mapped = {}
endfunction

augroup TestCustomMappings
  au!
  autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
  autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
augroup END
