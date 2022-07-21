build-p14s:
	sudo nixos-rebuild -j 8 switch --flake .#p14s

diff-p14s:
	nixos-rebuild -j 8 build --flake .#p14s && nvd diff /run/current-system result

check:
	nix flake check

dconf-nix:
	dconf dump / | dconf2nix > hosts/p14s/dconf.nix
