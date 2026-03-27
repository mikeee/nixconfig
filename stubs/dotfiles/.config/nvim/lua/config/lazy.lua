-- CI stub: minimal lazy.lua for flake check evaluation
require("lazy").setup({
  lockfile = vim.fn.stdpath("state") .. "/lazy-lock.json",
})
