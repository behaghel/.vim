
" CommandT options
let g:CommandTAcceptSelectionTabMap = ['<C-h>']
let g:CommandTSelectNextMap = ['<C-t>', '<C-n>', '<Down>']
let g:CommandTSelectPrevMap = ['<C-s>', '<C-p>', '<Up>']
let g:CommandTAcceptSelectionSplitMap = ['<C-S>', '<C-CR>']
" surround
let g:surround_no_mappings=1
" disable s in visual (bepo conflict)
xmap <Leader>s <Plug>Vsurround
" switch cs for ls
nmap ls        <Plug>Csurround
" as is
nmap ds  <Plug>Dsurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
if maparg('s', 'x') ==# ''
  xnoremap <silent> s :<C-U>echoerr 'surround.vim: Visual mode s has been removed in favor of S'<CR>
endif
if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
  imap    <C-S> <Plug>Isurround
endif
imap      <C-G>s <Plug>Isurround
imap      <C-G>S <Plug>ISurround

" camelcasemotion
map <silent> <leader>é <Plug>CamelCaseMotion_w
sunmap <leader>é
omap <silent> <leader>ié <Plug>CamelCaseMotion_iw
xmap <silent> <leader>ié <Plug>CamelCaseMotion_iw

" NERDTree
let NERDTreeMapOpenInTab='h'
let NERDTreeMapOpenInTabSilent='H'
let NERDTreeMapOpenVSplit='<C-v>'
let NERDTreeMapJumpFirstChild='S'
let NERDTreeMapJumpLastChild='T'
let NERDTreeMapJumpNextSibling='<C-T>'
let NERDTreeMapJumpPrevSibling='<C-S>'
"let NERDTreeMapChdir='L'
"let NERDTreeMapRefresh='j'
"let NERDTreeMapRefreshRoot='J'

" make something useful with our bépo key
nnoremap à <C-]>

