  "#####################################################"
"                  COLLJORI VIMRC FILE:
  "#####################################################"

" BASIC SETUP:
  "####################"

" Put plugins and dictionaries in this dir (also on Windows)
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" enter the current millenium
" don't try to be vi-compatible
set nocompatible

" enable hidden state for buffed filed, allow to switch from one file to
" another without mandatory writing
set hidden

" set scroll offset to always have some line available above the cursor
set scrolloff=10

" set the ruler (position of the cursor in the status line) to a more basic
" format (no byte count vs char number count)
set rulerformat=%l,%v

" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on

" set default clipboard to the system one
set clipboard^=unnamed,unnamedplus

" store buffer list in viminfo, so when accidentally :q buffer list will
" still be there at next start
set viminfo^=%

" do not wrap at the begining of the file while pressing n during search
set nowrapscan

" do not wrap if a line is too long to be displayed
set nowrap

" ask for confirmation to close file. This is usefull when closing multiple
" unsaved files, and that q! don't want to clsoe
set confirm

" following allow persistent undo across vim sesssion

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif

" when no wrap activated, and when reaching edge of screen, do not scroll by
" half a page, just one char
set sidescroll=1

" set tab size as four space
filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

" I'm sick of vimrc reload, just use F2
map <F2> :source $MYVIMRC <CR>


" FINDING FILES:
  "####################"
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

"Disable LogiPat, this allow to open netrw with just :E
let g:loaded_logipat = 1

" netrw without helping banner
let g:netrw_banner = 0
" netrw with tree-like view by default
let g:netrw_liststyle = 3

" automatically close netrw buffer after openning file
let g:netrw_fastbrowse = 0

" when pressing v in netwr, the open file will be on the left rather than
" right
" let g:netrw_altv=1
" set splitbelow
" set splitright
" I don't like it so much because it's quite a pain to handle split size

" NOW WE CAN
" - Hit tab to :find by partial match
" - Use * to make it fuzzy


" SEARCHING IN FILES:
  "####################"

" map vimgrep on F4, search for word under the cursor in all file recursively.
" Do not jump, just populate quickfix tab
" if file does not have extension, search in all file in current location
" (warning, this can be very long)
map <F4> :execute 'vimgrep /'.expand('<cword>').'/gj **/*'.(expand("%:e")=="" ? "" : ".".expand("%:e"))  <Bar> cw<CR>

" this is really ugly and all, but I have not find something cool to search in
" multiple path with vimgrep.. so switching context mate
map <F5> :cd /home/dev/ouroboros/css/ <CR>
map <F6> :cd /home/dev/ouroboros/swint/ <CR>
map <F7> :cd /home/dev/ouroboros/cs_common/ <CR>

" shortcut to un-hilighted the current text
" to delete if to much strange behavior
noremap <esc> :noh<return><esc>
" vim use esc internally, this is mandatory to remap it without too much issue
nnoremap <esc>^[ <esc>^[

" shortcut // to search for visually selected text
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

" shortcut to vimgrep on every file with a given extension
command -nargs=+ Vim :vimgrep // **/*.<args>

" Following vimgrep shortcut are just legacy, as superior one have been found
"
" these are just shorcut of the Vim command, I just keep them for posterity
" shortcut to vimgrep on every C source file
command Vimc vimgrep // **/*.h **/*.c

" shortcut to vimgrep on every ADA source file
command Vimada vimgrep // **/*.adb **/*.ads


" OTHER KEY REMAP AND SHORTCUT:
  "####################"

" CTRL-p will paste the last yank text
nnoremap <C-p> "0p
nnoremap <C-P> "0P

" build the css_gtw inside vim. Quickfix is filled with compilation error
command Buildrootfs make -C $CSS_ROOT/src/linux rfs_css_gtw

" binding to print buffer list and chose one in one command
nnoremap ²b :ls<cr>:b<space>

" create in the context of convergence, where every source should not be more
" than hundred char wide. 4 char added for line number and pane separator
nnoremap <C-w><space> :vertical resize 105<cr>

" Allow using the repeat operator with a visual selection (!)
" http://stackoverflow.com/a/8064607/127816
vnoremap . :normal .<CR>

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" better alternative of ctrl-w o, it did not close other pane, just
" minimize them (https://stackoverflow.com/a/26551079/9936783)
" Zoom / Restore window.
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-W>z :ZoomToggle<CR>

" when searching for stuff and press n, the next match will blink
" interting, but I don't know how to make this work
" https://www.youtube.com/watch?v=aHm36-na4-4
"function! HLNext (blinktime)
"    let [bufnum, lnum, col, off] = getpos('.')
"    let matchlen = strlen(matchstr,strpart(getline('.'),col-1),@/))
"    let taget_pat = '\c\%#'.@/
"    let blinks = 3
"    for n in range(1,blinks)
"        let red = matchadd('WhiteOnRed', target_pat, 101)
"        redraw
"        exec 'sleep' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
"        call matchdelete(red)
"        redraw
"        exec 'sleep' . float2nr(a:blinktime / (2*blinks) * 1000) . 'm'
"    endfor
"endfunction
"nnoremap n :call HLNext(1)<CR>

" FOR STYLE:
  "####################"
" color scheme
" colorscheme Monokai
" set background=light
" not to bad, but the background is little bit too bright
set background=dark
colorscheme solarized
highlight Normal ctermbg=Black
highlight Normal guibg=Black
"
" hilight all match of search
set hlsearch
" line number is display in relative to the current one. Current one are
" still absolute thanks to number
set number relativenumber


"hilight a right margin, 100 char because that what's used on convergence
"project
"set colorcolumn=100
"ok this is way less dependant on colorscheme of the virtual terminal (don't ask me)
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%131v')


" TRAILING SPACE:
  "####################"
    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }

autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif


" STATUS LINE:
  "####################"
" always show status line, even when only one file is open
set laststatus=2

" use of the powerline official status line
set rtp+=/opt/python2-venv/lib/python2.7/site-packages/powerline/bindings/vim


" ENVIRONMENT:
" ##################"
" some shit specific to the environment

" use to have bash env into vim env. This is experimental for me.
" this is usefull for make to have access to the full env even in vim.
set shell=bash\ -l

