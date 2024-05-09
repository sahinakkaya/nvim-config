return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      {
        "zbirenbaum/copilot-cmp",
        config = function ()
          require("copilot_cmp").setup()
        end
      },
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end
      },
      -- "dmitmel/cmp-cmdline-history",
      -- "rcarriga/cmp-dap",
      -- "zbirenbaum/copilot-cmp",
      "petertriho/cmp-git",
    },
    config = function()

      local cmp = require('cmp')
      local luasnip = require("luasnip")
      -- local cmp_select = { behavior = cmp.SelectBehavior.Select }

      local icons = require('sahinakkaya.icons')


      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end


      -- local format = {
      --   fields = { "kind", "abbr", "menu" },
      --   format = function(_, vim_item)
      --     local kind = vim_item.kind
      --     local icon = (icons.kinds[kind] or ""):gsub("%s+", "")
      --     vim_item.kind = " " .. icon
      --     vim_item.menu = kind
      --     local text = vim_item.abbr
      --     local max = math.floor(math.max(vim.o.columns / 4, 50))
      --     if vim.fn.strcharlen(text) > max then
      --       vim_item.abbr = vim.fn.strcharpart(text, -1, max - 1)
      --         .. icons.misc.ellipse
      --     end
      --     return vim_item
      --   end,
      -- }

      -- local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          -- formatting = format,
          window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
          },
          mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.abort(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items
            ["<Tab>"] = cmp.mapping(function(fallback)

              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              elseif cmp.visible() then
                cmp.select_next_item()
              -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
              -- that way you will only jump inside the snippet region
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
            }),
          sources = cmp.config.sources({
            { name = "copilot", group_index = 2 },
            { name = 'nvim_lsp', max_item_count = 40 },
            { name = 'luasnip', max_item_count = 40 },
            { name = 'path'}
          }, 
          {
            { name = 'buffer' },
          })
        })

        -- Set configuration for specific filetype.
        cmp.setup.filetype('gitcommit', {
          sources = cmp.config.sources({
            { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
          }, {
            { name = 'buffer' },
          })
        })


      cmp.setup.filetype("harpoon", {
        sources = cmp.config.sources({
          { name = "path" },
        }),
        -- formatting = format,
      })

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ '/', '?' }, {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' }
          }, {
            { name = 'cmdline' }
          })
        })


        -- -- Set up lspconfig.
        -- local capabilities = require('cmp_nvim_lsp').default_capabilities()
        -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
        -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
        --   capabilities = capabilities
        -- }
    end,
  },
  
}
