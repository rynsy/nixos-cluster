{ lib, pkgs, ... }:

{
  ################################  packages  #################################
  environment.systemPackages = with pkgs; [
    git neovim ripgrep fd gcc gnumake dosfstools nodejs python3 unzip zsh fzf zoxide helm
   ];

  ################################  boot loader  ##############################
  boot.loader = {
    systemd-boot.enable = true;        # pure-UEFI
    efi.canTouchEfiVariables = true;
    grub.enable = lib.mkForce false;
  };

  ################################  networking  ###############################
  networking.useDHCP = true;           # what nixos-anywhere wants

  ################################  K3s (role-agnostic) #######################
  services.k3s.enable = true;          # role is set in each host file

  # make kube-config readable for group k3s (only relevant on control-plane)
  users.groups.k3s = { };
  systemd.tmpfiles.rules = [
    "d /etc/rancher/k3s 0755 root root -"
    "f /etc/rancher/k3s/k3s.yaml 0640 root k3s -"
  ];

  ################################  SSH / users  ##############################
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
  "TODO: paste public RSA key"
  ];

  users.users.ryan = {
    isNormalUser = true;
    shell = pkgs.zsh;
    home         = "/home/ryan";
    extraGroups  = [ "wheel" "k3s" ];
    openssh.authorizedKeys.keys = [
    "TODO: paste public RSA key"
    ];
  };

  ################################  Neovim & HM  ##############################
  programs.neovim.enable = true;
  programs.zsh.enable = true;
  home-manager.users.ryan = import ../home/ryan.nix;
  home-manager.backupFileExtension = "backup";

  system.stateVersion = "24.11";
}

