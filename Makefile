build-p14s:
	sudo nixos-rebuild -j 8 switch --flake .#p14s

check-p14s:
	nix flake check #p14s
