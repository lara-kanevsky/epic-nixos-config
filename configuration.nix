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
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
  networking.extraHosts =
    ''
    127.0.0.1  mat.ivar.iquall.net
    '';
        # 10.71.17.100 mat.ivar.iquall.net

  time.timeZone = "America/Argentina/Buenos_Aires";
environment.pathsToLink = [ "/share/applications" "/share/xdg-desktop-portal" ];
  virtualisation.docker = {
    enable = true;
  };
  fonts.packages = with pkgs; [
    iosevka
  ];
  virtualisation.libvirtd.enable = true;
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
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

  users.users.lareadmin = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "qemu-libvirtd" "libvirtd" ];
    packages = with pkgs; [

    ];
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  programs.thunar.enable = true;
  hardware.bluetooth.enable = true;

  services.dbus.enable = true;
  services.upower.enable = true;
  services.timesyncd.enable = true;
  services.blueman.enable = true;

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
