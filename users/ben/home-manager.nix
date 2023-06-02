{ config, lib, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.stateVersion = "18.09";
  xdg.enable = true;

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
  };

  ## install programs
  home.packages = with pkgs; [

    #kubernetes 
    k9s
    kubectl
    pkgs.krew

    #languages
    gopls
    delve
    nodejs
    rustup

    #development
    lazygit
    doctl
    gh
    zellij
    helix
    neovim
    alacritty

    #utilities 
    tmux
    starship
    exa
    ripgrep
    fd
    fzf
    btop
    stow
    rclone
    ranger
    zoxide
    ansible
    navi
    jq
    tree
    watch

    #fun
    thefuck
    lolcat

  ] ++ (lib.optionals isLinux [
    chromium
    firefox
    rofi
    nitrogen
  ]);

  #load dotfiles
  xdg.configFile."i3/config".text = builtins.readFile ./dotfiles/i3/config;
  xdg.configFile."i3/i3blocks.conf".text = builtins.readFile ./dotfiles/i3/i3blocks.conf;

  xdg.configFile."i3/scripts/bandwidth2;".text = builtins.readFile ./dotfiles/i3/scripts/bandwidth2;
  xdg.configFile."i3/scripts/battery1".text = builtins.readFile ./dotfiles/i3/scripts/battery1;
  xdg.configFile."i3/scripts/battery2".text = builtins.readFile ./dotfiles/i3/scripts/battery2;

  xdg.configFile."i3/scripts/blurlock".text = builtins.readFile ./dotfiles/i3/scripts/blur-lock;
  xdg.configFile."i3/scripts/cpu_usage".text = builtins.readFile ./dotfiles/i3/scripts/cpu_usage;
  xdg.configFile."i3/scripts/disk".text = builtins.readFile ./dotfiles/i3/scripts/disk;
  xdg.configFile."i3/scripts/empty_workspace".text = builtins.readFile ./dotfiles/i3/scripts/empty_workspace;
  xdg.configFile."i3/scripts/keyboard-layout".text = builtins.readFile ./dotfiles/i3/scripts/keyboard-layout;
  xdg.configFile."i3/scripts/keyhint".text = builtins.readFile ./dotfiles/i3/scripts/keyhint;
  xdg.configFile."i3/scripts/keyhint-2".text = builtins.readFile ./dotfiles/i3/scripts/keyhint-2;
  xdg.configFile."i3/scripts/memory".text = builtins.readFile ./dotfiles/i3/scripts/memory;
  xdg.configFile."i3/scripts/openweather".text = builtins.readFile ./dotfiles/i3/scripts/openweather;
  xdg.configFile."i3/scripts/openweather-city".text = builtins.readFile ./dotfiles/i3/scripts/openweather-city;
  xdg.configFile."i3/scripts/openweather.conf".text = builtins.readFile ./dotfiles/i3/scripts/openweather.conf;
  xdg.configFile."i3/scripts/power-profiles".text = builtins.readFile ./dotfiles/i3/scripts/power-profiles;
  xdg.configFile."i3/scripts/powermenu".text = builtins.readFile ./dotfiles/i3/scripts/powermenu;
  xdg.configFile."i3/scripts/ppd-status".text = builtins.readFile ./dotfiles/i3/scripts/ppd-status;
  xdg.configFile."i3/scripts/temperature".text = builtins.readFile ./dotfiles/i3/scripts/temperature;
  xdg.configFile."i3/scripts/volume".text = builtins.readFile ./dotfiles/i3/scripts/volume;
  xdg.configFile."i3/scripts/vpn".text = builtins.readFile ./dotfiles/i3/scripts/vpn;

  # rofi
  xdg.configFile."rofi/arc_dark_colors.rasi".text = builtins.readFile ./dotfiles/rofi/arc_dark_colors.rasi;
  xdg.configFile."rofi/arc_dark_transparent_colors.rasi".text = builtins.readFile ./dotfiles/rofi/arc_dark_transparent_colors.rasi;
  xdg.configFile."rofi/power-profiles.rasi".text = builtins.readFile ./dotfiles/rofi/power-profiles.rasi;
  xdg.configFile."rofi/powermenu.rasi".text = builtins.readFile ./dotfiles/rofi/powermenu.rasi;
  xdg.configFile."rofi/rofidmenu.rasi".text = builtins.readFile ./dotfiles/rofi/rofidmenu.rasi;
  xdg.configFile."rofi/rofikeyhint.rasi".text = builtins.readFile ./dotfiles/rofi/rofikeyhint.rasi;

  # alacritty
  xdg.configFile."alacritty/alacritty.yml".text = builtins.readFile ./dotfiles/alacritty/alacritty.yml;
  xdg.configFile."alacritty/dracula.yml".text = builtins.readFile ./dotfiles/alacritty/dracula.yml;

  #helix
  xdg.configFile."helix/config.toml".text = builtins.readFile ./dotfiles/helix/config.toml;


  programs.zsh = { };

  programs.gpg.enable = !isDarwin;

  programs.go = {
    enable = true;
    goPath = "code/go";
    goPrivate = [ "github.com/BenOnions" "github.com/nepgpe" ];
  };

  programs.i3status = {
    enable = isLinux;

    general = {
      colors = true;
      color_good = "#8C9440";
      color_bad = "#A54242";
      color_degraded = "#DE935F";
    };

    modules = {
      ipv6.enable = false;
      "wireless _first_".enable = false;
      "battery all".enable = false;
    };
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      italic-text = "always";
    };
  };

  services.gpg-agent = {
    enable = isLinux;
    pinentryFlavor = "tty";

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

  xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  home.pointerCursor = lib.mkIf isLinux {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "text/xml" = "firefox.desktop";
      "application/xhtml_xml" = "firefox.desktop";
      "image/webp" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/ftp" = "firefox.desktop";
    };
  };
}
