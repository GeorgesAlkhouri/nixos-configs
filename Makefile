build-p14s:
	sudo nixos-rebuild -j 8 switch --flake .#p14s

check-p14s:
	nix flake check #p14s

dconf-nix:
	dconf dump / | dconf2nix > hosts/p14s/dconf.nix
