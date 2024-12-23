-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `,h astrocore`

local function merge(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end
local sharedKeybinds = {
  ["<C-Tab>"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
  ["<S-C-Tab>"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },
  ["<D-a>"] = { "ggVG", desc = "Select all" },
  ["<D-f>"] = { "/", desc = "Find in buffer" },
  ["<D-F>"] = { ":Telescope live_grep<CR>", desc = "Find in files" },
  ["<D-p>"] = { ":Telescope find_files<CR>", desc = "Find file" },
  ["<D-v>"] = { function() vim.cmd 'normal! "+P' end, desc = "Paste from clipboard" },
  ["<D-s>"] = { function() vim.cmd "w" end, desc = "Save file" },
  ["<D-z>"] = { function() vim.cmd "undo" end, desc = "Undo" },
  ["<D-y>"] = { function() vim.cmd "redo" end, desc = "Redo" },
  ["<D-w>"] = { function() vim.cmd "bdelete" end, desc = "Close tab" },
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
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      -- update_in_insert = false,
      virtual_text = { virt_text_pos = "right_align", suffix = "  " },
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
        smartindent = true,
        autoindent = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE, `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE, keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    -- tables with just a `desc` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    -- ["<Leader>b"] = { desc = "Buffers" },
    -- setting a mapping to false will disable it
    -- ["<C-S>"] = false,
    mappings = {
      -- first key is the mode
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

        -- always format pasted text
        ["p"] = { "p=']", desc = "Format pasted text" },
        ["P"] = { "P=']", desc = "Format pasted text" },

        -- paste yanked
        ["<Leader>p"] = { '"0p', desc = "Paste from Yank register" },
        ["<Leader>P"] = { '"0P', desc = "Paste from Yank register before cursor" },

        -- swap jump repeat (, & ;)
        [";"] = { ",", desc = "Swap ; and ," },
        [","] = { ";", desc = "Swap , and ;" },

        -- bring common navigation closer
        ["ö"] = { "^", desc = "Move to first non-blank character" },
        ["ä"] = { "$", desc = "Move to end of line" },
        ["ü"] = { "%", desc = "Jump to matching bracket" },

        -- move lines
        ["∆"] = { function() vim.cmd "normal! ddkP" end, desc = "Move line up" },
        ["º"] = { function() vim.cmd "normal! ddp" end, desc = "Move line down" },
      }, sharedKeybinds),

      i = merge({}, sharedKeybinds),

      v = merge({
        -- copy/cut
        ["<D-c>"] = { '"+y', desc = "Copy to clipboard" },
        ["<D-x>"] = { '"+d', desc = "Cut to clipboard" },

        -- indentation
        ["<Tab>"] = { ">gv", desc = "Indent selection" },
        ["<S-Tab>"] = { "<gv", desc = "Unindent selection" },

        -- move lines visual
        ["∆"] = { "dkPV']", desc = "Move line up" },
        ["º"] = { "dpV']", desc = "Move line down" },
      }, sharedKeybinds),
    },
  },
}
