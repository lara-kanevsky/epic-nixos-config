{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  networking.hostName = "antonietacookstation";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };
  services.displayManager.defaultSession = "none+i3";
  programs.i3lock.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  users.users.lareadmin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      
    ];
  };

  services.dbus.enable = true;
  services.upower.enable = true;
  services.timesyncd.enable = true;

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.11"; # NO TOCAR
}
