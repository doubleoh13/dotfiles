vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

vim.g.node_host_prog = "/home/jrichhart/.nvm/versions/node/v22.14.0/bin/node"
vim.cmd("let $PATH = '/home/jrichhart/.nvm/versions/node/v22.14.0/bin:' . $PATH")

local opt = vim.opt

opt.relativenumber = true
opt.number = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.cursorline = true
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.scrolloff = 5
opt.sidescrolloff = 5

require("doubleoh13.keymaps")
require("doubleoh13.lazy")
