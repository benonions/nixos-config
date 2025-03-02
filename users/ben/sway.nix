{ config, pkgs, lib, ... }:

{
home.packages = with pkgs; [
    waybar     # Status bar
    # swaylock   # Lock screen
    swayidle   # Idle management
    wofi       # App launcher
    lxappearance
  ];

  wayland.windowManager.sway = {
    checkConfig = false;
    enable = true;
    wrapperFeatures.gtk = true;
    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
    '';

    config = {
      terminal = "ghostty";  # Change to your preferred terminal
      menu = "wofi --show run";  # Application launcher

      # Status bar configuration
      bars = [{
        fonts.size = 15.0;
        position = "bottom";
        command = "waybar";
      }];

      # Display settings
      output = {
        Virtual-1 = {
          scale = "1";  # Adjust HiDPI scaling
        };
      };

      # Keybindings
      keybindings = {
        "Mod1+Return" = "exec ghostty"; # Alt+Enter opens terminal
        "Mod1+d" = "exec wofi --show run"; # Alt+d opens app launcher
        "Mod1+q" = "kill"; # Close focused window
        "Mod1+f" = "fullscreen toggle"; # Toggle fullscreen
        "Mod1+Shift+space" = "floating toggle"; # Toggle floating mode
        "Mod1+Shift+e" = "exec swaymsg exit"; # Exit Sway
      };

      # Mouse configuration
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
      };

      # Wallpaper
      output."*" = {
                bg = "/run/current-system/sw/share/backgrounds/nixos/nix-wallpaper-dracula.png fill";
      };

      # Start services on Sway launch
      startup = [
        # { command = "waybar"; }
        { command = "swayidle -w timeout 300 'swaylock -f -c 000000'"; }
      ];
    };
  };

  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";

  gtk = {
    enable = true;
    theme = {
        package = pkgs.adw-gtk3;
        name = "adw-gtk3";

      };
  };

  services.kanshi = {
    enable = true;
    settings = [
      { 
        profile.name = "vm";
        profile.outputs = [
          {
            criteria = "Virtual-1";
            scale = 1.5;
            mode = "3840x2160@50Hz";
          }
        ];
      }
    ];
  };
}

