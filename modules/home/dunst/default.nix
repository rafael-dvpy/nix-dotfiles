{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.dunst;
  configDir = ./config;
in
{
  options.modules.dunst = { enable = mkEnableOption "Dunst notification daemon"; };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      package = pkgs.dunst;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          width = 300;
          height = 100;
          origin = "top-right";
          offset = "10x10";
          scale = 0;
          notification_limit = 5;
          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          transparency = 10;
          text_icon_padding = 0;
          frame_width = 2;
          frame_color = "#7aa2f7";
          separator_color = "frame";
          corner_radius = 8;
          font = "JetBrains Mono 12";
          line_height = 0;
          padding = 8;
          horizontal_padding = 8;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          enable_recursive_icon_lookup = true;
          icon_theme = "Adwaita";
          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };
        urgency_low = {
          background = "#24283b";
          foreground = "#c0caf5";
          timeout = 5;
        };
        urgency_normal = {
          background = "#24283b";
          foreground = "#c0caf5";
          timeout = 10;
        };
        urgency_critical = {
          background = "#f7768e";
          foreground = "#1a1b26";
          frame_color = "#f7768e";
          timeout = 0;
        };
      };
    };
  };
}
