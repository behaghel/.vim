" {W} -> [É]
" ——————————
" On remappe W sur É :
noremap é w
noremap É W
" Corollaire, pour effacer/remplacer un mot quand on n’est pas au début (daé / laé).
" (attention, cela diminue la réactivité du {A}…)
noremap ié iw
noremap iÉ iW
noremap aé aw
noremap aÉ aW
" Pour faciliter les manipulations de fenêtres, on utilise {W} comme un Ctrl+W :
noremap w <C-w>
noremap W <C-w><C-w>
 
" [HJKL] -> {CTSR}
" ————————————————
" {cr} = « gauche / droite »
noremap c h
noremap r l
" {ts} = « haut / bas »
noremap t j
noremap s k
" {CR} = « haut / bas de l'écran »
"noremap C H
"noremap R L
" {TS} = « joindre / aide »
"noremap T J
"noremap S K
" Corollaire : repli suivant / précédent
noremap zs zj
noremap zt zk
 
" {HJKL} <- [CTSR]
" ————————————————
" {J} = « Remplace »           (j = un caractère slt, J = reste en « Remplace »)
noremap j r
noremap <leader>j R
" {L} = « Change »             (l = attend un mvt, L = jusqu'à la fin de ligne)
noremap l c
noremap L C
" {H} = « Jusqu'à »            (h = suivant, H = précédant)
noremap h t
noremap H T
noremap <leader>h K
" {K} = « Substitue »          (k = caractère, K = ligne)
noremap k s
noremap K S
" Corollaire : correction orthographique
noremap ]k ]s
noremap [k [s
 
" Désambiguation de {g}
" —————————————————————
" ligne écran précédente / suivante (à l'intérieur d'une phrase)
noremap gs gk
noremap gt gj
" onglet précédant / suivant
noremap gb gT
noremap gé gt
" optionnel : {gB} / {gÉ} pour aller au premier / dernier onglet
noremap gB :exe "silent! tabfirst"<CR>
noremap gÉ :exe "silent! tablast"<CR>
" optionnel : {g"} pour aller au début de la ligne écran
" noremap g" g0
 
" <> en direct
" ————————————
noremap « <
noremap » >
inoremap « <
inoremap » >


" CommandT options
let g:CommandTAcceptSelectionTabMap = ['<C-h>']
let g:CommandTSelectNextMap = ['<C-t>', '<C-n>', '<Down>']
let g:CommandTSelectPrevMap = ['<C-s>', '<C-p>', '<Up>']
let g:CommandTAcceptSelectionSplitMap = ['<C-S>', '<C-CR>']
" surround
" disable s in visual (bepo conflict)
xmap <Leader>s <Plug>Vsurround
