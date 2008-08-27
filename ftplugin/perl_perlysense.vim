if exists( "b:perlysense" )
    finish
endif
let b:perlysense = 1

map <silent> <Leader>pp :call PerlySense_POD()<cr>
map <silent> <Leader>pg :call PerlySense_smart_go_to()<cr>

function! PerlySense_POD()
    call GetPos()
    let command="perly_sense smart_doc --file=" . b:file." --row=".b:row." --col=".b:col
    echo system(command)
endfunction

function! PerlySense_smart_go_to()
    call GetPos()
    let command="perly_sense smart_go_to --file=" . b:file." --row=".b:row." --col=".b:col
    let result = split( system(command), "\t" )
    let file = result[0]
    execute "e " . file
endfunction

function! GetPos()
    let b:file = bufname("%")
    let b:row = line(".")
    let b:col = col(".")
endfunction
