{ hostName, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.modules.zsh;

  # Fetch auto-ls plugin
  auto-ls = pkgs.fetchFromGitHub {
    owner = "notusknot";
    repo = "auto-ls";
    rev = "62a176120b9deb81a8efec992d8d6ed99c2bd1a1";
    sha256 = "08wgs3sj7hy30x03m8j6lxns8r2kpjahb9wr0s0zyzrmr4xwccj0";
  };

  # Fetch fzf-zsh-plugin
  fzf-zsh-plugin = pkgs.fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "909f0b8879481eab93741fa284a7d1d13cf6f79e";
    sha256 = "1z80816f9nnix79vcd8a5b5nr8kzislld789xy5sr4yqs7hy90j4";
  };
in
{
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh
      starship # Prompt
      fzf # Fuzzy finder
      jq # For nixdevs function
      upower # For battery status
    ];

    # Provide fzf key-bindings.zsh
    home.file.".fzf/shell/key-bindings.zsh" = {
      source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/shell/key-bindings.zsh";
        sha256 = "1j0b3bgawr14aqp7qp7a3wmrm822ynqkrbbrvslrbpyscca89r1g";
      };
    };

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true; # Provided by nixpkgs zsh-autosuggestions
      syntaxHighlighting.enable = true; # Provided by nixpkgs zsh-syntax-highlighting

      plugins = [
        {
          name = "auto-ls";
          src = auto-ls;
          file = "auto-ls.zsh";
        }
        {
          name = "fzf-zsh-plugin";
          src = fzf-zsh-plugin;
          file = "fzf-zsh-plugin.plugin.zsh";
        }
      ];

      initContent = ''
        # Starship prompt
        eval "$(starship init zsh)"

        # Environment variables
        export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
        export ZK_NOTEBOOK_DIR="$HOME/stuff/notes"
        export DIRENV_LOG_FORMAT=""
        export EDITOR="nvim"
        export VISUAL="nvim"
        export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --color=bg+:#24283b,fg+:#c0caf5,pointer:#7aa2f7,hl:#f7768e"

        # Source fzf key-bindings
        [ -f "$HOME/.fzf/shell/key-bindings.zsh" ] && source "$HOME/.fzf/shell/key-bindings.zsh"

        # Keybindings
        bindkey '^ ' autosuggest-accept
        bindkey -s '^f' 'tmux-sessionizer\n'
        bindkey '^r' fzf-history-widget # Ctrl+R for history search
        bindkey '^t' fzf-file-widget    # Ctrl+T for file search

        # Functions
        edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
        ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
        note() { nvim "$ZK_NOTEBOOK_DIR/$(fzf --preview 'bat --style=plain --color=always {}' --query \"$1\")" }
        nixgc() { nix-collect-garbage -d && notify-send "Nix garbage collection complete!" }
        nixdevs() { nix flake show $HOME/.config/home-manager --json | jq '.devShells."x86_64-linux" | keys' }

        # Direnv hook
        eval "$(direnv hook zsh)"
      '';

      dirHashes = {
        dots = "$HOME/.config/home-manager";
        stuff = "$HOME/stuff";
        media = "/run/media/$USER";
        junk = "$HOME/stuff/other";
      };

      history = {
        save = 10000;
        size = 10000;
        path = "$HOME/.cache/zsh_history";
      };

      shellAliases = {
        c = "clear";
        mkdir = "mkdir -vp";
        rm = "rm -rifv";
        mv = "mv -iv";
        cp = "cp -riv";
        cat = "bat --paging=never --style=plain";
        ls = "exa --icons";
        ll = "exa -l --icons";
        la = "exa -a --icons";
        lla = "exa -la --icons";
        lg = "lazygit";
        ld = "lazydocker";
        tree = "exa --tree --icons";
        v = "nvim";
        nd = ''() { nix develop $HOME/.config/home-manager#$1 -c zsh; echo "You entered the $1 dev shell!" }'';
        rebuild = ''sudo nixos-rebuild switch --flake $HOME/.config/home-manager#${hostName} --show-trace ; notify-send "Rebuild complete!"'';
        # Git aliases
        gst = "git status";
        gco = "git checkout";
        gcm = "git commit -m";
        gpl = "git pull";
        gps = "git push";
        # Nix aliases
        nsh = "nix-shell";
        ncl = "nix-collect-garbage";
        nup = "nix flake update $HOME/.config/home-manager";
        # Tmux aliases
        tma = "tmux attach -t";
        tmk = "tmux kill-session -t";
      };
    };

    # Enable direnv for per-project environments
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Starship configuration
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_status"
          "$nix_shell"
          "$cmd_duration"
          "$battery"
          "$custom"
          "\n$character"
        ];
        username = {
          style_user = "bold #c0caf5";
          style_root = "bold #f7768e";
          format = "[$user]($style)@";
          show_always = false;
        };
        hostname = {
          ssh_only = true;
          style = "bold #7aa2f7";
          format = "[$hostname]($style):";
        };
        directory = {
          style = "bold #7aa2f7";
          truncate_to_repo = true;
          truncation_length = 3;
          format = "[$path]($style) ";
        };
        git_branch = {
          style = "bold #9ece6a";
          format = "[$symbol$branch]($style) ";
          symbol = " ";
        };
        git_status = {
          style = "bold #f7768e";
          format = "[$all_status$ahead_behind]($style) ";
        };
        nix_shell = {
          style = "bold #86b9d6";
          format = "[\\($name\\)]($style) ";
          symbol = "❄️ ";
        };
        cmd_duration = {
          style = "bold #f1fa8c";
          format = "[$duration]($style) ";
          min_time = 2000;
        };
        battery = {
          disabled = false;
          style = "bold #f7768e";
          format = "[$symbol$percentage]($style) ";
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "🔋 ";
          display = [
            {
              threshold = 100;
              style = "bold #a6e3a1";
            }
            {
              threshold = 30;
              style = "bold #f7768e";
            }
          ];
        };
        custom.vim = {
          when = "test -n \"$NVIM\"";
          command = "echo ''";
          format = "[$output]($style)";
          style = "bold #a6e3a1";
        };
        character = {
          success_symbol = "[λ](bold #a6e3a1)";
          error_symbol = "[?](bold #f7768e)";
        };
      };
    };
  };
}
