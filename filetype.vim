" user filetype file
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect

au! BufNewFile,BufRead *.json         setf javascript
au! BufNewFile,BufRead *.applescript  setf applescript
