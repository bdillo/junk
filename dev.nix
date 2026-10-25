{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    tree
    ripgrep
    fd
    jq
    curl
    nixfmt
    prettier
    pyright
    ruff
    rustup
    uv
    just
    nodejs
    qemu
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "darcula-solid";
      editor.file-picker.hidden = false;
    };
    languages = {
      language-server.rust-analyzer.config.check.command = "clippy";

      language-server.pyright.config.python.analysis.typeCheckingMode = "basic";
      language-server.ruff.command = "ruff";
      language-server.ruff.args = [ "server" ];
      language-server.ruff.config.settings.args = [ "--ignore" "E501" ];

      language = [
        {
          name = "rust";
          language-servers = [ "rust-analyzer" ];
          formatter.command = "rustfmt";
          auto-format = true;
        }
        {
          name = "python";
          language-servers = [ "pyright" "ruff" ];
        }
      ];
    };
  };

  programs.vim = {
    enable = true;
    settings = {
      tabstop = 4;
      shiftwidth = 4;
      number = true;
    };
    extraConfig = "syntax on";
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
    gitCredentialHelper.enable = false;
  };

  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF2m8je5nNCXHBABPShbFJj9JxEAMbmMT8vTOltcpHLc";
      signByDefault = true;
      format = "ssh";
    };
    ignores = [
      ".gitignore"
      ".idea"
      ".DS_Store"
    ];
    settings = {
      user.name = "bdillo";
      user.email = "ben.g.dillon@pm.me";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  home.file.".prettierrc.json".text = builtins.toJSON {
    printWidth = 80;
    proseWrap = "always";
  } + "\n";

  programs.claude-code = {
    enable = true;
    context = ./agent/AGENTS.md;
  };

  programs.pi-coding-agent = {
    enable = true;

    # Keep using the upstream/npm-installed `pi` binary for now. The current
    # nixpkgs package can lag behind upstream; Home Manager still manages the
    # config files below.
    package = null;

    context = ./agent/AGENTS.md;

    settings = {
      defaultProvider = "openai-codex";
      defaultModel = "gpt-6-sol";
      defaultThinkingLevel = "medium";
      theme = "dark";
      externalEditor = "hx";
      enabledModels = [
        "gpt-*"
        # "claude-*"
        # "gemini-*"
      ];
      compaction.enabled = true;
      retry = {
        enabled = true;
        maxRetries = 3;
      };
    };
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      set -o vi
      bind -m vi-insert '"\C-r": reverse-search-history'
    '';
  };

  programs.zsh = {
    enable = true;
    history.share = false;
    initContent = ''
      set -o vi
      bindkey '^R' history-incremental-search-backward
    '';
    shellAliases = {
      ll = "ls -la";
    };
  };
}
