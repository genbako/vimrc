"--------------------
" display
"--------------------
set columns=84  "起動時のウィンドウサイズ
set lines=50

winpos 0 0  "起動時のウィンドウ位置

set guifont=Monospace\ 10

colorscheme evening "色テーマ

set laststatus=2
set cmdheight=1
set showcmd
set title

set statusline=%<%f%m%r%h%w%y%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%4v,%l/%L%p%%[%{GetB()}]
"文字コード云々
function! GetB()
 let c = matchstr(getline('.'), '.', col('.') - 1)
 let c = iconv(c, &enc, &fenc)
 return String2Hex(c)
endfunction
" :help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
 let n = a:nr
 let r = ""
 while n
   let r = '0123456789ABCDEF'[n % 16] . r
   let n = n / 16
 endwhile
 return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
 let out = ''
 let ix = 0
 while ix < strlen(a:str)
   let out = out . Nr2Hex(char2nr(a:str[ix]))
   let ix = ix + 1
 endwhile
 return out
endfunc

"---------------------
" 文字コードの自動認識
"---------------------
if &encoding !=# 'utf-8'
 set encoding=japan
 set fileencoding=japan
endif
if has('iconv')
 let s:enc_euc = 'euc-jp'
 let s:enc_jis = 'iso-2022-jp'
 " iconvがeucJP-msに対応しているかをチェック
 if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
   let s:enc_euc = 'eucjp-ms'
   let s:enc_jis = 'iso-2022-jp-3'
 " iconvがJISX0213に対応しているかをチェック
 elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==#
"\xad\xc5\xad\xcb"
   let s:enc_euc = 'euc-jisx0213'
   let s:enc_jis = 'iso-2022-jp-3'
 endif
 " fileencodingsを構築
 if &encoding ==# 'utf-8'
   let s:fileencodings_default = &fileencodings
   let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
   let &fileencodings = &fileencodings .','. s:fileencodings_default
   unlet s:fileencodings_default
 else
   let &fileencodings = &fileencodings .','. s:enc_jis
   set fileencodings+=utf-8,ucs-2le,ucs-2
   if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
     set fileencodings+=cp932
     set fileencodings-=euc-jp
     set fileencodings-=euc-jisx0213
     set fileencodings-=eucjp-ms
     let &encoding = s:enc_euc
     let &fileencoding = s:enc_euc
   else
     let &fileencodings = &fileencodings .','. s:enc_euc
   endif
 endif
 " 定数を処分
 unlet s:enc_euc
 unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
 function! AU_ReCheck_FENC()
   if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
     let &fileencoding=&encoding
   endif
 endfunction
 autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
 set ambiwidth=double
endif
"--------------------
"auto indent
"--------------------
filetype on
filetype indent on
filetype plugin on
set cindent
set cinkeys=0{,0},<:>,0#,!<Tab>,!^F,<Return>,;,
set autoindent

" -------------------
" set color
" -------------------
syntax on

highlight LineNr ctermfg=darkyellow    " 行番号
highlight NonText ctermfg=darkgrey
highlight Folded ctermfg=blue
highlight SpecialKey cterm=underline ctermfg=darkgrey
"highlight SpecialKey ctermfg=grey " 特殊記号

"--------------------
" 全角スペースを視覚化
"--------------------
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=white
match ZenkakuSpace /　/

"--------------------
" タブ幅
"--------------------
set ts=4 sw=4 sts=4


" -------------------
" other
" -------------------
set nohlsearch
set autowrite
set scrolloff=5 " スクロール時の余白確保
set showmatch
set backup
set number "行番号をつける
set history=100
set list
set listchars=tab:\ \ ,extends:<,trail:\

set fileencoding=utf-8　　　　 "UTF8
