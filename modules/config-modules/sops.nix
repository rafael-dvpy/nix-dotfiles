# modules/config-modules/sops.nix
{ inputs, config, lib, pkgs, ... }:

{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml; # Path to your encrypted secrets file
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt"; # Path to the age key for decryption
      generateKey = true; # Automatically generate an age key if it doesn't exist
    };
  };

  # Example: Make a secret available as a file
  sops.secrets.example-secret = {
    owner = "rafael";
    path = "/home/rafael/.config/example/secret"; # Where the decrypted secret will be placed
  };

  # Ensure the sops package is installed
  environment.systemPackages = with pkgs; [ sops ];
}
