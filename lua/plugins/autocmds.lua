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
            end,
          },
        },

        -- personal settings
        line_number_settings = {
          {
            event = { "BufEnter", "FocusGained", "InsertLeave", "WinEnter", "CmdlineLeave" },
            desc = "Enable relative numbers in all modes but insert/command",
            callback = function() vim.opt.relativenumber = true end,
          },
          {
            event = { "BufLeave", "FocusLost", "InsertEnter", "WinLeave", "CmdlineEnter" },
            desc = "Enable relative line numbers in insert/command mode and redraw screen to apply",
            callback = function()
              vim.opt.relativenumber = false
              vim.cmd "redraw"
            end,
          },
        },
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
