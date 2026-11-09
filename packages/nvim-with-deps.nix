{
  mkPkgCollection,

  neovim,
  ripgrep,
  fd,
  git,
  curl,
  gnutar,
  gcc,
  tree-sitter,

  # formatters
  jq,
  stylua,
  nixfmt,

  # language servers
  lua-language-server,
}@args:

mkPkgCollection "nvim-with-deps" args
