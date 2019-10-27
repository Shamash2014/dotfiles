{ pkgs ? import <nixpkgs> {} }:

{
  allowUnfree = true;
  packageOverrides = nixpkgs: with nixpkgs; rec {
 easyPS = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "8899121af7ad2a92340d67ef7c0cf2cf03297a2a";
    sha256 = "0pi5l9ycmfnqyzkwh6l4b5gsas0kl5jvkgb5b4ip8x8plk6aclmp";
  }); 

    

    all = with pkgs; buildEnv {
      name = "all";
      paths = [
        # your packages here
 stow
	tdesktop
	lshw
        mpv
	xmind
        emacs
        vim
	jq

	gtop
	zathura
	nodejs
	yarn
        nix-info
        nix-index
      ];
    };
  };
}
