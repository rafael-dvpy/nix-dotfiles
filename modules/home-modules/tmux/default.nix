{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.modules.tmux;
in
{
  options.modules.tmux = { enable = mkEnableOption "tmux"; };
  config = mkIf cfg.enable {

    programs.tmux = {
      enable = true;
      baseIndex = 1;
      extraConfig = /*bash*/''
        set-option -g default-terminal "screen-256color"
        set-option -g focus-event on
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
      '';
    };

  };
}

