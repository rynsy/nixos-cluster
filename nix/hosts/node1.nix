{ lib, ... }: {
  networking.hostName = "node1";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;   
  boot.loader.grub.enable = lib.mkForce false;

  # explicitly mark this unit as a server
  services.k3s.role = "server";
  services.k3s.extraFlags = [
    "--write-kubeconfig=/etc/rancher/k3s/k3s.yaml"
    "--write-kubeconfig-mode=0640"
    "--advertise-address=192.168.1.80"
    "--node-ip=192.168.1.80"
    "--tls-san=192.168.1.80"
  ];

  # cluster token so workers can join
  services.k3s.clusterInit = true;
  services.k3s.token       = "K10e05191a4333cfe8677ef4421725ae9024511042ee1537ef44a3f3a85117441bf::server:6d2fbe3fd355e8a8e50a4edbb74c4fc2";

  networking.firewall.allowedUDPPorts = [ 8472 ];   # flannel VXLAN
  networking.firewall.allowedTCPPorts = [ 6443 9345 10250 ];
}

