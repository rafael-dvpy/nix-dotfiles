{ hostName, pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in
{
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.zsh
    ];

    programs.zsh = {
      enable = true;

      # directory to put config files in
      dotDir = ".config/zsh";

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # .zshrc
      initExtra = ''
        PROMPT="%F{blue}%m %~%b "$'\n'"%(?.%F{green}%Bλ%b |.%F{red}?) %f"

        export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store";
        export ZK_NOTEBOOK_DIR="~/stuff/notes";
        export DIRENV_LOG_FORMAT="";
        bindkey '^ ' autosuggest-accept
        bindkey -s ^f "tmux-sessionizer\n"

        edir() { tar -cz $1 | age -p > $1.tar.gz.age && rm -rf $1 &>/dev/null && echo "$1 encrypted" }
        ddir() { age -d $1 | tar -xz && rm -rf $1 &>/dev/null && echo "$1 decrypted" }
      '';

      # basically aliases for directories: 
      # `cd ~dots` will cd into ~/.config/nixos
      dirHashes = {
        dots = "$HOME/.config/home-manager";
        stuff = "$HOME/stuff";
        media = "/run/media/$USER";
        junk = "$HOME/stuff/other";
      };

      # Tweak settings for history
      history = {
        save = 1000;
        size = 1000;
        path = "$HOME/.cache/zsh_history";
      };

      # Set some aliases
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
        nd = "() {nix develop $HOME/.config/home-manager#$1 -c zsh; echo 'You entered the $1 dev shell\!'}";
        rebuild = "nh os switch $HOME/.config/home-manager ; notify-send 'Rebuild complete\!'";
      };

      # Source all plugins, nix-style
      plugins = [
        {
          name = "auto-ls";
          src = pkgs.fetchFromGitHub {
            owner = "notusknot";
            repo = "auto-ls";
            rev = "62a176120b9deb81a8efec992d8d6ed99c2bd1a1";
            sha256 = "08wgs3sj7hy30x03m8j6lxns8r2kpjahb9wr0s0zyzrmr4xwccj0";
          };
        }
      ];
    };
  };
}
