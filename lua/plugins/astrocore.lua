-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `,h astrocore`

local function merge(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

local function formatDiagnostic(diagnostic)
  -- local cursorLine = vim.api.nvim_win_get_cursor(0)[1]
  -- if cursorLine >= diagnostic.lnum - 1 and cursorLine <= diagnostic.end_lnum + 1 then
  -- Diagnostic is in current line
  return diagnostic.message:sub(0, 64) .. (string.len(diagnostic.message) > 64 and "..." or "")
  -- end

  -- return diagnostic.message
end

-------------------------------------------------------- all modes --------------------------------------------------------
local sharedKeybinds = {
  ["<C-Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  ["<S-C-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
  ["<D-a>"] = { "ggVG", desc = "Select all" },
  ["<D-f>"] = { "/", desc = "Find in buffer" },
  ["<D-F>"] = { function() vim.cmd "Telescope live_grep" end, desc = "Find in files" },
  ["<D-p>"] = { function() vim.cmd "Telescope find_files" end, desc = "Find file" },
  ["<D-v>"] = {
    function()
      if vim.fn.mode() == "i" then
        vim.api.nvim_input "<C-r>+"
      else
        vim.cmd 'normal! "+p'
      end
    end,
    desc = "Paste from clipboard",
  },
  ["<D-s>"] = {
    function()
      vim.api.nvim_input "<Esc>"
      vim.cmd "w"
    end,
    desc = "Save file",
  },
  ["<D-z>"] = { function() vim.cmd "undo" end, desc = "Undo" },
  ["<D-y>"] = { function() vim.cmd "redo" end, desc = "Redo" },
  ["<D-w>"] = {
    function()
      local bufnr = vim.api.nvim_get_current_buf()
      vim.cmd "bnext"
      vim.api.nvim_buf_delete(bufnr, { force = false })
    end,
    desc = "Close tab",
  },
  ["<F5>"] = { function() vim.cmd "AstroReload" end, desc = "Reload Workspace" },
}

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 2, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      -- update_in_insert = false,
      virtual_text = { virt_text_pos = "right_align", suffix = "  ", format = formatDiagnostic },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true,
        number = true,
        spell = false,
        signcolumn = "yes",
        wrap = false,

        clipboard = "", -- dd doesnt overwrite + register
        list = true,
        listchars = {
          space = "⋅",
          tab = "» ",
          trail = "•",
          extends = "❯",
          precedes = "❮",
          nbsp = "␣",
        },
      },
      g = { -- vim.g.<key>
      },
    },
    -- setting a mapping to false will disable it
    -- ["<C-S>"] = false,
    mappings = {
      -------------------------------------------------------- normal --------------------------------------------------------
      n = merge({
        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        ["<Leader>bn"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["<Leader>bp"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
        ["<Leader>b<tab>"] = { function() vim.cmd "b#" end, desc = "Most recent buffer" },

        ["F2"] = { function() vim.cmd "normal! <Leader>lr" end, desc = "Rename symbol" },

        -- mappings for "language"
        ["<Leader>lt"] = {
          function()
            local filetype = vim.fn.input { prompt = "enter Filetype:" }
            if filetype == "" then return end
            vim.cmd("set filetype=" .. filetype)
          end,
          desc = "Set filetype of buffer",
        },
        ["<Leader>lp"] = { "=']", desc = "Reindent pasted text" },

        -- some mapping redundancy
        ["<Leader>bf"] = { function() vim.cmd "Telescope buffers" end, desc = "Find buffers" },

        -- swap jump repeat (, & ;)
        [";"] = { ",", desc = "Swap ; and ," },
        [","] = { ";", desc = "Swap , and ;" },

        -- bring common navigation closer
        ["ö"] = { "^", desc = "Move to first non-blank character" },
        ["ä"] = { "$", desc = "Move to end of line" },
        ["ü"] = { "%", desc = "Jump to matching bracket" },

        -- move lines
        ["∆"] = { function() vim.cmd "normal! ddkP" end, desc = "Move line up" }, -- option + k
        ["º"] = { function() vim.cmd "normal! ddp" end, desc = "Move line down" }, -- option + j

        -- toggleterm
        ["<Leader>ti"] = {
          function()
            vim.cmd "1ToggleTerm direction=horizontal name=commands"
            vim.cmd "2ToggleTerm direction=vertical name=runApp"
            vim.cmd "ToggleTerm"
          end,
          desc = "Init double term layout",
        },

        -- git with toggletermr
        ["<Leader>ge"] = { desc = "Execute a predefined git command" },
        ["<Leader>gec"] = {
          function() vim.cmd "TermExec cmd='git commit -a' go_back=0" end,
          desc = " Commit with message",
        },
        ["<Leader>gel"] = { function() vim.cmd "TermExec cmd='git pull --rebase'" end, desc = "󰇚 Pull with rebase" },
        ["<Leader>geL"] = { function() vim.cmd "TermExec cmd='git pull'" end, desc = "󰇚 Pull" },
        ["<Leader>ges"] = { function() vim.cmd "TermExec cmd='git push'" end, desc = "󰕒 Push" },

        -- plugin stuff
        ["<Leader>uo"] = { function() require("copilot.suggestion").toggle_auto_trigger() end, desc = "Toggle Copilot" },
        ["<Leader>H"] = { function() vim.cmd "Alpha" end, desc = "Home Screen" },
        ["<Leader>Ss"] = {
          function()
            local sessionName = vim.fn.input { prompt = "Session Name:" }
            if sessionName == "" then return end
            require("resession").save(sessionName)
          end,
          desc = "Save session",
        },
        ["<Leader>fH"] = { "<Cmd>Telescope harpoon marks<CR>", desc = "Find Harpoon Marks" },
        ["<Leader>s"] = { desc = "sneak (leap)" },
      }, sharedKeybinds),

      -------------------------------------------------------- insert --------------------------------------------------------
      i = merge({
        -- cmd-v in insert needs to work a little differently
        ["<D-v>"] = { function() vim.cmd 'normal! "+p' end, desc = "Paste from clipboard" },
        -- movement in insert mode
        ["<D-Right>"] = { function() vim.cmd "normal! $" end, desc = "Move to end of line" },
        ["<D-Left>"] = { function() vim.cmd "normal! ^" end, desc = "Move to start of line" },
        ["ﬂ"] = { function() vim.cmd "normal! w" end, desc = "Move to next word" }, -- option + shift + l
        ["Ó"] = { function() vim.cmd "normal! b" end, desc = "Move to previous word" }, -- option + shift + h

        -- deletion in insert mode
        ["<D-Backspace>"] = { function() vim.cmd "normal! d^" end, desc = "Delete to start of line" },
        ["<D-Delete>"] = { function() vim.cmd "normal! d$" end, desc = "Delete to end of line" },
        ["<S-C-Backspace>"] = { function() vim.cmd "normal! db" end, desc = "Delete word backwards" },
        ["<S-C-Delete>"] = { function() vim.cmd "normal! dw" end, desc = "Delete word forwards" },
      }, sharedKeybinds),

      -------------------------------------------------------- visual --------------------------------------------------------
      v = merge({
        -- copy/cut
        ["<D-c>"] = { '"+y', desc = "Copy to clipboard" },
        ["<D-x>"] = { '"+d', desc = "Cut to clipboard" },

        -- indentation
        ["<Tab>"] = { ">gv", desc = "Indent selection" },
        ["<S-Tab>"] = { "<gv", desc = "Unindent selection" },

        -- move lines in visual line mode
        ["∆"] = { "dkPV']", desc = "Move lines up" }, -- option k
        ["º"] = { "dpV']", desc = "Move lines down" }, -- option j
      }, sharedKeybinds),

      t = {
        ["<C-w>"] = { "<C-\\><C-n><C-w>", desc = "Window (from terminal)" },
        ["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
        ["<D-v>"] = { '<C-\\><C-n>"+pi', desc = "Paste from clipboard" },
      },
    },
  },
}
