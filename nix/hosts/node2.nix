{ lib, ... }: {
  networking.hostName = "node2";
  services.k3s = {
    role       = "agent";
    serverAddr = "https://192.168.1.80:6443";   
    token      = "K10e05191a4333cfe8677ef4421725ae9024511042ee1537ef44a3f3a85117441bf::server:6d2fbe3fd355e8a8e50a4edbb74c4fc2";
  };


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;   
  boot.loader.grub.enable = lib.mkForce false;

  networking.firewall.allowedUDPPorts = [ 8472 ];   # flannel VXLAN
  networking.firewall.allowedTCPPorts = [ 10250 ];
}

