{ config, pkgs, ... }:
{
  imports = [ ./dev.nix ];

  home.username = "bendillon";
  home.homeDirectory = "/Users/bendillon";

  home.packages = with pkgs; [ home-manager ];

  programs.git.settings.gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";

  home.file.".ssh/config".text = ''
    Host *
      IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      SetEnv TERM=xterm-256color
  '';

  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      keybind = "global:alt+space=toggle_visibility";
      font-family = "JetBrains Mono NL";
    };
  };

  programs.zsh.initContent = ''
    export PS1='%~ %# > '
  '';

  programs.bash.profileExtra = ''
    [[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
  '';

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "25.11";
}
