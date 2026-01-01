{
  config,
  lib,
  pkgs,
  home-manager,
  self,
  ...
}:
{
  imports = [ home-manager.nixosModules.default ];
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.lareadmin = {
    home.stateVersion = "24.11";

    home.packages = with pkgs; [
      ripgrep
      less
      nixfmt-rfc-style
      tree
      git
      vscode
      docker
      kitty
      kubectl
      google-chrome
      xclip
      maim
      rofi
      feh
      krita
      brightnessctl
      pulseaudio
    ];
    programs.google-chrome.enable = true;

    xdg.configFile = {
      "i3" = {
        source = ./home/.config/i3;
        recursive = true;
        force = true;
      };

      "kitty" = {
        source = ./home/.config/kitty;
        recursive = true;
        force = true;
      };
    };

    # Dotfiles en $HOME
    home.file = {
      ".bashrc".source = ./home/.bashrc;
    };

  };

}
