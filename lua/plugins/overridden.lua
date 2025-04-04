return {
  { -- copilot.lua
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        auto_trigger = false,
        keymap = {
          accept = "<C-D-Space>",
          accept_word = "<C-D-Return>",
          next = "<C-D-.>",
          prev = "<C-D-,>",
        },
      },
    },
  },

  { -- nvim-surround
    "kylechui/nvim-surround",
    opts = {
      keymaps = {
        normal = "<Leader>s",
        normal_cur = "<Leader>sl", -- surround corrent line
        normal_line = "<Leader>sn", -- surround on new lines (above+bellow)
        normal_cur_line = "<Leader>sln",
        visual = "<Leader>s",
        visual_line = "<Leader>sn",
        delete = "<Leader>sd",
        change = "<Leader>sc",
        change_line = "<Leader>scn",
      },
      surrounds = {
        ["/"] = {
          add = { "/*", "*/" },
          find = "/%*.-%*/",
          delete = "^(%/%*)().-(%*%/)()$",
        },
        ["\\"] = {
          add = { " /* ", " */ " },
          find = " ?/%* ?.- ?%*/ ?",
          delete = "^( ?/%* ?)().-( ?%*%/ ?)()$",
        },
        ["!"] = {
          add = { "<!--", "-->" },
          find = "<!%-%-.-%-%->",
          delete = "^(<!%-%-)().-(%-%->)()$",
        },
        ["¡"] = {
          add = { " <!-- ", " --> " },
          find = " ?<!%-%- ?.- ?%-%-> ?",
          delete = "^( ?<!%-%- ?)().-( ?%-%-> ?)()$",
        },
      },
      aliases = {
        ["b"] = { "}", "]", ")", ">"},
      }
    },
  },

  { -- neo-tree.nvim
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["a"] = false,
          ["A"] = false,
          ["n"] = { "add", config = { show_path = "none" } },
          ["N"] = "add_directory",
        },
      },
      filesystem = {
        filtered_items = {
          hide_by_pattern = {
            "*.uid",
          }
        }
      },
      open_files_do_not_replace_types = { "terminal", "toggleterm" },
    },
  },

  { -- heirline.nvim
    "rebelot/heirline.nvim",
    opts = function(_, opts)
      local statusline = opts.statusline

      -- Add file path component to statusline
      local file_info = {
        provider = function()
          local path_full = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
          local path = string.sub(path_full, 0, 64)
          if string.len(path) < string.len(path_full) then path = "..." .. path end
          -- need to fix this to actually display the nr in all sessions, for now just longer slice
          if vim.bo.filetype == "toggleterm" then return "󰆍 " .. "Term " .. string.sub(path, -30) .. " " end
          if vim.bo.filetype == "neo-tree" then return "🌳" end
          if path == "" then return "" end
          return "󰉋 " .. path .. " "
        end,
        hl = { fg = "#89B4FA" }, -- Catppuccin blue
      }

      -- Insert after the "file_info" block
      table.insert(statusline, 4, file_info)
      return opts
    end,
  },

  { -- telescope.nvim
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
       file_ignore_patterns = {
          "%.uid",
        }
      }
    }
  },

  {
    -- "CopilotC-Nvim/CopilotChat.nvim",
  },

  { -- neominimap.nvim
    "Isrothy/neominimap.nvim",
    enabled = false,
    init = function ()
      vim.g.neominimap = {
        x_multiplier = 5,
        float = {
          minimap_width = 14,
          window_border = "none"
        },
        buf_filter = function()
          return vim.api.nvim_buf_line_count(0) > 48
        end,
        delay = 800,
        click = { enabled = true },

        diagnostic = {
          severity = vim.diagnostic.severity.INFO,
        },
        git = {
          mode = "icon",
          icon = {
            add = "▎",
            change = "▎",
            delete = "▎",
          }
        },
        search = {
          enabled = true,
        }
      }
    end
  },
  {
    "jake-stewart/multicursor.nvim",
    branch="1.0",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local set = vim.keymap.set

      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse)
      set("n", "<c-leftdrag>", mc.handleMouseDrag)
      set("n", "<c-leftrelease>", mc.handleMouseRelease)

      -- Disable and enable cursors.
      -- set({"n", "x"}, "<c-q>", mc.toggleCursor)

      -- Mappings defined in a keymap layer only apply when there are
      -- multiple cursors. This lets you have overlapping mappings.
      mc.addKeymapLayer(function(layerSet)

        -- Delete the main cursor.
        -- layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)

        -- Enable and clear cursors using escape.
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)

      -- Customize how cursors look.
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { bg = "#FFFFAA", fg = "#332222" })
    end
  },
}
