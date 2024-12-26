-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

-- available plugins can be found at https://github.com/AstroNvim/astrocommunity
---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- lang
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.vue" },

  -- visual
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.indent.indent-blankline-nvim" },

  -- functional
  { import = "astrocommunity.comment.ts-comments-nvim" },
  { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.motion.leap-nvim" },
}
