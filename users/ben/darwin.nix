{ inputs, pkgs, ... }:

{
  nixpkgs.overlays = import ../../lib/overlays.nix  ++ [];

  homebrew = {
    enable = true;

    # Install CLI tools (brew formulas) that are not available as nix packages
    casks  = [
      "argocd"
      "argocd-autopilot"
      "argocd-vault-plugin"
      "autoconf"
      "awk"
      "boost"
      "brotli"
      "c-ares"
      "cairo"
      "capstone"
      "cmake"
      "coreutils"
      "curl"
      "dbus"
      "docker"
      "docker-completion"
      "doctl"
      "erlang"
      "ffmpeg"
      "flac"
      "fontconfig"
      "freetype"
      "gcc"
      "gettext"
      "giflib"
      "git-town"
      "glib"
      "gmp"
      "gnu-sed"
      "gnu-tar"
      "gnupg"
      "graphviz"
      "grep"
      "gtk+3"
      "harfbuzz"
      "htop"
      "icu4c"
      "jansson"
      "jasper"
      "jpeg-turbo"
      "jq"
      "json-c"
      "lame"
      "ldns"
      "leptonica"
      "libarchive"
      "libass"
      "libbluray"
      "libepoxy"
      "libevent"
      "libgcrypt"
      "libgit2"
      "libgpg-error"
      "libmaxminddb"
      "libmicrohttpd"
      "libmpc"
      "libnotify"
      "libogg"
      "libpng"
      "librsvg"
      "libsodium"
      "libtiff"
      "libunistring"
      "libusb"
      "libvorbis"
      "libvpx"
      "libx11"
      "libyaml"
      "llvm"
      "lua"
      "m4"
      "make"
      "mbedtls"
      "meson"
      "mpdecimal"
      "mpfr"
      "ncurses"
      "nettle"
      "nmap"
      "nushell"
      "oniguruma"
      "openssl"
      "opus"
      "packer"
      "pandoc"
      "pango"
      "pcre2"
      "pipx"
      "pixman"
      "pkgconf"
      "python@3.12"
      "qemu"
      "readline"
      "rebar3"
      "rust"
      "sqlite"
      "tmux"
      "tree"
      "tree-sitter"
      "unbound"
      "unixodbc"
      "webp"
      "whois"
      "wireshark"
      "xz"
      "yubikey-agent"
      "zig"
      "zimg"
      "zlib"
      "zstd"

      # Install GUI applications (brew casks)
      "1password"
      "aerospace"
      "dbeaver-community"
      "discord"
      "dropbox"
      "flutter"
      "ghostty"
      "google-chrome"
      "hammerspoon"
      "imageoptim"
      "karabiner-elements"
      "logseq"
      "mockoon"
      "monodraw"
      "multipass"
      "obs"
      "postman"
      "raycast"
      "screenflow"
      "slack"
      "spotify"
      "tailscale"
      "vlc"
      "visual-studio-code"
      "wezterm"
      "wireshark"
      "xquartz"
      "zed"
    ];
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.ben = {
    home = "/Users/ben";
    shell = pkgs.zsh;
  };
}
