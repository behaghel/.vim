" ===================================================================
" File:		Mail_Moderation_set.vim
" Author:	Luc Hermitte <EMAIL:hermitte at free.fr>
" 		<URL:http://hermitte.free.fr/vim>
" Last Update:	21st jul 2002
" Version:	2.0b
" Purpose:	Define a macro [,mod] in order to ease the moderation of
" 		moderated newsgroups. Everything is customize for the
" 		newsgroups <fr.rec.jeux.video.*> which are moderated with
" 		modappbot.
"
" -------------------------------------------------------------------
" Commandes permettant de faire des réponses persos aux posteurs de
" frjv lorsque l'on ne passe pas par le robot et que l'on ne veut pas
" s'embéter à faire des copier-coller entre toutes les entêtes.
" ===================================================================
"
if !exists("g:loaded_Mail_Moderation_set_vim")
  let g:loaded_Mail_Moderation_set_vim = 1

"
call BuildHelp("mail", '[ n  ]    ,mod  = aide à la modération des frjv.*')
  nmap ,mod :call ModConvHeaders()<cr>,m_sig

" ===================================================================
" Function: ModListe(newsgroup name)
" Returns:	the address of the moderators Mailing-list regarding the
" 		moderated newsgroup specified.
function! ModListe(newsgroup)
  let root   = 'fr\.rec\.jeux\.'
  let list   = 'moderateurs-frj'
  let server = '@listserv.usenet-fr.net'
  if a:newsgroup =~ root . 'video\.debat'
    return list . 'vd' . server
  elseif a:newsgroup =~ root . 'video'
    return list . 'v' . server
  elseif a:newsgroup =~ root . 'bienvenue'
    return list . 'b' . server
  endif
endfunction

" ===================================================================
" Prehistorical mappings
  noremap ,m_to 1G/^To: /e1<CR>Dmx/From: /e1<CR>y$`xp
     ""map ,m_subject 1G/Subject: /e1<CR>DaRe: <esc>mxny$`xp,re
     map ,m_subject 1G/Subject: /e1<CR>DaRe: [frjv]<esc>mxny$`xp,re
  noremap ,m_eff 1G/^In-Reply-To: <CR>dd/On .* wrote:<CR>ddO<esc>20a-<esc>a Message original <esc>20a-<esc>
  noremap ,m_ent :%g/^[>[:space:]]*X-.*$/d<CR>
  ""noremap ,m_frjv 1G/^Subject: /e1<CR>mx/fr\.rec\.jeux\(\.video\)\=\./e1<CR>"a2x"aP
  ""noremap ,m_frjv 1G/^Subject: /e1<CR>mx/fr\.rec\.jeux\(\.video\)\=\./e1<CR>

  ""noremap ,m_list0 :s/-frjvst/-frjvs/e<CR>
  ""map ,m_liste mxAmoderateurs-frjv<esc>"apA@listserv.usenet-fr.net<esc>,m_list0
  ""map ,m_liste Amoderateurs-frjv@listserv.usenet-fr.net<esc>
  ""map ,m_cc 1G/^Cc: /<CR>,m_liste
  ""map ,m_replyto 1G/^Reply-To: /<CR>,m_liste

  noremap ,m_sig 1G/^$/<CR>oBonjour,<esc>mxo<cr><cr>Ludiquement,<cr>-- <cr>Luc Hermitte, co-modérateur des frjv.*<cr><cr><esc>`xi 
      map ,m_fin G,dp
  ""map ,mod ,m_to,m_frjv,m_cc,m_replyto,m_subject,m_eff,m_ent,m_fin,m_sig

" ===================================================================
" Function: ModAddToLine(field,string)
" Purpose:	Adds the string at the end of the first line that begin
" 		with the required field.
" Caution:	Does not handle the case when no such line is found.
function! ModAddToLine(field,str)
  normal 1G
  exe '/^' . a:field
  let l = line('.')
  call setline(l,getline(l).a:str)
endfunction

" ===================================================================
" Function: ModConvHeaders()
" Purpose:	Main function that changes the fields within the headers of
" 		the e-mail.
function! ModConvHeaders()
  normal ,m_to1G
  /^Subject: /
  let subjectline = line('.')
  let newsgroup = matchstr(getline(subjectline),'fr\.rec\.jeux\.\S\+')
  call ModAddToLine('Cc:\s*', ModListe(newsgroup))
  call ModAddToLine('Reply-To:\s*', ModListe(newsgroup))
  normal ,m_subject,m_eff,m_ent,m_fin
endfunction


" ===================================================================
endif
