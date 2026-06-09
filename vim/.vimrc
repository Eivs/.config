" ==================== 基础设置 ====================
" 关闭 Vi 兼容模式，让 Vim 使用完整功能
set nocompatible

" 编码设置（推荐 UTF-8）
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set fileencoding=utf-8
set termencoding=utf-8
set fileformat=unix

" 启用真彩色支持（Ghostty 等现代终端强烈推荐）
set termguicolors
set t_Co=256

" 启用文件类型检测、插件和缩进
filetype plugin indent on
" 开启语法高亮
syntax on

" ==================== 常规行为 ====================
" 历史记录条数
set history=2000
" 等待按键时间（影响映射延迟）
set updatetime=500
" 光标上下保留的最少行数
set scrolloff=5
" 允许 Backspace 删除缩进、行首、行尾内容
set backspace=2

" 鼠标支持：normal + visual 模式下可用
" 这是鼠标选择文本的关键设置
set mouse=nv

" 选择时包含光标下的字符（更符合直觉）
set selection=inclusive
" 进入选择模式
" set selectmode=mouse,key

" 剪贴板设置：使用系统剪贴板（macOS 下强烈推荐）
" unnamedplus 表示 + 寄存器（系统剪贴板）
set clipboard=unnamedplus

" ==================== 显示与搜索 ====================
" 显示行号 + 相对行号
set number relativenumber
" 高亮当前行
set cursorline
" 自动换行
set wrap
" 水平滚动时一次滚动的字符数
set sidescroll=1

" 右下角显示当前命令
set showcmd
" 显示当前模式（插入/可视等）
set showmode
" 高亮匹配的括号
set showmatch
set matchtime=1

" 显示标尺（右下角显示行列信息）
set ruler
" 始终显示状态栏
set laststatus=2

" 搜索设置
set incsearch       " 实时搜索
set hlsearch        " 高亮搜索结果
set ignorecase      " 忽略大小写
set smartcase       " 智能大小写（有大写字母时区分大小写）

" 双击 Esc 取消搜索高亮
nnoremap <Esc><Esc> :nohlsearch<CR>

" ==================== 缩进与 Tab ====================
" 使用空格代替 Tab
set expandtab
set smarttab

" 缩进宽度设置（4 个空格）
set shiftwidth=4
set tabstop=4
set softtabstop=4

" 自动缩进和智能缩进
set autoindent
set smartindent
" 缩进取整（例如 >> 时对齐到 shiftwidth）
set shiftround

" ==================== 主题 ====================
set background=dark
colorscheme snazzy

" ==================== 其他增强功能 ====================
" 代码折叠（按缩进折叠）
set foldmethod=indent
" 默认不折叠（99 层）
set foldlevelstart=99

" 撤销记录持久化
set undofile
set undodir=~/.vim/undo

" 关闭备份和交换文件
set nobackup
set nowritebackup
set noswapfile
" set directory=~/.vim/swap//

" Netrw（内置文件浏览器）设置
let g:netrw_liststyle = 3      " 使用树状目录视图
let g:netrw_browse_split = 4   " 在上一个窗口打开文件
let g:netrw_winsize = 20       " 宽度为 20%

" ==================== 快捷键 ====================
" 快速保存
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" 快速退出
nnoremap <C-q> :q<CR>

" Alt + j/k 移动当前行（或选中的行）
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" ==================== 鼠标选择优化 ====================
" 鼠标左键松开时，自动把选中的内容复制到系统剪贴板
vnoremap <LeftRelease> "+ygv
nnoremap <LeftRelease> "+y

" ==================== y 操作始终使用系统剪贴板（推荐） ====================
" 让普通的 y（复制）、yy、Y 等操作都直接进入系统剪贴板
nnoremap y "+y
xnoremap y "+y
vnoremap y "+y
nnoremap yy "+yy
nnoremap Y "+y$

" ==================== Lightline 状态栏 ====================
let g:lightline = {
    \ 'colorscheme': 'snazzy'
    \ }
