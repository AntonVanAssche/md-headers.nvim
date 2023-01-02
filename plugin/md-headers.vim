if exists('g:loaded_header') | finish | endif

silent! autocmd BufWinEnter *.md command! -nargs=0 MarkdownHeaders lua require('md-headers').markdown_headers()

let g:loaded_header = 1
