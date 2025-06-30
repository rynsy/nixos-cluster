{
  description = "Ryan’s K3s cluster (control-plane + 2 workers)";

  inputs = {
    nixpkgs.url      = "nixpkgs/nixos-24.11";
    home.url         = "github:nix-community/home-manager/release-24.11";
    disko.url        = "github:nix-community/disko";
    deploy-rs.url    = "github:serokell/deploy-rs";
    # keep the channels in sync
    home.inputs.nixpkgs.follows      = "nixpkgs";
    disko.inputs.nixpkgs.follows     = "nixpkgs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, deploy-rs, ... }:
  let
    system     = "x86_64-linux";
    pkgs       = import nixpkgs { inherit system; };
    diskoMod   = inputs.disko.nixosModules.disko;
    hmMod      = inputs.home.nixosModules.home-manager;
    common     = ./common/base.nix;
    diskCfg    = ./disk-config.nix;

    # helper to avoid repetition
    mkNode = hostFile:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };      # makes `inputs` visible inside modules
        modules     = [ diskoMod diskCfg common hostFile hmMod ];
      };
  in
  {
    ########################################
    ## 1.  NixOS systems
    ########################################
    nixosConfigurations = rec {
      node1 = mkNode ./hosts/node1.nix;
      node2 = mkNode ./hosts/node2.nix;
      node3 = mkNode ./hosts/node3.nix;
    };

    ########################################
    ## 2.  deploy-rs targets
    ########################################
    deploy.nodes = {
      node1 = {
        hostname = "192.168.1.80";
        sshUser  = "root";
        fastConnection = true;
        profiles.system = {
          user = "root";
          # wrap the build with activate-rs:
          path = deploy-rs.lib.${system}.activate.nixos
                   self.nixosConfigurations.node1;
        };
      };

      node2 = {
        hostname = "192.168.1.81";
        sshUser  = "root";
        fastConnection = true;
        profiles.system.user = "root";
        profiles.system.path = deploy-rs.lib.${system}.activate.nixos
                                 self.nixosConfigurations.node2;
      };

      node3 = {
        hostname = "192.168.1.82";
        sshUser  = "root";
        fastConnection = true;
        profiles.system.user = "root";
        profiles.system.path = deploy-rs.lib.${system}.activate.nixos
                                 self.nixosConfigurations.node3;
      };
    };
  };
}

