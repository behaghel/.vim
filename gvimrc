
" bug in MacVim? it fails to detect markdown filetype (installed through
" vim-addon-manager)
autocmd BufRead *.mkd set ft=markdown

noremap <C-Right> :tabnext<CR>
noremap <C-Left> :tabprevious<CR>
set guioptions=ace
set guifont=Droid\ Sans\ Mono:h14
"set fuoptions=maxvert,maxhorz
" in fact, color does not concern only gvim: 
" shell vim can use it too
" color underwater
" color solarized

autocmd FileType scala hi scalaNew gui=underline
autocmd FileType scala hi scalaMethodCall gui=italic
autocmd FileType scala hi scalaValName gui=underline
autocmd FileType scala hi scalaVarName gui=underline
