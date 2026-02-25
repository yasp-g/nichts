return {
    -- Catppuccin Theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavor = "mocha"
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- VimBeGood Game
    {
        "ThePrimeagen/vim-be-good"
    },
    
    -- Yazi file manager integration
    {
        "DreamMaoMao/yazi.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- optional
        },
        opts = {
            -- Yazi window position
            win_position = "right", -- "bottom" or "right"

            -- Size of Yazi window
            win_size = function(self)
                local win_id = vim.fn.win_getid()
                local width = vim.fn.winwidth(win_id)
                local height = vim.fn.winheight(win_id)
                if self.win_position == "bottom" then
                    return height * 0.4
                else
                    return width * 0.4
                end
            end,

            -- Set keymap
            keymap = {
                -- key = 'value' will add 'value' to default keymaps
                -- key = {'+', 'value'} will add 'value' to default keymaps
                -- key = {'-'} will remove default keymap
                -- key = {'~', 'value'} will replace default keymap with 'value'
                -- yazi = {'-'}, -- remove default keymap '<leader>e'
            },
        },
        keys = {
            { "<leader>y", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
        },
    },

    -- nvim-tree (file explorer)
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("nvim-tree").setup({
                sort = {
                    sorter = "case_sensitive",
                },
                view = {
                    width = 30,
                },
                update_focused_file = {
                    enable = true,
                },
                renderer = {
                    group_empty = true,
                },
                filters = {
                    dotfiles = false, -- show dotfiles
                },
            })
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
        end,
    },

    -- Telescope (fuzzy finder)
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
            vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        end,
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = { enable = true },
                ensure_installed = {
                    "lua", "vim", "vimdoc",
                    "cpp",
                    "python",
                    "javascript", "typescript", "tsx",
                    "terraform", "hcl"
                },
                auto_install = true,
                sync_install = false,
            })
        end,
    },

    -- Lualine (status line)
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = { left = '', right = '' },
                },
            })
        end,
    },

    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require('lspconfig')
            lspconfig.pyright.setup{}
            lspconfig.ts_ls.setup{}

            -- C++ configuration
            lspconfig.clangd.setup{
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = function(fname)
                    return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or vim.fn.getcwd()
                end,
            }

            -- Global mappings.
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                end,
            })
        end,
    },

    -- nvim-cmp (autocompletion)
  {
      'hrsh7th/nvim-cmp',
      dependencies = {
          'hrsh7th/cmp-nvim-lsp',
          'hrsh7th/cmp-buffer',
          'hrsh7th/cmp-path',
          'hrsh7th/cmp-cmdline',
          'L3MON4D3/LuaSnip',
          'saadparwaiz1/cmp_luasnip',
      },
      config = function()
          local cmp = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
              snippet = {
                  expand = function(args)
                      luasnip.lsp_expand(args.body)
                  end,
              },
              mapping = cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),
              sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
              }, {
                  { name = 'buffer' },
              })
          })
      end,
  },
}
