
check:
	nix flake check

build-p14s:
	sudo nixos-rebuild -j 8 switch --flake .#p14s

diff-p14s:
	nixos-rebuild -j 8 build --flake .#p14s && nvd diff /run/current-system result && rm result

dconf-nix-p14s:
	dconf dump / | dconf2nix > hosts/p14s/dconf.nix

