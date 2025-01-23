local function gotoMarkIndex()
  vim.ui.input({ prompt = "Harpoon mark index: " }, function(input)
    local num = tonumber(input)
    if num then require("harpoon"):list():select(num) end
  end)
end
return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    { "AstroNvim/astroui", opts = { icons = { Harpoon = "󱡀" } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local term_string = vim.fn.exists "$TMUX" == 1 and "tmux" or "term"
        local prefix = "<Leader>h"
        maps.n[prefix] = { desc = require("astroui").get_icon("Harpoon", 1, true) .. "Harpoon" }

        maps.n[prefix .. "a"] = { function() require("harpoon"):list():add() end, desc = "Add file" }
        maps.n[prefix .. "d"] = { function() require("harpoon"):list():remove() end, desc = "Remove current file" }
        maps.n[prefix .. "t"] = { "<Cmd>Telescope harpoon marks<CR>", desc = "Show marks in Telescope" }
        maps.n[prefix .. "h"] = {
          function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
          desc = "Toggle harpoon menu",
        }
        maps.n["<C-S-x>"] = { gotoMarkIndex, desc = "Goto index of mark" }
        maps.n[prefix .. "g"] = { gotoMarkIndex, desc = "Goto index <C-S-x>" }
        maps.n["<C-p>"] = { function() require("harpoon"):list():prev() end, desc = "Goto previous mark" }
        maps.n[prefix .. "p"] = { function() require("harpoon"):list():prev() end, desc = "Goto prev mark <C-p>" }
        maps.n["<C-n>"] = { function() require("harpoon"):list():next() end, desc = "Goto next mark" }
        maps.n[prefix .. "n"] = { function() require("harpoon"):list():next() end, desc = "Goto next mark <C-n>" }
        -- NOTE: kaputtes mapping
        -- maps.n[prefix .. "t"] = {
        --   function()
        --     vim.ui.input({ prompt = term_string .. " window number: " }, function(input)
        --       local num = tonumber(input)
        --       if num then require("harpoon").term.gotoTerminal(num) end
        --     end)
        --   end,
        --   desc = "Go to " .. term_string .. " window",
        -- }
      end,
    },
  },
  specs = {
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { harpoon = true } },
    },
  },
}
