{
  mkPkgCollection,

  neovim,
  ripgrep,
  git,
  curl,
  openssh,
  unzip,
}@args:

mkPkgCollection "nvim-with-deps" args
