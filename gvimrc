
" vug in MacVim? it fails to detect markdown filetype (installed through
" vim-addon-manager)
autocmd BufRead *.mkd set ft=markdown

noremap <C-Right> :tabnext<CR>
noremap <C-Left> :tabprevious<CR>
set guioptions=ace
" color underwater
color solarized

autocmd FileType scala hi scalaNew gui=underline
autocmd FileType scala hi scalaMethodCall gui=italic
autocmd FileType scala hi scalaValName gui=underline
autocmd FileType scala hi scalaVarName gui=underline
