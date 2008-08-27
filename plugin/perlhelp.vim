" vim600: set foldmethod=marker:
" =============================================================================
" File:         perlhelp.vim (global plugin)
" Last Changed: 2007-06-15
" Maintainer:   Lorance Stinson <LoranceStinson+perlhelp@gmail.com>
" Version:      1.3
" License:      Vim License
" =============================================================================

" Changes {{{1

" 1.3 2007-06-15
" Set the file type to man if viewing general perldoc output.

" 1.3 2007-06-14
" Improved handling of the results form <cWORD> and combined the handler
" functions for PerlHelp, PerlMod \ph and \pm into one.

" 1.2 2007-06-14
"   Removed 'setlocal iskeyword+=:' and used <cWORD> and a substitution
"   as suggested by Erik Falor.

" 1.1 2007-06-13
"   Added 'setlocal iskeyword+=:' to account for :'s in module names.

" Initialization. {{{1
" Allow user to avoid loading this plugin and prevent loading twice.
if exists ('loaded_perlhelp')
    finish
endif

let loaded_perlhelp = 1

" Make sure perlhelp is available and executable
if exists('perlhelp_prog')
    let s:perlhelp = perlhelp_prog
else
    let s:perlhelp = 'perldoc'
endif
if !executable(s:perlhelp)
  echoe 'perldoc is not installed!'
  finish
endif
let s:perlhelp = s:perlhelp . ' -T -t '

" Easy access commands. {{{2
:command! -nargs=? PerlFAQ  call <SID>PerlHelpFAQ(<f-args>)
:command! -nargs=? PerlFunc call <SID>PerlHelpFunc(<f-args>)
:command! -nargs=? PerlHelp call <SID>PerlHelp('topic', '', <f-args>)
:command! -nargs=? PerlMod  call <SID>PerlHelp('module', '-m', <f-args>)

" asksh@cpan.org: Shortcuts
:command! -nargs=? Pq  call <SID>PerlHelpFAQ(<f-args>)
:command! -nargs=? Pf  call <SID>PerlHelpFunc(<f-args>)
:command! -nargs=? Ph  call <SID>PerlHelp('topic', '', <f-args>)
:command! -nargs=? Pm  call <SID>PerlHelp('module', '-m', <f-args>)

" Key mappings. {{{2
if !hasmapto('<Plug>PerlHelpNormal')
    nmap <silent> <unique> <Leader>ph <Plug>PerlHelpNormal
endif
if !hasmapto('<Plug>PerlHelpVisual')
    vmap <silent> <unique> <Leader>ph <Plug>PerlHelpVisual
endif
if !hasmapto('<Plug>PerlHelpAsk')
    nmap <silent> <unique> <Leader>PH <Plug>PerlHelpAsk
endif
if !hasmapto('<Plug>PerlHelpFuncNormal')
    nmap <silent> <unique> <Leader>pf <Plug>PerlHelpFuncNormal
endif
if !hasmapto('<Plug>PerlHelpFuncVisual')
    vmap <silent> <unique> <Leader>pf <Plug>PerlHelpFuncVisual
endif
if !hasmapto('<Plug>PerlHelpFuncAsk')
    nmap <silent> <unique> <Leader>PF <Plug>PerlHelpFuncAsk
endif
if !hasmapto('<Plug>PerlHelpModNormal')
    nmap <silent> <unique> <Leader>pm <Plug>PerlHelpModNormal
endif
if !hasmapto('<Plug>PerlHelpModVisual')
    vmap <silent> <unique> <Leader>pm <Plug>PerlHelpModVisual
endif
if !hasmapto('<Plug>PerlHelpModAsk')
    nmap <silent> <unique> <Leader>PM <Plug>PerlHelpModAsk
endif
if !hasmapto('<Plug>PerlHelpFAQNormal')
    nmap <silent> <unique> <Leader>pq <Plug>PerlHelpFAQNormal
endif
if !hasmapto('<Plug>PerlHelpFAQVisual')
    vmap <silent> <unique> <Leader>pq <Plug>PerlHelpFAQVisual
endif
if !hasmapto('<Plug>PerlHelpFAQAsk')
    nmap <silent> <unique> <Leader>PQ <Plug>PerlHelpFAQAsk
endif

" Plug mappings for the key mappings. {{{2
nmap <silent> <unique> <script> <Plug>PerlHelpNormal      :call <SID>PerlHelp('topic', '', expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpVisual     y:call <SID>PerlHelp('topic', '', '<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpAsk         :call <SID>PerlHelp('topic', '')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFuncNormal  :call <SID>PerlHelpFunc(expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpFuncVisual y:call <SID>PerlHelpFunc('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFuncAsk     :call <SID>PerlHelpFunc()<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpModNormal   :call <SID>PerlHelp('module', '-m', expand("<cWORD>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpModVisual  y:call <SID>PerlHelp('module', '-m', '<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpModAsk      :call <SID>PerlHelp('module', '-m')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFAQNormal   :call <SID>PerlHelpFAQ(expand("<cword>"))<CR>
vmap <silent> <unique> <script> <Plug>PerlHelpFAQVisual  y:call <SID>PerlHelpFAQ('<c-r>"')<CR>
nmap <silent> <unique> <script> <Plug>PerlHelpFAQAsk      :call <SID>PerlHelpFAQ()<CR>

" Functions. {{{1
" Ask for text to lookup. {{{2
function <SID>PerlHelpAsk(prompt)
    let l:string = input('Enter the ' . a:prompt . ' to lookup: ')
    return l:string
endfunction

" Display help on a perl FAQ entry. {{{2
function <SID>PerlHelpFAQ(...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk('FAQ regular expression')
    else
        let l:topic = a:1
    endif
    let l:text = system(s:perlhelp . " -q " . l:topic)
    call <SID>PerlHelpWindow(l:text, 'text')
endfunction

" Display help on a perl function. {{{2
function <SID>PerlHelpFunc(...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk('function')
    else
        " Remove any non alpha numeric characters with an optional leading hyphen.
        let l:topic = substitute(a:1, '^[^[:alnum:]\-]*\(-\=[[:alnum:]]*\).*', '\1', 'g')
    endif
    let l:text = system(s:perlhelp . " -f " . l:topic)
    call <SID>PerlHelpWindow(l:text, 'text')
endfunction

" Lookup a module or general topic.
" question is the question to as if no topic is supplied.
" option is currently only used for looking up module source.
function <SID>PerlHelp(question, option, ...)
    if a:0 == 0
        let l:topic = <SID>PerlHelpAsk(a:question)
    else
        let l:topic = substitute(a:1, '^[^[:alnum:]_:]*\([[:alnum:]_:]*\).*', '\1', 'g')
        let l:topic = substitute(l:topic, '-*$', '', '')
    endif

    " Try to lookup the topic.
    while 1
        let l:text = system(s:perlhelp . a:option . ' ' . l:topic)
        if l:text =~ '^No [[:alpha:]]* found for'
            " The module was not found.
            " Try stripping off the last bit.
            if l:topic =~ '::'
                " Strip off the last bit of the module.
                " eg. Getopt::Std::STANDARD_HELP_VERSION becomes Getopt::Std
                let l:topic = substitute(l:topic, '::[^:]*$', '', '')
            else
               " No more to strip off, give up.
               break
            endif
        else
            " Found the module.
            break
        endif
    endwhile

    " Only turn on syntax highlighting when looking up the source for a module
    " and one was found.
    if a:option == '-m'
        if l:text =~ '^No [[:alpha:]]* found for'
            let l:type = 'text'
        else
            let l:type = 'perl'
        endif
    else
        let l:type = 'man'
    endif

    " Display the text.
    call <SID>PerlHelpWindow(l:text, l:type)
endfunction

" Display the actual text. {{{2
" Split the window or use the existing split to display the text.
" Taken from asciitable.vim by Jeffrey Harkavy.
function <SID>PerlHelpWindow(command, syntax)
    let s:vheight = 19
    let s:vwinnum=bufnr('__PerlHelp')
    if getbufvar(s:vwinnum, 'PerlHelp')=='PerlHelp'
        let s:vwinnum=bufwinnr(s:vwinnum)
    else
        let s:vwinnum=-1
    endif
    
    if s:vwinnum >= 0
        " if already exist
        if s:vwinnum != bufwinnr('%')
          exe "normal \<c-w>" . s:vwinnum . 'w'
        endif
        setlocal modifiable
        silent %d _
    else
        execute s:vheight.'split __PerlHelp'
    
        setlocal noswapfile
        setlocal buftype=nowrite
        setlocal bufhidden=delete
        setlocal nonumber
        setlocal nowrap
        setlocal norightleft
        setlocal foldcolumn=0
        setlocal nofoldenable
        setlocal modifiable
        let b:PerlHelp='PerlHelp'
    endif

    silent put! =a:command
    setlocal nomodifiable
    1 " Skip to the top of the text.
    " Set the syntax for the file.
    if a:syntax != ''
        execute "set ft=" . a:syntax
    else
        set ft=text
    endif
endfunction
