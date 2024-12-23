" =============================================================================
" Filename: autoload/lightline/colorscheme/snazzy.vim
" Author: Eivs
" License: MIT License
" =============================================================================

" Common colors
let s:blue   = [ '#75c4f9', 75 ]
let s:green  = [ '#88f398', 76 ]
let s:cyan = [ '#aceafb', 176 ]
let s:magenta   = [ '#ed73bd', 168 ]
let s:red   = [ '#ec675d', 168 ]
let s:yellow = [ '#f4f8a7', 180 ]

let s:fg    = [ '#abb2bf', 145 ]
let s:bg    = [ '#282c34', 235 ]
let s:gray1 = [ '#5c6370', 241 ]
let s:gray2 = [ '#2c323d', 235 ]
let s:gray3 = [ '#3e4452', 240 ]

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}, 'command': {} }

let s:p.inactive.left   = [ [ s:gray1,  s:bg ], [ s:gray1, s:bg ] ]
let s:p.inactive.middle = [ [ s:gray1, s:gray2 ] ]
let s:p.inactive.right  = [ [ s:gray1, s:bg ] ]

" Common
let s:p.normal.left    = [ [ s:bg, s:green, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.normal.middle  = [ [ s:fg, s:gray2 ] ]
let s:p.normal.right   = [ [ s:bg, s:green, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.normal.error   = [ [ s:red, s:bg ] ]
let s:p.normal.warning = [ [ s:yellow, s:bg ] ]
let s:p.command.left = [ [ s:bg, s:cyan, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.command.right = [ [ s:bg, s:cyan, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.insert.right   = [ [ s:bg, s:blue, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.insert.left    = [ [ s:bg, s:blue, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.replace.right  = [ [ s:bg, s:magenta, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.replace.left   = [ [ s:bg, s:magenta, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.visual.right   = [ [ s:bg, s:cyan, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.visual.left    = [ [ s:bg, s:cyan, 'bold' ], [ s:fg, s:gray3 ] ]
let s:p.tabline.left   = [ [ s:fg, s:gray3 ] ]
let s:p.tabline.tabsel = [ [ s:bg, s:cyan, 'bold' ] ]
let s:p.tabline.middle = [ [ s:gray3, s:gray2 ] ]
let s:p.tabline.right  = copy(s:p.normal.right)

let g:lightline#colorscheme#snazzy#palette = lightline#colorscheme#flatten(s:p)
