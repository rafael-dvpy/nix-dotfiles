{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.tmux;
  tpm = pkgs.fetchFromGitHub {
    owner = "tmux-plugins";
    repo = "tpm";
    rev = "v3.0.0";
    sha256 = "18q5j92fzmxwg8g9mzgdi5klfzcz0z01gr8q2y9hi4h4n864r059";
  };
in
{
  options.modules.tmux = { enable = mkEnableOption "tmux"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux
    ];

    home.file.".tmux/plugins/tpm" = {
      source = tpm;
      recursive = true;
    };

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      extraConfig = ''
        set-option -g default-terminal "screen-256color"
        set-option -g focus-events on
        set-option -sg escape-time 10
        set -g default-command ${pkgs.zsh}/bin/zsh
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf
        set -g prefix C-s
        # act like vim
        setw -g mode-keys vi
        bind-key -r f run-shell "tmux neww tmux-sessionizer"
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # Status bar
        set -g status on
        set -g status-position bottom
        set -g status-justify left
        set -g status-style 'bg=#24283b fg=#c0caf5'
        set -g status-left '#[fg=#f7768e,bold][#S] '
        set -g status-right '#{prefix_highlight} #[fg=#7aa2f7,bold]#h #[fg=#c0caf5]%H:%M'
        set -g status-left-length 30
        set -g status-right-length 50
        set -g window-status-current-style 'fg=#7aa2f7,bold'
        set -g window-status-current-format '#I:#W#F'
        set -g window-status-format '#I:#W#F'
        set -g window-status-separator ' | '

        # TPM plugins
        set -g @plugin 'tmux-plugins/tpm'
        set -g @plugin 'tmux-plugins/tmux-sensible'
        set -g @plugin 'tmux-plugins/tmux-resurrect'
        set -g @plugin 'tmux-plugins/tmux-continuum'
        set -g @plugin 'tmux-plugins/tmux-yank'
        set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

        # Plugin settings
        set -g @resurrect-capture-pane-contents 'on'
        set -g @continuum-restore 'on'
        set -g @prefix_highlight_fg '#f7768e'
        set -g @prefix_highlight_bg '#24283b'
        set -g @prefix_highlight_show_copy_mode 'on'
        set -g @prefix_highlight_copy_mode_attr 'fg=#7aa2f7,bold'

        # Initialize TPM
        run-shell ~/.tmux/plugins/tpm/tpm
      '';
    };
  };
}
