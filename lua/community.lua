-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

-- available plugins can be found at https://github.com/AstroNvim/astrocommunity
---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- lang (general)
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.sql" },
  -- specific
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.vue" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.godot" },
  { import = "astrocommunity.pack.rust" },

  -- visual
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.pack.rainbow-delimiter-indent-blankline" },

  -- functional
  { import = "astrocommunity.comment.ts-comments-nvim" },
  { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.motion.leap-nvim" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.motion.nvim-surround" },
}
