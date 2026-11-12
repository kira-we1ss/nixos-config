{ config, lib, pkgs, ... }:

let
  cfg = config.modules.kitty;
in
{
  options.modules.kitty.enable = lib.mkEnableOption "Kitty terminal configuration";

  config = lib.mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font = {
        name = "Monocraft";
        size = 12.0;
      };

      settings = {
        shell = "${pkgs.fish}/bin/fish";
        editor = "${pkgs.nano}/bin/nano";
        allow_remote_control = "no";

        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        force_ltr = "no";

        text_composition_strategy = "legacy";

        cursor_shape = "underline";
        cursor_shape_unfocused = "hollow";
        cursor_blink_interval = "-1.5";
        cursor_trail = 1;
        cursor_trail_decay = "0.3 0.8";
        cursor_trail_start_threshold = 0;

        scrollbar = "always";
        scrollbar_interactive = "yes";
        scrollbar_jump_on_click = "yes";
        scrollbar_width = 0.8;
        scrollbar_hover_width = 0.9;
        scrollbar_handle_opacity = 1;
        scrollbar_radius = 0.2;
        scrollbar_gap = 0.05;
        scrollbar_min_handle_height = 2;
        scrollbar_hitbox_expansion = 0.25;
        scrollbar_track_hover_opacity = 0;
        scrollbar_handle_color = "#949cbb";
        scrollbar_track_color = "#51576d";

        progress_bar = "bottom";

        scrollback_pager_history_size = 20;
        scrollback_fill_enlarged_window = "yes";
        touch_scroll_multiplier = 1.5;
        pixel_scroll = "no";
        momentum_scroll = 0.80;

        mouse_hide_wait = "1.5 0 40 no";
        url_color = "#f2d5cf";
        url_style = "curly";
        open_url_with = "default";
        url_prefixes = "file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh";
        detect_urls = "yes";
        show_hyperlink_targets = "always";
        underline_hyperlinks = "hover";
        copy_on_select = "no";
        clear_selection_on_clipboard_loss = "no";
        paste_actions = "quote-urls-at-prompt,confirm-if-large";
        select_by_word_characters = "@-./_~?&=%+#";
        strip_trailing_spaces = "always";
        click_interval = "-6.7";
        focus_follows_mouse = "no";
        pointer_shape_when_grabbed = "arrow";
        default_pointer_shape = "arrow";
        pointer_shape_when_dragging = "beam crosshair";
        drag_threshold = 8;

        repaint_delay = 15;
        sync_to_monitor = "yes";

        enable_audio_bell = "no";
        visual_bell_duration = 0.8;
        visual_bell_color = "#ed8796";
        window_alert_on_bell = "no";
        bell_on_tab = "\">:(\"";

        remember_window_size = "no";
        initial_window_width = 960;
        initial_window_height = 540;
        remember_window_position = "no";
        enabled_layouts = "splits,stack,grid";
        window_resize_step_cells = 2;
        window_resize_step_lines = 2;
        window_border_width = "0.5pt";
        draw_minimal_borders = "yes";
        draw_window_borders_for_single_window = "no";
        window_margin_width = "2 4 2 4";
        single_window_margin_width = 1;
        window_padding_width = 0;
        single_window_padding_width = "-1";
        placement_strategy = "center";
        resize_debounce_time = "0.2 0.5";
        resize_in_steps = "yes";

        tab_bar_edge = "top";
        tab_bar_margin_width = 0;
        tab_bar_style = "slant";
        tab_bar_align = "left";
        tab_bar_show_new_tab_button = "yes";

        foreground = "#c6d0f5";
        background = "#303446";
        selection_foreground = "#303446";
        selection_background = "#f2d5cf";

        cursor = "#f2d5cf";
        cursor_text_color = "#303446";

        active_border_color = "#babbf1";
        inactive_border_color = "#737994";
        bell_border_color = "#e5c890";

        wayland_titlebar_color = "system";
        macos_titlebar_color = "system";

        active_tab_foreground = "#232634";
        active_tab_background = "#ca9ee6";
        inactive_tab_foreground = "#c6d0f5";
        inactive_tab_background = "#292c3c";
        tab_bar_background = "#232634";

        mark1_foreground = "#303446";
        mark1_background = "#babbf1";
        mark2_foreground = "#303446";
        mark2_background = "#ca9ee6";
        mark3_foreground = "#303446";
        mark3_background = "#85c1dc";

        color0 = "#51576d";
        color1 = "#e78284";
        color2 = "#a6d189";
        color3 = "#e5c890";
        color4 = "#8caaee";
        color5 = "#f4b8e4";
        color6 = "#81c8be";
        color7 = "#b5bfe2";
        color8 = "#626880";
        color9 = "#e78284";
        color10 = "#a6d189";
        color11 = "#e5c890";
        color12 = "#8caaee";
        color13 = "#f4b8e4";
        color14 = "#81c8be";
        color15 = "#a5adce";
      };

      extraConfig = ''
        modify_font cell_height 2px
        modify_font cell_width -0.5px
      '';
    };
  };
}
