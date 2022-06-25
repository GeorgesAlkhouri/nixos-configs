let
  dev = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPr0+rqXBWv4e4wPMmHcUkmDtj3ILbjEyfWjm4qBFjMb";
  users  = dev;
in
{
  "secrets/passwords/users/dev.age".publicKeys = [ users ];
  "secrets/passwords/users/root.age".publicKeys = [ users ];
}
