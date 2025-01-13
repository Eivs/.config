" -- General -- "
set nocompatible                " 使用 VIM 键盘模式 "
set history=2000                " 记录 Vim 历史操作的条数 "

set tm=500                      " 设置超时时间 "
set t_Co=256                    " 使用 256 色模式 "

filetype on                     " 开启文件类型检测 "
filetype plugin on              " 开启插件的支持 "
filetype indent on              " 开启文件类型相应的缩进规则 "

" -- Encoding -- "
set encoding=utf-8              " 打开文件时编码格式 "
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1   " vim会根据该设置识别文件编码 "

set fileformat=unix             " 设置以unix的格式保存文件 "
set fileencoding=utf-8          " 在保存文件时，指定编码 "
set termencoding=utf-8          " 终端环境告诉vim使用编码 "
set ffs=unix,dos,mac            " 在创建文件或写入时，这三种文件格式分别决定了行末要添加什么特殊字符，而在读入文件时，又分别决定了要从行末移去什么特殊字符。 "
set formatoptions+=m            " 允许自动将多段落的注释格式化为一个段落 "
set formatoptions+=B            " 不要自动格式化只包含单个标点符号的段落 "

" -- Theme -- "
set background=dark             " 配色主题的色系,注意，这不是什么背景色！dark 是暗色系，light 是亮色系。 "
colorscheme snazzy              " 配色主题的名称,:coloscheme 后键入<tab>可以自动补全 比较喜欢的desert,peachpuff,torte,elfload,slate "

" -- Show -- "
syntax on                       " 开启语法高亮 "
set number                      " 显示行号 "
set ruler                       " 显示当前光标行号和列 "
set wrap                        " 设置折行 set nowrap 为不折行 "
set sidescroll=1                " 默认设置set sidescroll=0 之下，当光标到达屏幕边缘时，将自动扩展显示1/2屏幕的文本。通过使用 set sidescroll=1 设置，可以实现更加平滑的逐个字符扩展显示 "
set showcmd                     " 在屏幕右下角显示未完成的命令 "
set showmode                    " 显示当前vim模式 "
set showmatch                   " 显示匹配的括号 "
set matchtime=1                 " 设置showmatch的效果时间，默认500ms，现在是100ms "
set cursorline                  " 突出显示当前行 "
" set cursorcolumn              " 突出显示当前列 "
" set colorcolumn=80              " 设置某一列高亮 "
set list listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:

" -- Search -- "
set smartcase                   " 搜索时，如果输入大写，则严格按照大小写搜索，如果小写，并设置了ignorecase，则忽略大小写 "
set ignorecase                  " 搜索时忽略大小写 "
set incsearch                   " 搜索时及时匹配搜索内容，需要回车确认 "
set hlsearch                    " 高亮搜索项 "

" -- Tab -- "
set expandtab                   " 将<tab>符号转变为<space>空格 "
set smarttab                    " 配合shiftwidth使用，如果设置该值，在行首键入<tab>会填充shiftwidth的数值,其他地方使用tabstop的数值，不设置的话，所有地方都是用shiftwidth数值 "

" -- Indent -- "
set autoindent                  " 换行自动缩进 "
set smartindent                 " 缩进采用c语言风格 "
set shiftround                  " 在一般模式下键入>>整个缩进shiftwidth的长度，<<反向操作,== 可以与上一行对齐，插入模式下C-T和C-D也可以左右启动 "
set shiftwidth=4                " 缩进的空格数 "
set tabstop=4                   " 键入<tab>的步长 "
set softtabstop=4               " insert mode tab and backspace use 4 spaces "

" -- Set Mark Column Color -- "
hi! link SignColumn   LineNr
hi! link ShowMarksHLl DiffAdd
hi! link ShowMarksHLu DiffChange

" -- Status Line -- "
set statusline=%<%f\ %h%m%r%=%k[%{(&fenc==\"\")?&enc:&fenc}%{(&bomb?\",BOM\":\"\")}]\ %-14.(%l,%c%V%)\ %P
set laststatus=2                " 底部显示两行状态栏 "


" -- Select & Complete -- "
set selection=inclusive         " 选择文本事，光标所在位置也会被选中 "
set selectmode=mouse,key

set scrolloff=5                 " 距离顶部和底部5行 "
set backspace=2                 " 任何情况允许使用退格键删除 "
set mouse=a                     " 启用鼠标 "

" -- Code Folding -- "
set foldlevelstart=99           " 默认不折叠 "
set foldmethod=indent           " 按照缩紧折叠 "

let g:lightline = {
    \ 'colorscheme': 'snazzy'
    \ }
