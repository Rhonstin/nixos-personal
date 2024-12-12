# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = "nixos";
  networking.firewall.enable = false;
  nix.settings.experimental-features = ["nix-command" "flakes"];  
  users.users.devops = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ];
     initialPassword = "pw123";
  };

  security.sudo.extraRules = [
    {
      users = [ "devops" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; 
    }
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      permittedInsecurePackages = true;
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true; };
      };
      hardware.opengl = {
        enable =true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          vaapiVdpau
          libvdpau-va-gl
          intel-compute-runtime
          vpl-gpu-rt
          intel-media-sdk
        ];
      };
    }; 

  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    nano
    htop
    unzip
    fastfetch
    nix-ld
    docker
    docker-compose
    hddtemp
    intel-gpu-tools
    iotop
    lm_sensors
    mergerfs
    mc
    ncdu
    nmap
    nvme-cli
    sanoid
    snapraid
    tailscale
    tdns-cli
    tmux
    tree
    vim
    wget
    rclone
    btrfs-progs
    direnv
  ];
  
  programs.nix-ld.enable = true;

  services.openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
      settings.PermitRootLogin = "yes";
      settings.KbdInteractiveAuthentication = false;
  };

  services = {
    devmon.enable = true;
    gvfs.enable = true; 
    udisks2.enable = true;
  };
  virtualisation = {
      docker = {
      enable = true;
      autoPrune = {
          enable = true;
          dates = "weekly";
      };
      };
  };

fileSystems."/mnt/thunder" = {
  device = "/dev/sdb1";
  fsType = "btrfs";
  options = [ "subvol=main" "compress=zstd" "defaults"];
};
 system.stateVersion = "24.11";
}
