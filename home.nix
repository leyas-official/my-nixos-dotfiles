{
  config,
  pkgs,
  spicetify-nix,
  ...
}:
let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };

  home = {
    username = "leyas";
    homeDirectory = "/home/leyas";

    file = builtins.listToAttrs (
      map (name: {
        name = ".config/${name}";
        value = {
          enable = true;
          source = ./config + "/${name}";
          force = true;
        };
      }) (builtins.attrNames (builtins.readDir ./config))
    );

    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "26.05"; # Please read the comment before changing.

  };

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
    };

    # alias air "$HOME/go/bin/air"
    interactiveShellInit = ''
      string match -q "*pts*" (tty); and fastfetch
      set -g fish_greeting ""
      alias ls "eza --icons"
      set -gx POSH agnoster
      set -e fish_transient_prompt
      oh-my-posh init fish --config $HOME/.config/ohmyposh/zen.toml | source
      oh-my-posh init fish --config $HOME/.config/ohmyposh/EDM115-newline.omp.json | source
    '';

    functions = {
      yy = {
        body = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';

      };
    };
  };

  # programs.fish = lib.mkIf config.yaziModule.fishIntegration {
  #   enable = true;
  #
  #   functions = {
  #     yy = {
  #       body = ''
  #         set tmp (mktemp -t "yazi-cwd.XXXXXX")
  #         yazi $argv --cwd-file="$tmp"
  #         if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
  #           cd -- "$cwd"
  #         end
  #         rm -f -- "$tmp"
  #       '';
  #     };
  #   };
  # };

  programs.oh-my-posh = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.kitty = {
    enable = true;

    settings = {
      font_family = "JetBrainsMono Nerd Font";
      font_size = 12;

      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      remember_window_size = "no";
      initial_window_width = 950;
      initial_window_height = 500;

      cursor_blink_interval = 0.5;
      cursor_stop_blinking_after = 1;

      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;

      enable_audio_bell = "no";

      window_padding_width = 15;
      hide_window_decorations = "yes";

      background_opacity = 0.7;
      dynamic_background_opacity = "yes";

      confirm_os_window_close = 0;

      selection_foreground = "none";
      selection_background = "none";

      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
    };
  };

  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  xdg = {
    enable = true;
    mime.enable = true;

    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/plain" = [ "nvim" ];
        "x-scheme-handler/http" = "browser-focus.desktop";
        "x-scheme-handler/https" = "browser-focus.desktop";
        "text/html" = "browser-focus.desktop";
        "video/mp4" = "celluloid.desktop";
        "video/x-matroska" = "celluloid.desktop";
        "video/webm" = "celluloid.desktop";
        "video/avi" = "celluloid.desktop";
        "video/mpeg" = "celluloid.desktop";
      };
    };
  };

  xdg.portal.config = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
  };

  xdg.desktopEntries.browser-focus = {
    name = "Browser Focus";
    exec = "${config.home.homeDirectory}/.config/home-manager/config/hypr/scripts/browser_focus.sh %u";
    terminal = false;
    type = "Application";
    mimeType = [
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "text/html"
    ];
  };

  gtk = {
    enable = true;

    theme = {
      name = "Adwaita-dark"; # or Catppuccin, Gruvbox, etc.
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    croc
    kitty
    networkmanagerapplet
    qbittorrent
    rofi
    vivid
    vlc
    bun
    mpv
    tree-sitter
    jq
    flatpak
    awww
    oh-my-posh
    eza
    gopeed
    tableplus
    jetbrains.pycharm
    obs-studio
    celluloid
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # xdg.configFile."waybar/config.jsonc".source = ../config.jsonc;
  services = {
    dunst = {
      enable = true;
    };
  };

}
