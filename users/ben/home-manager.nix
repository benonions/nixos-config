{ isWSL, inputs, ... }:

{ config, lib, pkgs, ... }:

let
  sources = import ../../nix/sources.nix;
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  manpager = (pkgs.writeShellScriptBin "manpager" (if isDarwin then ''
    sh -c 'col -bx | bat -l man -p'
  '' else ''
    cat "$1" | col -bx | bat --language man --style plain
    ''));
in {
  imports = [
    ./sway.nix
    ./zsh-config.nix
    inputs.nvf.homeManagerModules.default
  ];

  home = {
    stateVersion = "18.09";
    sessionVariables = {
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_ALL = "en_US.UTF-8";
      EDITOR = "nvim";
      PAGER = "less -FirSwX";
      MANPAGER = "${manpager}/bin/manpager";
    };

    file = {
      "${config.xdg.configHome}/waybar" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/ben/dotfiles/waybar";
      };

      "${config.xdg.configHome}/wofi" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/ben/dotfiles/wofi";
      };
    };

    packages = [
      pkgs._1password-cli pkgs.asciinema pkgs.bat pkgs.eza pkgs.fd pkgs.fzf
      pkgs.gh pkgs.htop pkgs.jq pkgs.ripgrep pkgs.sentry-cli pkgs.tree pkgs.watch
      pkgs.gopls pkgs.zigpkgs."0.13.0" pkgs.nodejs
      pkgs.k9s
      pkgs.packer
      pkgs.helm
      pkgs.lazydocker
      pkgs.kubectl
      pkgs.zoxide
      pkgs.thefuck
    ] ++ (lib.optionals isDarwin [ pkgs.cachix pkgs.tailscale ])

      ++ (lib.optionals (isLinux && !isWSL) [
        pkgs.chromium pkgs.firefox pkgs.rofi pkgs.valgrind pkgs.zathura
        pkgs.xfce.xfce4-terminal pkgs.nemo
      ]);
  };

  programs = {

    gpg.enable = !isDarwin;

    bash = {
      enable = true;
      shellOptions = [];
      historyControl = [ "ignoredups" "ignorespace" ];
      initExtra = builtins.readFile ./bashrc;
      shellAliases = {
        ga = "git add";
        gc = "git commit";
        gco = "git checkout";
        gcp = "git cherry-pick";
        gdiff = "git diff";
        gl = "git prettylog";
        gp = "git push";
        gs = "git status";
        gt = "git tag";
      };
    };

    tmux = {
      enable = true;

    };

    neovim = {
      enable = false;
    };

    nvf = {
      enable = true;
      # This is the sample configuration for nvf, aiming to give you a feel of the default options
      # while certain plugins are enabled. While it may partially act as one, this is *not* quite
      # an overview of nvf's module options. To find a complete and curated list of nvf module
      # options, examples, instruction tutorials and more; please visit the online manual.
      # https://notashelf.github.io/nvf/options.html
      settings.vim = {
        viAlias = true;
        vimAlias = true;
        debugMode = {
          enable = false;
          level = 16;
          logFile = "/tmp/nvim.log";
        };

        spellcheck = {
          enable = true;
        };

        lsp = {
          formatOnSave = true;
          lspkind.enable = false;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = true;
          otter-nvim.enable = true;
          lsplines.enable = true;
          nvim-docs-view.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = true;
          };
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableLSP = true;
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          # Languages that will be supported in default and maximal configurations.
          nix.enable = true;
          markdown.enable = true;

          # Languages that are enabled in the maximal configuration.
          bash.enable = true;
          clang.enable = true;
          css.enable = true;
          html.enable = true;
          sql.enable = true;
          java.enable = true;
          kotlin.enable = true;
          ts.enable = true;
          go.enable = true;
          lua.enable = true;
          zig.enable = true;
          python.enable = true;
          typst.enable = true;
          rust = {
            enable = true;
            crates.enable = true;
          };

          # Language modules that are not as common.
          assembly.enable = false;
          astro.enable = false;
          nu.enable = false;
          csharp.enable = false;
          julia.enable = false;
          vala.enable = false;
          scala.enable = false;
          r.enable = false;
          gleam.enable = false;
          dart.enable = false;
          ocaml.enable = false;
          elixir.enable = false;
          haskell.enable = false;
          ruby.enable = false;

          tailwind.enable = false;
          svelte.enable = false;

          # Nim LSP is broken on Darwin and therefore
          # should be disabled by default. Users may still enable
          # `vim.languages.vim` to enable it, this does not restrict
          # that.
          # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
          nim.enable = false;
        };

        visuals = {
          nvim-scrollbar.enable = true;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;

          highlight-undo.enable = true;
          indent-blankline.enable = true;

          # Fun
          cellular-automaton.enable = false;
        };

        statusline = {
          lualine = {
            enable = true;
            theme = "dracula";
          };
        };

        theme = {
          enable = true;
          name = "dracula";
          transparent = false;
        };

        autopairs.nvim-autopairs.enable = true;

        autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        filetree = {
          neo-tree = {
            enable = true;
          };
        };

        tabline = {
          nvimBufferline.enable = true;
        };

        treesitter.context.enable = true;

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false; # throws an annoying debug message
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = true; # lighter, faster, and uses lua for configuration
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = true;
        };

        notify = {
          nvim-notify.enable = true;
        };

        projects = {
          project-nvim.enable = true;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = true;
          yanky-nvim.enable = false;
          icon-picker.enable = true;
          surround.enable = true;
          leetcode-nvim.enable = true;
          multicursors.enable = true;

          motion = {
            hop.enable = true;
            leap.enable = true;
            precognition.enable = true;
          };
          images = {
            image-nvim.enable = false;
          };
        };

        notes = {
          orgmode.enable = false;
          mind-nvim.enable = true;
          todo-comments.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          modes-nvim.enable = false; # the theme looks terrible with catppuccin
          illuminate.enable = true;
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          smartcolumn = {
            enable = true;
            setupOpts.custom_colorcolumn = {
              # this is a freeform module, it's `buftype = int;` for configuring column position
              nix = "110";
              ruby = "120";
              java = "130";
              go = ["90" "130"];
            };
          };
          fastaction.enable = true;
        };

        assistant = {
          chatgpt.enable = false;
          copilot = {
            enable = false;
            cmp.enable = true;
          };
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        comments = {
          comment-nvim.enable = true;
        };

        presence = {
          neocord.enable = false;
        };
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };

    direnv.enable = true;

    # git = {
    #   enable = true;
    #   userName = "Mitchell Hashimoto";
    #   userEmail = "m@mitchellh.com";
    #   signing = { key = "523D5DC389D273BC"; signByDefault = true; };
    #   aliases = {
    #     cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
    #     prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    #     root = "rev-parse --show-toplevel";
    #   };
    #   extraConfig = {
    #     branch.autosetuprebase = "always";
    #     color.ui = true;
    #     core.askPass = "";
    #     credential.helper = "store";
    #     github.user = "mitchellh";
    #     push.default = "tracking";
    #     init.defaultBranch = "main";
    #   };
    # };

    emacs.enable = true;

    bat.enable = true;

    yazi = {
      enable = true;
    };

    ghostty = {
      enable = true;
    };

    nushell.enable = true;
  };

  services = {
    gpg-agent = {
      enable = isLinux;
      pinentryPackage = pkgs.pinentry-tty;
      defaultCacheTtl = 31536000;
      maxCacheTtl = 31536000;
    };
  };

  xdg.configFile = {
    # "yazi/config.toml".source = ./yazi.toml;
    # "ghostty/config".source = ./ghostty;
  };


  xresources.extraConfig = builtins.readFile ./Xresources;
  home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };
}

