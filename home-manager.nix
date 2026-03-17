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
      xournalpp
      digikam
      inkscape
      rmpc
      mpd

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
  services.mpd = {
  enable = true;
  musicDirectory = "/home/lareadmin/SYNC-TELEFONO/musica";
  # Optional:
  network.listenAddress = "any"; # if you want to allow non-localhost connections
  network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
};
    #Dotfiles
    xdg.portal.enable = true;
    xdg.portal.extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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

      "rmpc" = {
        source = ./home/.config/rmpc;
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
    
    services = {
      syncthing = {
        enable = true;
        guiAddress = "0.0.0.0:8384";
        # user = "lareadmin";
        # dataDir = "/home/myusername/Documents";
        # configDir = "/home/myusername/.config/syncthing";
        # overrideDevices = true;     # overrides any devices added or deleted through the WebUI
        # overrideFolders = true;     # overrides any folders added or deleted through the WebUI
        settings = {
          gui = {
            user = "lare";
            password = "password";
          };
          
        #   devices = {
        #     "device1" = { id = "DEVICE-ID-GOES-HERE"; };
        #     "device2" = { id = "DEVICE-ID-GOES-HERE"; };
        #   };
        #   folders = {
        #     "Documents" = {         # Name of folder in Syncthing, also the folder ID
        #       path = "/home/myusername/Documents";    # Which folder to add to Syncthing
        #       devices = [ "device1" "device2" ];      # Which devices to share the folder with
        #     };
        #     "Example" = {
        #       path = "/home/myusername/Example";
        #       devices = [ "device1" ];
        #       ignorePerms = false;  # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.
        #     };
        #   };
        };
      };
    };
  };

}
