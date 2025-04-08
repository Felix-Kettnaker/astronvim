-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `,h astrocore`

-- INFO: merge two tables together for keybinds
local function merge(t1, t2)
  for k, v in pairs(t2) do
    if t1[k] == nil then t1[k] = v end
  end
  return t1
end

-- INFO: truncating diagnostic messages
local function formatDiagnostic(diagnostic)
  -- local cursorLine = vim.api.nvim_win_get_cursor(0)[1]
  -- if cursorLine >= diagnostic.lnum - 1 and cursorLine <= diagnostic.end_lnum + 1 then
  -- Diagnostic is in current line
  return diagnostic.message:sub(0, 64) .. (string.len(diagnostic.message) > 64 and "..." or "")
  -- end
  -- return diagnostic.message
end

function SplitHtmlTag()
  -- Get the current line and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local row = cursor_pos[1] - 1 -- Convert to 0-based index

  -- Determine the indentation level (number of leading spaces)
  local indent = line:match("^(%s*)")
  local indent_level = #indent
  local attr_indent = indent_level + 2

  -- Pattern to match tag name and attributes
  local tag_pattern = "^%s*<([%w-]+)(.-)(/?)>$"

  -- Extract tag name, attributes, and self-closing slash (if any)
  local tag_name, attributes, self_closing = line:match(tag_pattern)
  if not tag_name then
    print("No valid HTML tag found on the current line.")
    return
  end

  -- Trim leading and trailing whitespace from attributes
  attributes = attributes:gsub("^%s*(.-)%s*$", "%1")
-- Parse attributes safely (handles key="value", key='value', and key-only like @click, no-caps)
local attr_list = {}
local pos = 1
while pos <= #attributes do
  -- Skip whitespace
  local _, next_pos = attributes:find("^%s*", pos)
  pos = next_pos + 1

  -- Try key="value"
  local key, val, end_pos = attributes:match('^([@:%w%.-]+)%s*=%s*"([^"]*)"', pos)
  if key then
    table.insert(attr_list, key .. '="' .. val .. '"')
    pos = pos + #key + #val + 3 + (attributes:sub(pos + #key + 1):match("^%s*") or ""):len()
  else
    -- Try key='value'
    key, val = attributes:match("^([@:%w%.-]+)%s*=%s*'([^']*)'", pos)
    if key then
      table.insert(attr_list, key .. '="' .. val .. '"') -- normalize to double quotes
      pos = pos + #key + #val + 3 + (attributes:sub(pos + #key + 1):match("^%s*") or ""):len()
    else
      -- Try key-only boolean attribute
      local raw_attr = attributes:match("^([@:%w%.-]+)", pos)
      if raw_attr then
        table.insert(attr_list, raw_attr)
        pos = pos + #raw_attr
      else
        -- Can't match anything, break to avoid infinite loop
        break
      end
    end
  end
end
  -- local attr_list = {}
  -- for attr in attributes:gmatch('%S+') do
  --   local key, val = attr:match('([^=]+)%s*=%s*"([^"]*)"')
  --   if not key then
  --     key, val = attr:match("([^=]+)%s*=%s*'([^']*)'")
  --   end
  --
  --   if key and val then
  --     table.insert(attr_list, key .. '="' .. val .. '"')
  --   else
  --     table.insert(attr_list, attr) -- key-only attribute
  --   end
  -- end

  -- Construct the new formatted tag as a table of lines
  local formatted_tag = { indent .. "<" .. tag_name }
  for _, attr in ipairs(attr_list) do
    table.insert(formatted_tag, string.rep(" ", attr_indent) .. attr)
  end
  if self_closing == "/" then
    table.insert(formatted_tag, indent .. "/>")
  else
    table.insert(formatted_tag, indent .. ">")
  end

  -- Replace the current line with the formatted tag
  vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, formatted_tag)
end

-- Create a command ':SplitHtmlTag' to call the function
vim.api.nvim_create_user_command('SplitHtmlTag', SplitHtmlTag, {})

vim.cmd "packadd! matchit"


-------------------------------------------------------- all modes --------------------------------------------------------
local sharedKeybinds = {
  ["<C-Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  ["<S-C-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
  ["<D-a>"] = { function() vim.cmd "normal! ggVG" end, desc = "Select all" },
  ["<D-f>"] = { function() vim.cmd "Telescope current_buffer_fuzzy_find" end, desc = "Find in buffer" }, -- different in visual mode
  ["<D-F>"] = { function() vim.cmd "Telescope live_grep" end, desc = "Find in files" },
  ["<D-p>"] = { function() vim.cmd "Telescope find_files" end, desc = "Find file" },
  ["<D-v>"] = { function() vim.cmd 'normal! "+p' end, desc = "Paste from clipboard" },
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
  ["<D-b>"] = {
    function() vim.cmd("ToggleTerm " .. vim.v.count .. " size=10 direction=horizontal") end,
    desc = "Toggle bottom terminal",
  },
  ["<F5>"] = { function() vim.cmd "AstroReload" end, desc = "Reload Workspace" },
  
  ["<D-Up>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.lineAddCursor(-1)
    end
  end, desc="Add Cursor above"
  },
  ["<D-Down>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.lineAddCursor(1)
    end
  end, desc="Add Cursor below"
  },
  ["<D-S-Up>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.lineSkipCursor(-1)
    end
  end, desc="Skip Cursor above"
  },
  ["<D-S-Down>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.lineSkipCursor(1)
    end
  end, desc="Skip add Cursor below"
  },
  ["<C-D-n>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.matchAddCursor(1)
    end
  end, desc="Add Cursor next match"
  },
  ["<C-D-p>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.matchAddCursor(-1)
    end
  end, desc="Add Cursor prev match"
  },
  ["<C-D-S-n>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.matchSkipCursor(1)
    end
  end, desc="Skip add Cursor prev match"
  },
  ["<C-D-S-p>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.matchSkipCursor(-1)
    end
  end, desc="Skip add Cursor prev match"
  },
  ["<C-D-Tab>"] = { function()
    local mc = require("multicursor-nvim")
    for i = 1, vim.v.count1 do
      mc.nextCursor(1)
    end
  end, desc="Cycle Cursor"
  },
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
        gdefault = true,

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

        ["<F2>"] = { function() vim.lsp.buf.rename() end, desc = "Rename current symbol" },

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

        -- quickfixlist
        ["<Leader>xc"] = {"<cmd>cexpr []<CR>", desc = "Clear quickfix"},
        ["<Leader>xC"] = {"<cmd>cexpr []<CR>", desc = "Clear loclist"},

        -- some mapping redundancy
        ["<Leader>bf"] = { function() vim.cmd "Telescope buffers" end, desc = "Find buffers" },

        -- yank from given line(s) and paste at cursor
        ["<Leader>y"] = {
          function()
            vim.ui.input({ prompt = "yank range (comma separated or single value): " }, function(input)
              if not input or input == "" then return end
              vim.cmd(input .. "y | .put")
            end)
          end,
          desc = "Yank from anywhere and paste",
        },
        -- swap jump repeat (, & ;)
        [";"] = { ",", desc = "Repeat Jump backward" },
        [","] = { ";", desc = "Repeat Jump forward" },

        -- bring common navigation closer
        ["ö"] = { "^", desc = "Move to first non-blank character" },
        ["ä"] = { "$", desc = "Move to end of line" },
        ["ü"] = { "%", desc = "Jump to matching bracket" },

        -- move lines
        ["∆"] = { function() vim.cmd "normal! ddkP==" end, desc = "Move line up reindented" }, -- option + k
        ["º"] = { function() vim.cmd "normal! ddp==" end, desc = "Move line down reindented" }, -- option + j

        -- indent lines
        ["<Tab>"] = { ">>", desc = "Indent line" },
        ["<S-Tab>"] = { "<<", desc = "dedentline" },

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

        ["<Leader>um"] = { "<cmd>Neominimap bufToggle<cr>", desc = "Toggle buffer minimap"},
        ["<Leader>uM"] = { "<cmd>Neominimap toggle<cr>", desc = "Toggle global minimap"},
        ["<C-w>m"] = { "<cmd>Neominimap toggleFocus<cr>", desc = "Switch minimap focus"},

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

        ["<Leader>s"] = { desc = "surround itTf/\\" },
        ["<Leader>si"] = { desc = "surround with input" },
        ["<Leader>st"] = { desc = "surround with tag (change leaves attributes)" },
        ["<Leader>sT"] = { desc = "surround with Tag" },
        ["<Leader>sf"] = { desc = "surround with function" },
        ["<Leader>s/"] = { desc = "surround with /*...*/" },
        ["<Leader>s\\"] = { desc = "surround with /* ... */" },

      }, sharedKeybinds),

      -------------------------------------------------------- insert --------------------------------------------------------
      i = merge({
        -- cmd-v in insert needs to work a little differently
        ["<D-v>"] = { "<C-r>+", desc = "Paste from clipboard" },
        -- movement in insert mode
        ["<D-Right>"] = { function() vim.cmd "normal! $" end, desc = "Move to end of line" },
        ["<D-Left>"] = { function() vim.cmd "normal! ^" end, desc = "Move to start of line" },
        ["ﬂ"] = { function() vim.cmd "normal! w" end, desc = "Move to next word" }, -- option + shift + l
        ["Ó"] = { function() vim.cmd "normal! b" end, desc = "Move to previous word" }, -- option + shift + h

        ["<S-Tab>"] = { function() vim.cmd "normal! <<" end, desc = "dedentline" },

        -- deletion in insert mode
        ["<D-Backspace>"] = { function() vim.cmd "normal! d0" end, desc = "Delete to start of line" },
        ["<D-Delete>"] = { function() vim.cmd "normal! d$" end, desc = "Delete to end of line" },
        ["<S-C-Backspace>"] = { function() vim.cmd "normal! db" end, desc = "Delete word backwards" },
        ["<S-C-Delete>"] = { function() vim.cmd "normal! dw" end, desc = "Delete word forwards" },
      }, sharedKeybinds),

      -------------------------------------------------------- visual --------------------------------------------------------
      v = merge({
        ["<D-f>"] = { "y:<C-u>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR><C-r>0", desc = "Find Selection in buffer" },
        -- copy/cut
        ["<D-c>"] = { '"+y', desc = "Copy to clipboard" },
        ["<D-x>"] = { '"+d', desc = "Cut to clipboard" },

        -- indentation
        ["<Tab>"] = { ">gv", desc = "Indent selection" },
        ["<S-Tab>"] = { "<gv", desc = "Unindent selection" },

        -- move lines in visual line mode
        ["∆"] = { "dkPV']=V']", desc = "Move lines up reindented" }, -- option k
        ["º"] = { "dpV']=V']", desc = "Move lines down reindented" }, -- option j
      }, sharedKeybinds),

      -------------------------------------------------------- terminal -------------------------------------------------------

      t = merge({
        ["<C-w>"] = { "<C-\\><C-n><C-w>", desc = "Window (from terminal)" },
        ["<D-Esc>"] = { "<C-\\><C-n>", desc = "Exit terminal mode" },
        ["<D-v>"] = { '<C-\\><C-n>"+pi', desc = "Paste from clipboard" },
      }, sharedKeybinds),
    },
  },
}
