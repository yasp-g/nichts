-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable 24-bit colour
vim.opt.termguicolors = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader key before lazy setup
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup lazy.nvim
require("config.lazy")

-- Setup Neovim tree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local api = require("nvim-tree.api")
    api.tree.open()
    api.tree.find_file({ focus = true }) -- reveal the current file in the tree
    vim.cmd.wincmd('p') -- switch focus back to previous window (file buffer)
  end
})

vim.api.nvim_create_autocmd("BufEnter", { -- close nvim-tree if it's the last buffer
  nested = true,
  callback = function()
    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
      vim.cmd "quit"
    end
  end
})

-- Setup CppProject function
require('cpp_project')

-- Neovim settings
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.mouse = 'v'
vim.opt.hlsearch = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wildmode = 'longest,list'
vim.opt.colorcolumn = '88'
vim.cmd('filetype plugin indent on')
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
