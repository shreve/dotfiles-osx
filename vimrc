let &rtp = printf('%s/dotfiles/vim,%s,%s/dotfiles/vim/after', $HOME, $VIMRUNTIME, $HOME) " include $DOTPATH

call pathogen#infect() " Shout out to Tpope!

let mapleader="," " <Leader> = ,

" Theming and shit like that
syntax on
filetype plugin indent on
colorscheme Tomorrow-Night-Bright

set nocompatible " stop behaving in a Vi-compatible way
set autoindent " keep indentation on a new line
set autoread " if a file updates, read it
set backspace=indent,eol,start " allow backspacing over everything in insert mode (:h fixdel if issues)
set backupdir=$DOTPATH/vim/tmp
set cryptmethod=blowfish " use blowfish to encrypt a file
set directory=$DOTPATH/vim/tmp " keep temporary and backup files in ~/.vim
set gdefault " use the /g flag by default for :s
set history=1000 " remember 1000 lines of history
set ignorecase " by default ignore case in search
set laststatus=2 " always display status line
set list listchars=tab:»·,trail:· " display extra whitespace
set noexpandtab " explicitly disable space->tab conversion
set nowrap " don't linewrap, just continue past window
set number " precede each line with file line number (only current line with relativenumber)
set relativenumber " display line numbers in relation to current line
set ruler " show line and column number of cursor
set scrolloff=2 " 2 lines of padding when scrolling buffer
set showcmd " show command as it's being typed
set showmatch " breifly jump to matching bracket
set shiftround " >> << round to multiple of shiftwidth
set shiftwidth=4 " number of spaces to use for each indention step
set smartcase " when a capital letter is used, turn off ignorecase
set smartindent " indent properly in c-like languages
set softtabstop=0 " number of spaces Tab 'feels like'
set tabstop=4 " number of spaces Tab takes up
set timeoutlen=750 " change timeout
set wildmenu " turns on menu used for tab-completion
set wildmode=longest:full,full " complete longest common string, and activate wildmenu

" syntax highlighting for .html.erb
au BufNewFile,BufRead *.html.erb set filetype=eruby.html
au BufNewFile,BufRead *.coffee set filetype=javascript

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal wrap
au BufNewFile,BufRead *.txt setlocal lbr
au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" Remove trailing whitespace on save for certain file types.
au BufWritePre *.{erb,rb,sass,html,js} :%s/\s\+$//e

" override some weird sass behavior
au FileType sass setlocal shiftwidth=4 noexpandtab

let netrwhistpath="/Users/shreve/dotfiles/vim/.netrwhist"
au VimLeave * if filereadable(netrwhistpath) | call delete(netrwhistpath) | endif

" security measures when opening a file that has been VimCrypt'd
au BufReadPost * if &key != "" | set noswapfile nowritebackup viminfo= nobackup noshelltemp history=0 secure | endif

map <Leader>ac :Rcontroller application<cr>
map <Leader>al :Rlayout application<cr>
map <Leader>bc :silent ! open "http://basecamp.com/2257044/"<cr>:redraw!<cr>
map <Leader>c :Rcontroller 
map <Leader>ca :e config/application.rb<cr>
map <Leader>css :Rstylesheet 
map <Leader>e :e.<cr>
map <Leader>f :e test/factories/
map <Leader>h :Rhelper 
map <Leader>js :Rjavascript 
map <Leader>l :e app/views/layouts/
map <Leader>m :Rmodel 
map <Leader>pg :silent ! open /Applications/PG\ Commander.app<cr>
map <Leader>pr :silent ! touch tmp/restart.txt<cr>:redraw!<cr>
map <Leader>rc :silent ! rails c<cr><esc>:redraw!<cr>
map <Leader>rs :source ~/.vimrc<cr>
map <Leader>s :w<cr>
map <Leader>te :! time rake -rminitest/pride test<cr>
map <Leader>ut :Runittest 
map <Leader>v :Rview 

" insert erb tags rc <%= %>, re <% %>
nnoremap <Leader><, i<% %><c-o>h<c-o>h
nnoremap <Leader><. i<%= %><c-o>h<c-o>h

" toggle paste mode
nnoremap <Leader>p :set paste! list! number! relativenumber!<cr>

" Get off my lawn
noremap <Left> :echoe "Use h"<CR>
noremap <Right> :echoe "Use l"<CR>
noremap <Up> :echoe "Use k"<CR>
noremap <Down> :echoe "Use j"<CR>


" allow saving as sudo
" http://stackoverflow.com/a/7078429/1893290
cmap w!! w !sudo tee > /dev/null %

" Prevent 'no command' error with incorrect capitalization
command! Q q
command! W w

" edit ~/.vimrc files
command! Vimrc :e ~/.vimrc

" If the current buffer has never been saved, it will have no name,
" call the file browser to save it, otherwise just save it.
command! -nargs=0 -bar Update if &modified
	\|    if empty(bufname('%'))
	\|        browse confirm write
	\|    else
	\|        confirm write
	\|    endif
	\|endif
nnoremap <silent> <C-S> :<C-u>Update<CR>

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
	let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
	if l:tabstop > 0
		let &l:sts = l:tabstop
		let &l:ts = l:tabstop
		let &l:sw = l:tabstop
	endif
	call SummarizeTabs()
endfunction

function! SummarizeTabs()
	try
		echohl ModeMsg
		echon 'tabstop='.&l:ts
		echon ' shiftwidth='.&l:sw
		echon ' softtabstop='.&l:sts
		if &l:et
			echon ' expandtab'
		else
			echon ' noexpandtab'
		endif
	finally
		echohl None
	endtry
endfunction