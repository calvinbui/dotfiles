-- onedark (theme)
vim.pack.add({ 'https://github.com/joshdick/onedark.vim' })
vim.o.termguicolors = true
vim.cmd.colorscheme('onedark')

-- gitsigns (change markers in the gutter)
vim.pack.add({ 'https://github.com/lewis6991/gitsigns.nvim' })

-- lualine (status line)
vim.pack.add({
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim'
})
require('lualine').setup({ options = { theme = 'onedark' } })

-- indent guides
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', space = '·', leadmultispace = '│ ' }

-- line numbers
vim.o.number = true

-- keep 5 lines of context around the cursor
vim.o.scrolloff = 5
