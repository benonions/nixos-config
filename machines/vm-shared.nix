{ config, pkgs, lib, currentSystem, currentSystemName, ... }:

{
  #######################
  # SYSTEM CONFIGURATION
  #######################

  # System version - keep this at the install version unless you understand the implications
  system.stateVersion = "20.09";

  # Define your hostname
  networking.hostName = "dev";
  networking.networkmanager.enable = true;
  networking.useDHCP = false;  # Per-interface useDHCP is now mandatory
  networking.firewall.enable = false;  # Disabled since this is a VM with NAT networking

  # Set your time zone
  time.timeZone = "Australia/Melbourne";

  ##################
  # BOOT & KERNEL
  ##################

  # Be careful updating the kernel packages
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # EFI boot loader configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    # VMware/Parallels require consoleMode = "0" to avoid "error switching console mode"
    systemd-boot.consoleMode = "0";
  };

  ##################
  # NIX SETTINGS
  ##################

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };

  # Allow specific insecure packages (with clear justification)
  nixpkgs.config.permittedInsecurePackages = [
    "mupdf-1.17.0"  # Needed for k2pdfopt 2.53
  ];

  ##################
  # USERS & SECURITY
  ##################

  # User accounts configuration
  users.mutableUsers = false;

  # Define user account with appropriate groups
  users.users.ben = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"          # For sudo access
      "video"          # For hardware acceleration and screen capture
      "input"          # For input devices
      "networkmanager" # For network management
      "docker"         # For Docker access
    ];
  };

  # Sudo configuration
  security.sudo.wheelNeedsPassword = false;
  services.qemuGuest.enable = true;
  security.polkit.enable = true;

  # SSH server configuration
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  ##################
  # SWAY CONFIGURATION
  ##################
  
  # Enable OpenGL for Wayland compositing
  hardware.graphics.enable = true;

  # Enable greetd display manager for Sway
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # XDG Desktop Portal for screen sharing and better app integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  ##################
  # INTERNATIONALIZATION
  ##################

  # Locale and input method configuration
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-chinese-addons
      ];
    };
  };

  ##################
  # SERVICES
  ##################

  # Network services
  services.tailscale.enable = true;  # Manually authenticate with "sudo tailscale up"
  services.gnome.gnome-keyring.enable = true;

  # Application distribution platforms
  services.flatpak.enable = true;  # For testing flatpak apps
  services.snap.enable = true;     # For testing and releasing snaps

  ##################
  # VIRTUALIZATION
  ##################

  # Container and virtualization support
  virtualisation = {
    docker.enable = true;
    lxd.enable = true;
  };

  ##################
  # FONTS
  ##################

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      fira-code
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];
  };

  ##################
  # SYSTEM PACKAGES
  ##################

  # Basic system utilities
  environment.systemPackages = with pkgs; [
    # Core utilities
    cachix
    gnumake
    killall
    niv
    xclip
    wget
    git
    nixos-artwork.wallpapers.binary-black
    nixos-artwork.wallpapers.dracula
  ];

  environment.pathsToLink = [ "/share/backgrounds/nixos" ];
}
