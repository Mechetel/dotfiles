" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0
" original fr%!fmt -80 -som https://github.com/bling/dotvim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Initialize defaults
language en_US

"" Setup Shougo/dein.vim plugin manager
if (!isdirectory(expand('$HOME/.config/nvim/bundle/repos/github.com/Shougo/dein.vim')))
    call system(expand('mkdir -p $HOME/.config/nvim/bundle/repos/github.com'))
    call system(expand('git clone https://github.com/Shougo/dein.vim $HOME/.config/nvim/bundle/repos/github.com/Shougo/dein.vim'))
endif

" setup & dein {{{
  set rtp+=~/.config/nvim/bundle/repos/github.com/Shougo/dein.vim
  call dein#begin(expand('~/.config/nvim/bundle/'))
  call dein#add('Shougo/dein.vim')
"}}}

let s:cache_dir = '~/.config/nvim/.cache'
let s:settings = {}
let s:settings.default_indent = 2
let s:settings.max_column = 120

" helper functions
function! s:get_cache_dir(suffix) "{{{
  return resolve(expand(s:cache_dir . '/' . a:suffix))
endfunction "}}}

function! EnsureExists(path) "{{{
  if !isdirectory(expand(a:path))
    call mkdir(expand(a:path))
  endif
endfunction "}}}

let directory = '~/.config/nvim/.directory'
let undodir = '~/.config/nvim/.undodirectory'

" swap files
let &directory = s:get_cache_dir('swap')
set noswapfile

call EnsureExists(s:cache_dir)
call EnsureExists(&directory)

if !executable('ag')
  echoerr('You must install silver searcher')
endif

" base configuration
set showfulltag
set shell=/bin/sh
set noshelltemp                                     "use pipes
" set clipboard=unnamed
set inccommand=nosplit
set undofile
" set paste

" whitespace
set expandtab                                       "spaces instead of tabs
let &tabstop=s:settings.default_indent              "number of spaces per tab for display
let &softtabstop=s:settings.default_indent          "number of spaces per tab in insert mode
let &shiftwidth=s:settings.default_indent           "number of spaces when indenting
set list                                            "highlight whitespace
set listchars=tab:│\ ,trail:•,extends:❯,precedes:❮,space:·
set shiftround
set linebreak
let &showbreak='↪ '

set wildmode=list:full
set wildignorecase

set splitbelow
set splitright

" searching
set ignorecase                                      "ignore case for searching
set smartcase                                       "do case-sensitive if there's a capital letter
set grepprg=ag\ --nogroup\ --column\ --smart-case\ --nocolor\ --follow
set grepformat=%f:%l:%c:%m

let mapleader = ","
let g:mapleader = ","
let maplocalleader = "\\"

" ui configuration
set showmatch                                       "automatically highlight matching braces/brackets/etc.
set matchtime=2                                     "tens of a second to show matching parentheses
set number
set lazyredraw
set noshowmode
set foldmethod=syntax                               "fold via syntax of files
set foldlevelstart=99                               "open all folds by default
let g:xml_syntax_folding=1                          "enable xml folding
set completeopt-=preview

set cursorline
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
let &colorcolumn=s:settings.max_column

" set hidden

" shared helper
function! Preserve(command) "{{{
  " preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  execute a:command
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction "}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Core
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('github/copilot.vim') "{{{
  imap <silent><script><expr> <C-e> copilot#Accept('\<CR>')
  let g:copilot_no_tab_map = v:true
"}}}

call dein#add('vim-scripts/matchit.zip')
call dein#add('vim-airline/vim-airline') "{{{
  let g:airline_powerline_fonts = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = '¦'
  let g:airline#extensions#tabline#buffer_idx_mode = 1
  let g:airline#extensions#syntastic#enabled = 1
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
"}}}

call dein#add('nvim-tree/nvim-web-devicons')
call dein#add('nvim-lua/plenary.nvim')
call dein#add('nvim-telescope/telescope.nvim', { 'rev': '0.1.2' })
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

call dein#add('prettier/vim-prettier', {'build': 'npm install'})
call dein#add('tpope/vim-surround')
call dein#add('alvan/vim-closetag')
autocmd BufNewFile,BufRead *.html.erb let b:surround_{char2nr('=')} = "<%= \r %>"
autocmd BufNewFile,BufRead *.html.erb let b:surround_{char2nr('-')} = "<% \r %>"

call dein#add('tpope/vim-repeat')
call dein#add('tpope/vim-unimpaired') "{{{
  nmap <c-up> [e
  nmap <c-down> ]e
  vmap <c-up> [egv
  vmap <c-down> ]egv
"}}}

call dein#add('mhinz/vim-startify') "{{{
  let g:startify_session_dir = s:get_cache_dir('sessions')
  let g:startify_change_to_vcs_root = 1
  let g:startify_show_sessions = 1
  let g:startify_session_before_save = [
      \ 'tabdo NERDTreeClose'
      \ ]
  let g:startify_disable_at_vimenter = 1

  " enter last opened file if session was saved
  autocmd VimEnter * nested
    \   if !argc()
    \ |   silent! execute ":SLoad " . fnamemodify(getcwd(), ':t')
    \ |   redraw!
    \ | endif

  nnoremap <leader>S :SSave <C-R>=fnamemodify(getcwd(), ':t')<cr><cr>
"}}}

call dein#add('zhaocai/GoldenView.Vim', {'on_map':['<Plug>ToggleGoldenViewAutoResize']}) "{{{
  let g:goldenview__enable_default_mapping=0
"}}}
call dein#add('jszakmeister/vim-togglecursor')

" search with autocenter and autohide {{{
  call dein#add('haya14busa/is.vim')
  let g:is#do_default_mappings = 1

  call dein#add('haya14busa/vim-asterisk')
  let g:asterisk#keeppos = 1

  map n <Plug>(is-n)zz
  map N <Plug>(is-N)zz
  map *  <Plug>(asterisk-z*)zz<Plug>(is-nohl-1)
  map g* <Plug>(asterisk-gz*)zz<Plug>(is-nohl-1)
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Git
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('airblade/vim-gitgutter') " {{{
  nmap ]h <Plug>(GitGutterNextHunk)
  nmap [h <Plug>(GitGutterPrevHunk)
" }}}
call dein#add('tpope/vim-fugitive') "{{{
  nnoremap <silent> <leader>ga :silent !git add --all<CR>
  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>gl :Glog<CR>
  nnoremap <silent> <leader>gp :Git push<CR>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gr :Gremove<CR>
  autocmd BufReadPost fugitive://* set bufhidden=delete
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocomplete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('honza/vim-snippets')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('christoomey/vim-tmux-navigator')

if $TMUX != ''
  call dein#add('tmux-plugins/vim-tmux')
  call dein#add('wellle/tmux-complete.vim')
  call dein#add('benmills/vimux') " {{{
    let g:VimuxRunnerType = "window"
    let g:VimuxUseNearest = 0

    nnoremap <leader>tt :VimuxTogglePane<CR>
    nnoremap <leader>to :call VimuxOpenRunner()<CR>
    nnoremap <Leader>tl :VimuxRunLastCommand<CR>
    nnoremap <Leader>tr ::call VimuxRunCommand("yr run && cat output/pipePFn.d.ts")<CR>
  " }}}

  " tmux status line
  autocmd VimEnter * silent! !tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf
  autocmd VimLeave * silent! !tmux source ~/.dotfiles/tmux/themes/dracula_tmuxline_new.conf

  " autocmd VimEnter * silent! !tmux source ~/.dotfiles/tmux/themes/tmux-gruvbox-dark.conf
  " autocmd VimLeave * silent! !tmux source ~/.dotfiles/tmux/themes/tmux-gruvbox-dark.conf

  " autocmd VimEnter * silent! !tmux source ~/.dotfiles/tmux/themes/iceberg_tmuxline.conf
  " autocmd VimLeave * silent! !tmux source ~/.dotfiles/tmux/themes/iceberg_tmuxline.conf

  call dein#add('edkolev/tmuxline.vim') " {{{
    let g:tmuxline_theme = 'dracula'
    " let g:tmuxline_theme = 'gruvbox'
    " let g:tmuxline_theme = 'iceberg'
    let g:tmuxline_preset = 'minimal'
  " }}}
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('editorconfig/editorconfig-vim', {'on_i':1})
call dein#add('tpope/vim-endwise')

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function s:on_tpope_vim_speeddating_source()
  nmap  <C-A-X>   <Plug>SpeedDatingUp
  nmap  <C-X>     <Plug>SpeedDatingDown
endfunction
let g:speeddating_no_mappings=1
call dein#add('tpope/vim-speeddating', {'hook_post_source': function('s:on_tpope_vim_speeddating_source')})

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call dein#add('thinca/vim-visualstar')

function s:on_commentary_source()
  xmap # gc
  omap # gc
  nmap # gcc
endfunction
call dein#add('tpope/vim-commentary', {'hook_post_source': function('s:on_commentary_source')})

call dein#add('terryma/vim-expand-region') " mapping - + and _
call dein#add('chrisbra/NrrwRgn') " mapping - ,nr
call dein#add('jiangmiao/auto-pairs') "{{{
  let g:AutoPairsShortcutToggle = ''
  let g:AutoPairsMapCh = 0 " I use `move to left pane` here
  let g:AutoPairsFlyMode = 0
  let g:AutoPairsShortcutBackInsert = ''
  let g:AutoPairsMultilineClose = 0
"}}}
call dein#add('justinmk/vim-sneak') "{{{
  let g:sneak#streak = 1
"}}}
call dein#add('tommcdo/vim-exchange')
call dein#add('junegunn/vim-easy-align') " {{{
  xmap ga <Plug>(EasyAlign)
  nmap ga <Plug>(EasyAlign)
" }}}
call dein#add('bkad/CamelCaseMotion') " {{{
  map <silent> w <Plug>CamelCaseMotion_w
  map <silent> b <Plug>CamelCaseMotion_b
  map <silent> e <Plug>CamelCaseMotion_e
  map <silent> ge <Plug>CamelCaseMotion_ge
  sunmap w
  sunmap b
  sunmap e
  sunmap ge
" }}}
call dein#add('jeetsukumaran/vim-indentwise')
call dein#add('AndrewRadev/splitjoin.vim') " {{{
  let g:splitjoin_ruby_hanging_args=0
" }}}
" mapping - gJ, gS
call dein#add('tpope/vim-abolish') " {{{
  " abolish current highlightment
  nnoremap <leader>a "+y//e<CR>:%Subvert:::g<left><left><left><C-r>+<right>
  nnoremap <leader>A :%Subvert:::g<left><left><left>
  vmap     <leader>A :Subvert:::g<left><left><left>
" }}}

call dein#add('itchyny/vim-cursorword') " underline words under cursor
call dein#add('itchyny/calendar.vim')
call dein#add('AndrewRadev/switch.vim') " mapping - gs
call dein#add('romgrk/replace.vim') " {{{
  let g:replace_register = '_'
  nmap R "+<Plug>ReplaceOperator
  vmap R "+<Plug>ReplaceOperator

  nmap X "+<Plug>ExchangeOperator
  nmap RR cc<C-R>+<esc>
" }}}

call dein#add('AndrewRadev/deleft.vim')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Navigation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('dkprice/vim-easygrep') "{{{
  let g:EasyGrepRecursive=1
  let g:EasyGrepAllOptionsInExplorer=1
  let g:EasyGrepCommand=1
  let g:EasyGrepFilesToExclude=".svn,.git,node_modules"
  let g:EasyGrepWindow=0 " Specifies the window to use for matches.  0 - quickfix 1 - location list
  nnoremap <leader>vo :GrepOptions<cr>
  nnoremap <Space>g :Grep<Space>
  nnoremap <Space>r :Replace<Space>
"}}}
call dein#add('mbbill/undotree', {'on_cmd':'UndotreeToggle'}) "{{{
  let g:undotree_SplitLocation='botright'
  let g:undotree_SetFocusWhenToggle=1
  nnoremap <silent> <F1> :UndotreeToggle<CR>
"}}}
call dein#add('scrooloose/nerdtree', {'on_cmd':['NERDTreeToggle','NERDTreeFind']}) "{{{
  let g:NERDTreeLimitedSyntax = 1
  let g:NERDTreeHighlightCursorline = 0
  let NERDTreeShowHidden=1
  let NERDTreeQuitOnOpen=0
  let NERDTreeShowLineNumbers=1
  let NERDTreeChDirMode=0
  let NERDTreeShowBookmarks=1
  let NERDTreeIgnore=['\.git$','\.hg$','\node_modules$','\.pyc$', '^__generated__$','\.agdai$','\.agda\.vim$']
  let NERDTreeBookmarksFile=s:get_cache_dir('NERDTreeBookmarks')

  " disable f and F in privilege of find commands
  let g:NERDTreeMapOpenVSplit='V'
  let g:NERDTreeMapToggleFiles=''
  let g:NERDTreeMapToggleFilters=''
  let g:NERDTreeMapHelp='<M-/>'

  let g:NERDTreeMapQuit='Q'
  nnoremap <F2> :NERDTreeToggle<CR>
  nnoremap <F3> :NERDTreeFind<CR>
"}}}

call dein#add('kshenoy/vim-signature')
call dein#add('myusuf3/numbers.vim') " {{{
  nnoremap <silent> <F7> :NumbersToggle<cr>
" }}}

function s:on_cleverf_source()
  " kakoune like find
  nmap <M-.> <Plug>(clever-f-repeat-forward)
  xmap <M-.> <Plug>(clever-f-repeat-forward)
  omap <M-.> <Plug>(clever-f-repeat-forward)
  nmap <M->> <Plug>(clever-f-repeat-back)
  xmap <M->> <Plug>(clever-f-repeat-back)
  omap <M->> <Plug>(clever-f-repeat-back)
endfunction
call dein#add('rhysd/clever-f.vim', {'hook_post_source': function('s:on_cleverf_source')})
let g:clever_f_timeout_ms = 1 " make clever_f unclever

call dein#add('mhinz/vim-sayonara') " {{{
  let g:sayonara_confirm_quit = 1

  nnoremap Q :Sayonara<cr>
  nnoremap <M-q> :Sayonara!<cr>

  nnoremap <leader>q :xa<cr>
  nnoremap <leader>z :qa!<cr>
" }}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Unite
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call dein#add('ctrlpvim/ctrlp.vim')
let g:ctrlp_map = '<Space><Space>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }

let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Textobj
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('kana/vim-textobj-user')
call dein#add('kana/vim-textobj-indent')
call dein#add('kana/vim-textobj-entire')
call dein#add('lucapette/vim-textobj-underscore')
call dein#add('beloglazov/vim-textobj-quotes')
call dein#add('kana/vim-textobj-line')
call dein#add('jasonlong/vim-textobj-css')
call dein#add('b4winckler/vim-angry')
call dein#add('saihoooooooo/vim-textobj-space')

" file text object
call textobj#user#plugin('file', {
  \ 'file': {
  \ 'pattern': '\f\+', 'select': ['af', 'if']
  \ }
  \ })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Web
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('groenewege/vim-less', {'on_ft':['less']})
call dein#add('cakebaker/scss-syntax.vim', {'on_ft':['scss','sass']})
call dein#add('hail2u/vim-css3-syntax', {'on_ft':['css','scss','sass']})
call dein#add('othree/html5.vim', {'on_ft':['html','typescript','javascript']})
call dein#add('digitaltoad/vim-pug', {'on_ft':['pug', 'vue']})
call dein#add('mustache/vim-mustache-handlebars', {'on_ft':['mustache','handlebars']})
call dein#add('Valloric/MatchTagAlways')
call dein#add('slim-template/vim-slim', {'on_ft':['slim']})
call dein#add('mattn/emmet-vim', {'on_ft':['html','vue','xml','xsl','xslt','xsd','css','sass','scss','less','mustache','handlebars','ts','javascript','jsx','typescript','eruby']})
let g:user_emmet_leader_key=','

autocmd FileType html,vue,xml,xsl,xslt,xsd,css,sass,scss,less,mustache,handlebars,ts,javascript,jsx,typescript,eruby imap <buffer><c-y><c-y> <c-y>,
autocmd FileType html,vue,xml,xsl,xslt,xsd,css,sass,scss,less,mustache,handlebars,ts,javascript,jsx,typescript,eruby vmap <buffer><c-y><c-y> <c-y>,

" TextField to <TextField />
autocmd FileType html,vue,xml,xsl,xslt,xsd,css,sass,scss,less,mustache,handlebars,ts,javascript,jsx,typescript,eruby imap <buffer><c-y>y <esc>ysiw>f>i<space>/<c-o>h

" Attribute deletion
autocmd FileType html,vue,xml,xsl,xslt,xsd,css,sass,scss,less,mustache,handlebars,ts,javascript,jsx,typescript,eruby nm dA lF d2f"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Javascript
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('kchmck/vim-coffee-script', {'on_ft':['coffee']})
call dein#add('leshill/vim-json', {'on_ft':['json']})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Ruby
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('tpope/vim-rails', {'on_ft':['ruby']})
call dein#add('vim-ruby/vim-ruby', {'on_ft':['ruby']})
call dein#add('rhysd/vim-textobj-ruby', {'on_ft':['ruby']})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Purescript
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('purescript-contrib/purescript-vim', { 'on_ft':['purescript'] })
call dein#add('srghma/vim-purs-module-name', { 'on_ft':['purescript'] })

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call dein#add('aklt/plantuml-syntax',         {'on_ft':['plantuml']})
call dein#add('jparise/vim-graphql',          {'on_ft':['graphql']})
call dein#add('tpope/vim-scriptease',         {'on_ft':['vim']})
call dein#add('plasticboy/vim-markdown',      {'on_ft':['markdown']})
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_fenced_languages = ['csharp=cs', 'c++=cpp', 'viml=vim', 'bash=sh', 'ini=dosini', 'purs=purescript']
call dein#add('PotatoesMaster/i3-vim-syntax', {'on_ft':['i3']})
call dein#add('chr4/nginx.vim',               {'on_ft':['nginx']})
call dein#add('vim-scripts/vim-terraform',    {'on_ft':['terraform']})
call dein#add('LnL7/vim-nix',                 {'on_ft':['nix']})
call dein#add('derekelkins/agda-vim',         {'on_ft':['agda']})
call dein#add('vmchale/dhall-vim',            {'on_ft':['dhall']})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <M-8> #

nnoremap <leader>w :w<cr>
nnoremap <leader>tag :!ctags -R .<cr>

" toggle paste
nnoremap <F6> :set invpaste<CR>:set paste?<CR>

" remap arrow keys
nnoremap <left> :bprev<CR>
nnoremap <right> :bnext<CR>
nnoremap <up> :tabnext<CR>
nnoremap <down> :tabprev<CR>

" unimpaired tabs
nnoremap ]w :tabnext<CR>
nnoremap [w :tabprev<CR>

" quick resizing
nnoremap <M-h> <C-w>3<
nnoremap <M-l> <C-w>3>
nnoremap <M-j> <C-w>3-
nnoremap <M-k> <C-w>3+

" change cursor position in command mode
cnoremap <M-h> <left>
cnoremap <M-l> <right>
cnoremap <M-j> <down>
cnoremap <M-k> <up>

" will be rewritten if tmux run
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" kakoune like movements
noremap gh 0
noremap gi ^
noremap gl g_
noremap gj G
noremap gk gg

inoremap <C-r> <C-r><C-p>
inoremap <M-p> <C-r><C-p>+
cnoremap <M-p> <C-r>+

nnoremap p "+p
vnoremap p "+p
nnoremap <M-p> p
vnoremap <M-p> p

nnoremap P "+P
vnoremap P "+P
nnoremap <M-P> P
vnoremap <M-P> P

nnoremap y "+y
vnoremap y "+y
nnoremap <M-y> y
vnoremap <M-y> y

nnoremap Y "+y$
nnoremap <M-Y> y$
vnoremap <M-Y> y$

nnoremap ,d "+d
vnoremap ,d "+d
nnoremap ,D "+D
vnoremap ,D "+D

" deleting
inoremap <C-u> <C-g>u<C-u>
inoremap <C-d> <Del>

" sane regex
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
" nnoremap :s/ :s/\v

" quick substitute
nnoremap dm :%s:::g<left><left><left>
vnoremap dm :s:::g<left><left><left>

" command-line window
nnoremap q: q:i
nnoremap q/ q/i
nnoremap q? q?i

" folds
nnoremap zr zr:echo &foldlevel<cr>
nnoremap zm zm:echo &foldlevel<cr>
nnoremap zR zR:echo &foldlevel<cr>
nnoremap zM zM:echo &foldlevel<cr>

" screen line scroll
nnoremap <expr> j v:count > 1 ? "j" : "gj"
nnoremap <expr> k v:count > 1 ? "k" : "gk"

" auto center
nnoremap <silent> <C-o> <C-o>zz
nnoremap <silent> <C-i> <C-i>zz

" reselect visual block after indent
vnoremap < <gv
vnoremap > >gv

" reselect last paste
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" shortcuts for windows
nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s
nnoremap <leader>vsa :vert sba<cr>

" tab shortcuts
nnoremap <leader>tn :tab spl<CR>
nnoremap <leader>tc :tabclose<CR>

" quick buffer open
nnoremap gb :ls<cr>:e #

" general
nnoremap <leader>l :set list! list?<cr>
nnoremap <bs> :noh<cr>
nnoremap <M-v> vg_

nnoremap <C-s> <C-a>
nnoremap <leader>R :so $MYVIMRC<CR>

" in nvim terminal emulator
tnoremap <C-\><C-\> <C-\><C-n>
tnoremap <left> <C-\><C-n>:bprev<CR>
tnoremap <right> <C-\><C-n>:bnext<CR>
tnoremap <up> <C-\><C-n>:tabnext<CR>
tnoremap <down> <C-\><C-n>:tabprev<CR>

"Ctrl+Shift+up move line above"
"Ctrl+Shift+down move line below
nnoremap <C-S-Down> :m+<CR>==
nnoremap <C-S-Up> :m-2<CR>==
inoremap <C-S-Down> <Esc>:m+<CR>==gi
inoremap <C-S-Up> <Esc>:m-2<CR>==gi
vnoremap <C-S-Down> :m'>+<CR>gv=gv
vnoremap <C-S-Up> :m-2<CR>gv=gv

" J and K like in nerdtree
map K <Plug>(IndentWiseBlockScopeBoundaryBegin)
map J <Plug>(IndentWiseBlockScopeBoundaryEnd)

nnoremap <M-i> J

function! RemoveNonascii() abort
  exe "normal! :s:\ \|(\|)\|\.::g"
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Finish
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call dein#add('dracula/vim', { 'name': 'dracula' }) "{{{
  let g:dracula_colorterm = 1
  let g:dracula_italic = 1
  if (has("termguicolors"))
    set termguicolors
  endif
"}}}
call dein#add('morhetz/gruvbox') "{{{
  let g:gruvbox_contrast_dark = 'hard'
"}}}
call dein#add('nanotech/jellybeans.vim')
call dein#add('ryanoasis/vim-devicons')
call dein#add('catppuccin/nvim', { 'name': 'catppuccin' })

" =====================================================================
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' }) "{{{
  let g:coc_global_extensions = [
        \'coc-snippets',
        \'coc-json',
        \'coc-html',
        \'coc-eslint',
        \'coc-yaml',
        \'coc-tsserver',
        \'coc-solargraph',
        \'coc-jedi',
        \'coc-htmldjango',
        \'coc-docker',
        \'coc-css',
        \'@yaegassy/coc-tailwindcss3'
  \]

  set hidden
  set nobackup
  set nowritebackup
  set cmdheight=2
  set updatetime=300
  set shortmess+=c
  set signcolumn=number

  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1) :
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  imap <C-l> <Plug>(coc-snippets-expand)
  vmap <C-j> <Plug>(coc-snippets-select)
  let g:coc_snippet_next = '<c-j>'
  let g:coc_snippet_prev = '<c-k>'
  imap <C-j> <Plug>(coc-snippets-expand-jump)
  xmap <leader>x  <Plug>(coc-convert-snippet)

  autocmd CursorHold * silent call CocActionAsync('highlight')

  augroup mygroup
    autocmd!
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end
" }}}

call dein#add('nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'})
call dein#add('nvim-treesitter/playground')

" =====================================================================

call dein#end()

if dein#check_install()
  call dein#install()
endif

call coc#config('snippets.extends', { 'cpp' : ['c'], 'javascriptreact' : ['javascript'], 'typescript' : ['javascript'], 'ruby' : ['rails'] })

autocmd VimEnter * call dein#call_hook('post_source')

lua << EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = {
      "c",
      "lua",
      "vim",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "haskell",
      "cpp",
      "ruby"
    },
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    playground = {
      enable = true,
    }
  }
EOF

filetype plugin indent on
syntax enable

set background=dark   " Setting dark mode
" set background=light   " Setting light mode


colorscheme dracula
" colorscheme catppuccin
" colorscheme jellybeans
" colorscheme gruvbox
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocommands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" go back to previous position of cursor if any
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \  exe 'normal! g`"zvzz' |
  \ endif

" autosave
autocmd FocusLost * silent! wall
set autowriteall
autocmd BufRead,BufNewFile *.conf setf dosini

autocmd FileType css,scss setlocal foldmethod=marker foldmarker={,}
autocmd FileType python setlocal foldmethod=indent
autocmd FileType markdown setlocal nolist
autocmd FileType yaml,eruby.yaml setlocal tabstop=2 shiftwidth=2 commentstring=#\ %s
autocmd FileType agda setlocal commentstring=--\ %s
autocmd FileType purescript setlocal iskeyword+=- commentstring=--\ \|\ %s
autocmd FileType zsh setlocal iskeyword+=-
autocmd FileType typescript setlocal tabstop=2 shiftwidth=2 expandtab

" force filetype on odd extension
autocmd BufRead,BufNewFile Dockerfile.template set filetype=dockerfile
autocmd BufRead,BufNewFile *.js.erb set filetype=javascript
autocmd BufRead,BufNewFile *.mjml set filetype=slim
autocmd BufRead,BufNewFile *.purs set filetype=purescript
autocmd BufRead,BufNewFile *.dhall set filetype=dhall
autocmd BufRead,BufNewFile *.slim set filetype=slim
autocmd BufRead,BufNewFile Vagrantfile,Guardfile set filetype=ruby
autocmd BufRead,BufNewFile emacs,spaceemacs set filetype=lisp
autocmd BufRead,BufNewFile *.axlsx set filetype=ruby
autocmd BufRead,BufNewFile *.agda setf agda

" autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 expandtab
" autocmd FileType html,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=0 copyindent preserveindent noexpandtab

" nmap g[ 0ciw1<ESC>
" nmap g] 0kyiwjciw<M-p><ESC>
