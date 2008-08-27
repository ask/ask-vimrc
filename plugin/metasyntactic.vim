" vim600: set foldmethod=marker:
" =============================================================================
" File:         metasyntactic.vim (global plugin)
" Last Changed: 2007-11-13
" Author:       Ask Solem <ask@0x61736b.net>
" Version:      0.1
" License:      Vim License
" =============================================================================

function! <SID>Get_Random_MetaSyntactic_Theme()
    let l:metatheme_cmd = "metatheme"
    let l:metatheme = system(l:metatheme_cmd)
    return l:metatheme
endfunction

let s:metatheme_loaded = 0

function! <SID>Select_Random_MetaSyntactic_Theme()
    let s:metatheme = <SID>Get_Random_MetaSyntactic_Theme()
    if s:metatheme_loaded == 1
        echo "Selected metasyntactic theme: " . s:metatheme
    endif
    let s:metatheme_loaded = 1
endfunction

" select a theme at startup.
let tmptmp = <SID>Select_Random_MetaSyntactic_Theme()

function! <SID>Insert_MetaSyntactic_Word()
    let l:meta_cmd      = "meta"
    let l:new_meta_word = system(l:meta_cmd . " " . s:metatheme)
    silent! put = l:new_meta_word
endfunction

command! -nargs=0 -bar MetaSyntactic call <SID>Insert_MetaSyntactic_Word()
command! -nargs=0 -bar NextMetaTheme call <SID>Select_Random_MetaSyntactic_Theme()

map ,z <Esc>:MetaSyntactic<CR><Esc>
map ,Z <Esc>:NextMetaTheme<CR><Esc>
