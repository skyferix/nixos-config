{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
 
  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 30d"; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yoga";

  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vilnius";
  time.hardwareClockInLocalTime = true;
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.skyferix = {
    isNormalUser = true;
    description = "Skyferix";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      spotify      

      #programming
      jetbrains.phpstorm
      (pkgs.php83.buildEnv {
        extensions = ({ enabled, all }: enabled ++ (with all; [
          xdebug
        ]));
      })
      php83Packages.composer      
      symfony-cli
      yarn
      graphviz
    ];
  };
  virtualisation.docker.enable = true;
 
  nixpkgs.config.allowUnfree = true;

  programs = {
    vim.defaultEditor = true;
    git.prompt.enable = true;
    firefox.enable = true;
  };
  environment.systemPackages = with pkgs; [
    wget 
    git 
    alsa-firmware
    flameshot
  ];

  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=3
    options snd-sof-intel-hda-common hda_model=alc287-yoga9-bass-spk-pin
  '';

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
 
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  system.stateVersion = "24.05";
}
