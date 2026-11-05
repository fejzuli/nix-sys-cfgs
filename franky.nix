{ pkgs, ... }:

{
  system.stateVersion = 7;
  nixpkgs.hostPlatform = "aarch64-darwin";

  networking = {
    hostName = "franky";
    computerName = "franky";
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "merlin";
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleScrollerPagingBehavior = true;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    WindowManager = {
      StageManagerHideWidgets = true;
      StandardHideWidgets = true;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
    };
    finder.FXPreferredViewStyle = "clmv";
    hitoolbox.AppleFnUsageType = "Do Nothing";
  };

  environment.shells = with pkgs; [ bashInteractive ];
  programs.bash.completion.enable = true;
  programs.direnv.enable = true;

  environment.systemPackages = with pkgs; [
    custom.coreutils-plus
    custom.nixutils
    custom.nvim-with-deps

    unstable.lima
    unstable.utm

    librewolf
    neovide
    starship
    wezterm
  ];
}
