return {
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        -- first key is the augroup name
        terminal_settings = {
          -- the value is a list of autocommands to create
          {
            -- event is added here as a string or a list-like table of events
            event = "TermOpen",
            -- the rest of the autocmd options (:h nvim_create_autocmd)
            desc = "Disable line number/fold column/sign column for terminals",
            callback = function()
              vim.opt_local.number = false
              vim.opt_local.relativenumber = false
              vim.opt_local.foldcolumn = "0"
              vim.opt_local.signcolumn = "no"

              -- don't let toggleterm window be taken by buffer
              -- pcall(function() vim.cmd':PinBuftype' end)
              -- vim.opt_local.buftype = "nofile"
              -- vim.opt_local.filetype = "toggleterm"
            end,
          },
        },

        -- personal settings
        line_number_settings = {
          {
            event = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
            desc = "Enable relative numbers in all modes but insert/command",
            callback = function()
              if vim.bo.filetype ~= "neo-tree" and vim.bo.buftype ~= "terminal" and vim.bo.buftype ~= "nofile" then
                vim.opt.relativenumber = true
              end
            end,
          },
          {
            event = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
            desc = "Enable relative line numbers in insert/command mode and redraw screen to apply",
            callback = function()
              if vim.bo.filetype ~= "neo-tree" and vim.bo.buftype ~= "terminal" and vim.bo.buftype ~= "nofile" then
                vim.opt.relativenumber = false
                vim.cmd "redraw"
              end
            end,
          },
        },
        prevent_comment_extension = {
          {
            event = { "BufEnter" },
            desc = "prevents adding the comment prefix when pressing enter or o on a commented line",
            callback = function() vim.cmd "set formatoptions-=o" end,
          }
        },
        -- line_count_minimap_toggle = {
        --   {
        --     desc = "Refresh the minimap when crossing the relevant line number count",
        --     event = {"TextChanged", "TextChangedI", "BufEnter"},
        --     callback = function ()
        --       local THRESHOLD = 48
        --       local old_line_count = vim.g.linecount or 0
        --       local new_line_count = vim.api.nvim_buf_line_count(0)
        --       if old_line_count > THRESHOLD and new_line_count <= THRESHOLD then
        --         vim.cmd "Neominimap bufRefresh"
        --       elseif old_line_count <= THRESHOLD and new_line_count > THRESHOLD then
        --         vim.cmd "Neominimap bufRefresh"
        --       end
        --       vim.g.linecount = new_line_count
        --     end
        --   }
        -- }

        --[[
        horizontal_scroll = {
          {
            event = { "WinScrolled" },
            desc = "Disable horizontal scroll when the content does not exceed the window width",
            callback = function()
              if vim.fn.winwidth(0) > vim.fn.col "$" then vim.cmd "normal! zH" end
            end,
          },
        },
        ]]
        --
      },
    },
  },
}
