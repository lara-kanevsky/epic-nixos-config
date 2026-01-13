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
      #Basico
      ripgrep
      less
      tree
      git
      unrar

      #Texto/terminal
      vscode
      kitty
      tmux
      neovim

      #Entorno grafico
      xclip
      maim
      rofi
      feh
      pulseaudio
      brightnessctl

      #Apps
      google-chrome
      obsidian

      #Arte digital
      krita

      #Desarrollo (mover a dev shells)
      nixfmt-rfc-style
      kubectl
      docker
      python3
      kubernetes-helm
    ];

    programs.google-chrome.enable = true;
    programs.git = {
    enable = true;

    userName  = "Lare";
    userEmail = "larakanevsky@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };
    #Dotfiles

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
      ".bash_aliases".source = ./home/.bash_aliases;
      ".tmux.conf".source = ./home/.tmux.conf;

    };
  };

}
