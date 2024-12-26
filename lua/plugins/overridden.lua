return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = {
        enabled = true,
        keymap = {
          accept = "<C-D-Space>",
          accept_word = "<D-Right>",
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        -- pattern = [[.*<(KEYWORDS)\s*]],
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      enabled = true,
      scope = {
        enabled = true,
      },
    },
  },
}
