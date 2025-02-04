let
  pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdffZJg0F+fhMkXAT1FJ2329EbowONdbRzlmYdwpOyC sho@nixos-desktop";
in
{
  "smartcat_api_config_toml.age".publicKeys = [ pubkey ];
}
