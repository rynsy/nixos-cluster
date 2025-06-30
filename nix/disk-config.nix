# disk-config.nix
{ pkgs, ... }:

{
  disko.devices.disk.main = {
    type   = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {                       # FAT32 ESP
          size = "512M";
          type = "EF00";
          content = {
            type       = "filesystem";
            format     = "vfat";
            mountpoint = "/boot";     # mounted by stage-1
          };
        };
        root = {                      # rest of the disk
          size = "100%";
          type = "8300";
          content = {
            type       = "filesystem";
            format     = "ext4";
            mountpoint = "/";
          };
        };
      };
    };
  };
}

