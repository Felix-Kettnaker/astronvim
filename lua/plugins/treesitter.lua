-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "gdscript",
      "godot_resource",
      "gdshader"
      -- add more arguments for adding more treesitter parsers
    },
    indent = {
      enable = true,
      disable = { "gdshader", "gdscript", "godot_resource" }
    }
  },
}
