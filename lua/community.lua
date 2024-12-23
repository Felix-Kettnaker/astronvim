-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

-- available plugins can be found at https://github.com/AstroNvim/astrocommunity
---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },

  {
    import = "astrocommunity.completion.copilot-lua",
    opts = {
      suggestion = {
        enabled = true,
        keymap = {
          accept = "<S-D-Space>",
          accept_word = "<D-Right>",
        },
      },
    },
  },
  -- import/override with your plugins folder
}
