let
  pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPdffZJg0F+fhMkXAT1FJ2329EbowONdbRzlmYdwpOyC sho@nixos-desktop";
in
{
  "anthropic_apikey.age".publicKeys = [ pubkey ];
}
