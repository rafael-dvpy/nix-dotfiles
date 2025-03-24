{ lib, config, ... }:
with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = { enable = mkEnableOption "tmux"; };
  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      extraConfig = /*bash*/''
        unbind r
        bind r source-file ~/.tmux.conf

        set -g prefix C-s

        # act like vim
        setw -g mode-keys vi
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # List of plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'fabioluciano/tmux-tokyo-night'

        ### Tokyo Night Theme configuration
        set -g @theme_variation 'moon'
        set -g @theme_left_separator ''
        set -g @theme_right_separator ''
        set -g @theme_plugins 'datetime,weather,playerctl,yay'

        # Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
        run '~/.tmux/plugins/tpm/tpm'
      '';
    };

  };
}

