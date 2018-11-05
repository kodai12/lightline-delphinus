" =============================================================================
" Filename: plugin/lightline_delphinus.vim
" Author: sakochik
" License: MIT License
" Last Change: 2018-11-3T09:45:50+0900.
" =============================================================================

scriptencoding utf-8

if exists('g:loaded_lightline_delphinus')
  finish
endif
let g:loaded_lightline_delphinus = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let g:lightline_delphinus_use_powerline_glyphs = get(g:, 'lightline_delphinus_use_powerline_glyphs', 0)
let g:lightline_delphinus_use_nerd_fonts_glyphs = get(g:, 'lightline_delphinus_use_nerd_fonts_glyphs', 0)

if g:lightline_delphinus_use_powerline_glyphs
  let s:separator = {'left': '', 'right': ''}
  let s:subseparator = {'left': '', 'right': ''}
else
  let s:separator = {'left': '', 'right': ''}
  let s:subseparator = {'left': '|', 'right': '|'}
endif

let g:lightline_delphinus_colorscheme = get(g:, 'lightline_delphinus_colorscheme', 'solarized_improved')
if g:lightline_delphinus_colorscheme !=# 'solarized_improved' && g:lightline_delphinus_colorscheme !=# 'nord_improved'
  call lightline#error('g:lightline_delphinus_colorscheme must be solarized_improved (default) or nord_improved')
endif

let g:lightline_delphinus_tagbar_enable = 0
let g:tagbar_status_func = 'lightline#delphinus#components#tagbar_status'

let g:lightline_delphinus_gitgutter_enable = 0

let g:lightline = {
        \ 'colorscheme': g:lightline_delphinus_colorscheme,
        \ 'active': {
        \   'left': [
        \     [ 'mode', 'paste', 'readonly' ],
        \     [ 'fugitive', 'gitgutter' ],
        \     [ 'filepath' ],
        \     [ 'filename', 'currenttag' ]
        \   ],
        \   'right': [
        \     [ 'toggle_task', 'toggle_time','lineinfo',  'percent' ],
        \     [ 'ale_error', 'ale_warning', 'ale_ok' ],
        \     [ 'fileformat', 'fileencoding', 'filetype' ]
        \   ],
        \ },
        \ 'inactive': {
        \   'right': [ [ 'lineinfo' ], [ 'percent' ] ],
        \ },
        \ 'component': {
        \   'sky_color_clock': "%#SkyColorClock#%{' ' . sky_color_clock#statusline() . ' '}%#SkyColorClockTemp# ",
        \ },
        \ 'component_raw': {
        \   'sky_color_clock': 1,
        \ },
        \ 'component_function': {
        \   'modified':     'lightline#delphinus#components#modified',
        \   'readonly':     'lightline#delphinus#components#readonly',
        \   'fugitive':     'lightline#delphinus#components#fugitive',
        \   'filepath':     'lightline#delphinus#components#filepath',
        \   'filename':     'lightline#delphinus#components#filename',
        \   'fileformat':   'lightline#delphinus#components#fileformat',
        \   'filetype':     'lightline#delphinus#components#filetype',
        \   'fileencoding': 'lightline#delphinus#components#fileencoding',
        \   'mode':         'lightline#delphinus#components#mode',
        \   'char_code':    'lightline#delphinus#components#charcode',
        \   'lineinfo':     'lightline#delphinus#components#lineinfo',
        \   'percent':      'lightline#delphinus#components#percent',
        \   'currenttag':   'lightline#delphinus#components#currenttag',
        \   'gitgutter':    'lightline#delphinus#components#gitgutter',
        \   'toggl_task': 'toggl#task',
        \   'toggl_time': 'toggl#time',
        \ },
        \ 'component_function_visible_condition': {
        \   'mode': 1,
        \   'currenttag': 0,
        \   'char_code': 0,
        \   'fileformat': 0,
        \   'filetype': 0,
        \   'fileencoding': 0,
        \ },
        \ 'component_expand': {
        \   'ale_error':   'lightline#delphinus#components#ale_error',
        \   'ale_warning': 'lightline#delphinus#components#ale_warning',
        \   'ale_ok':      'lightline#delphinus#components#ale_ok',
        \ },
        \ 'component_type': {
        \   'ale_error':   'error',
        \   'ale_warning': 'warning',
        \   'ale_ok':      'ok',
        \ },
        \ 'separator': s:separator,
        \ 'subseparator': s:subseparator,
        \ }
let s:palette = g:lightline#colorscheme#{g:lightline_delphinus_colorscheme}#palette
let s:palette.tabline.tabsel = [ [ '#d0d0d0', '#5f8787', 252, 66, 'bold' ] ]
unlet s:palette
let g:lightline.tabline = {
      \ 'left': [ [ 'tabs' ] ],
      \ 'right': [ [ 'sky_color_clock' ] ] }
let g:lightline.tab = {
      \ 'active': [ 'tabnum', 'filename', 'modified' ],
      \ 'inactive': [ 'tabnum', 'filename', 'modified' ]
      \ }
let g:lightline.tab_component_function = {
      \ 'filename': 'MyTabFilename',
      \ 'modified': 'lightline#tab#modified',
      \ 'readonly': 'lightline#delphinus#components#readonly',
      \ 'tabnum': 'lightline#tab#tabnum' }

function! MyTabFilename(n) abort
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let _ = pathshorten(expand('#'.buflist[winnr - 1].':f'))
  return _ !=# '' ? _ : '[No Name]'
endfunction

augroup LightLineOnALE
  autocmd!
  autocmd User ALELint     call lightline#update()
  autocmd User ALEFixPre  call lightline#delphinus#components#ale_pre()
  autocmd User ALEFixPost call lightline#delphinus#components#ale_post()
  autocmd User GitGutter   call lightline#delphinus#components#gitgutter_pre()
augroup end

let &cpoptions = s:save_cpo
unlet s:save_cpo
