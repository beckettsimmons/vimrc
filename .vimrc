"Adding some of my advanced edits.
set tm=255
"For quick esacping, deleting, opening, etc.
:imap jj <Esc>
:imap jk <BS>
:imap kk <Del>
:imap jjo <Esc>o
:imap jjO <Esc>O

"Normal Mode
:nmap j gj
:nmap k gk
"For navigating splits.
:nmap we <C-w>
:nmap wekk <C-w>k<C-w>k

syntax on
set number  "Show line numbers
set linebreak	"Break lines at word (requires Wrap lines)
set showbreak=+++   "Wrap-broken line prefix
set textwidth=100   "Line wrap (number of cols)
set showmatch	"Highlight matching brace
set visualbell	"Use visual bell (no beeping)

set hlsearch	"Highlight all search results
set smartcase	"Enable smart-case search
set ignorecase	"Always case-insensitive
set incsearch	"Searches for strings incrementally

set autoindent	"Auto-indent new lines
set shiftwidth=4    "Number of auto-indent spaces
set smartindent	"Enable smart-indent
set smarttab	"Enable smart-tabs
set softtabstop=4   "Number of spaces per Tab
set tabstop=4

" Advanced
set ruler   "Show row and column ruler information

set undolevels=1000 "Number of undo levels
set backspace=indent,eol,start	"Backspace behaviour

"Special characters for tabs and spaces
set list
set listchars=tab:\| ,trail:·,nbsp:>,extends:>,precedes:<,eol:¶


"Status line below!
set laststatus=2
set statusline=%t       "tail of the filename
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=%y      "filetype


"display a warning if trailing, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file


"This one is my edit for highlihgting the current line"
set cursorline
"hi CursorLine   cterm=NONE ctermbg=DarkYellow  guibg=DarkYellow
"nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>











"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HLL call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
	let targetWidth = a:width != '' ? a:width : 70
	if targetWidth > 0
		exec 'match Error /\%>' . (targetWidth) . 'v/'
	else
		echomsg "Usage: HighlightLongLines [natural number]"
	endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
	if !exists("b:warning")
	let tabs = search('^\t', 'nw') != 0
	"These flags now ignore block comments
	let spaceRegex = '^ [^*]'
	let spaces = search(spaceRegex, 'nw') != 0
	let spacesPos = searchpos('^ ', 'nw')

	let mixedRegex ='^\t* [^*]'
	let mixed = search(mixedRegex, 'nw') !=0
	let mixedPos = searchpos(mixedRegex, 'nw')
	let trailing = search(' $', 'nw') != 0
	let trailsPos = searchpos(' $', 'nw')
	let b:warning1=''
	let b:warning2=''
	let b:warning3=''

	if tabs && spaces
		let b:warning1 =  '[Incon Ind@'.spacesPos[0].']'
	endif
	if mixed "min() => lowest line number, else will jump with cursor
		let b:warning2='[Mixed Ind@'.mixedPos[0].']'
	endif
	if trailing
		let b:warning3 = '[Trail WS@'.trailsPos[0].']'
	endif
	endif
	return b:warning1 . b:warning2 . b:warning3
endfunction
