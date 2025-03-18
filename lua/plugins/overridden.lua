return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        -- auto_trigger = false,
        keymap = {
          accept = "<C-D-Space>",
          accept_word = "<C-D-Return>",
          next = "<C-D-.>",
          prev = "<C-D-,>",
        },
      },
    },
  },
  {
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
      },
      aliases = {
        ["b"] = { "}", "]", ")", ">"},
      }
    },
  },
  {
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
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      open_files_do_not_replace_types = { "terminal", "toggleterm" },
    },
  },
  {
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
}
