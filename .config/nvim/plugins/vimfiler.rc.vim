call vimfiler#custom#profile('default', 'context', {
     \ 'safe' : 0,
     \ 'auto_expand' : 1,
     \ 'parent' : 0,
     \ })
"default explore -> vimfiler
let g:vimfiler_as_default_explorer = 1
"buffer directory
nnoremap <silent> ,fe :<C-u>VimFilerBufferDir -split -winwidth=45 -toggle -no-quit<CR>
" Textmate icons
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
let g:vimfiler_edit_action = 'tabopen'
