local M = {}
return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        keymap = {
          accept = "<C-D-Space>",
          accept_word = "<D-Right>",
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
        normal_cur = "<Leader>sl",
        normal_line = "<Leader>sn", -- not really useful
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
    },
  },
}
