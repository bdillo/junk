default:
    @just --list

switch-mac:
    home-manager switch --flake .#mac

format-md:
    prettier --write '**/*.md'

format-nix:
    find . -type f -name '*.nix' -not -path './.git/*' -exec nixfmt {} +

format: format-md format-nix
