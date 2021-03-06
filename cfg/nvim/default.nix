{ pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
  plugins = pkgs.callPackage ./plugins.nix {
    buildVimPluginFrom2Nix = (master.vimUtils.override {
      inherit (master.neovim)
        ;
    }).buildVimPluginFrom2Nix;
  };
  neovim = pkgs.callPackage ./neovim.nix { };
  # wrappedNeovimQt = pkgs.symlinkJoin {
  #   name = "neovim-qt";
  #   paths = [ (unstable.neovim-qt.override { neovim = neovim; }) ];
  #   buildInputs = [ pkgs.makeWrapper ];
  #   postBuild = ''
  #     wrapProgram $out/bin/nvim-qt \
  #       --prefix PATH : "${runtime}/bin"
  #   '';
  # };
in
{
  programs.neovim = {
    enable = true;
    package = neovim.package;
    extraConfig = builtins.readFile ./rc.vim;
    extraPackages = with unstable; [
      # rustfmt
      # rls
      rust-analyzer
      nixpkgs-fmt
      # rnix-lsp
      python37Packages.black
      python37Packages.python-language-server
      # nodePackages.javascript-typescript-langserver
      nodePackages.typescript-language-server # tsserver
      nodePackages.prettier
      nodePackages.bash-language-server
      shfmt
      # Preview for nvim telescope
      bat
      # Necessary for minimap.vim
      code-minimap
    ];
    plugins = with master.pkgs.vimPlugins; [
      # Impure manager.
      # vim-plug
      # Fuzzy finding.
      fzf-vim
      # Movement.
      vim-easymotion
      # Languages.
      vim-nix
      vim-javascript
      purescript-vim
      ### Currently not in repo:
      # vim-jsx-typescript
      vim-tsx
      typescript-vim
      # Buffer formatting.
      neoformat
      NeoSolarized
      # Themes.
      awesome-vim-colorschemes
      plugins.vim-monochrome
      plugins.vim-colors-pencil
      plugins.vim-photon
      # Highlight yank.
      vim-highlightedyank
      # RGB string colorizer.
      plugins.nvim-colorizer-lua
      # Popup finder.
      plugins.popup
      plugins.plenary
      plugins.lsp-extensions
      plugins.telescope
      # Update location list position.
      plugins.vim-loclist-follow
      # Colorscheme framework.
      plugins.colorbuddy
      # Minimap.
      plugins.minimap-vim
      # Register preview.
      plugins.registers-nvim

      # LSP.
      {
        plugin = nvim-lspconfig;
	# optional = true;
      }
      # Aid completion
      {
        plugin = plugins.completion-nvim;
	# optional = true;
      }
      # Treesitter.
      {
        plugin = plugins.nvim-treesitter;
	# optional = true;
      }
      {
        plugin = plugins.nvim-treesitter-textobjects;
	# optional = true;
      }
    ];
  };

  home.file =
    let
      jsCommon = ''
        nmap <buffer><leader>mf :Neoformat<cr>
        set shiftwidth=2
      '';
    in
    {
      ".config/nvim/lua".source = ./lua;
      ".config/nvim/colors".source = ./colors;
      ".config/nvim/ftplugin/nix.vim".text = ''
        nmap <buffer><leader>mf :Neoformat nixpkgsfmt<cr>
      '';
      ".config/nvim/ftplugin/rust.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/sh.vim".text = ''
        let g:shfmt_opt="-ci"
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/python.vim".text = ''
        nmap <buffer><leader>mf :Neoformat black<cr>
        nmap <buffer><leader>mi :Neoformat isort<cr>
      '';
      ".config/nvim/ftplugin/javascript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/typescript.vim".text = ''
        ${jsCommon}
      '';
      ".config/nvim/ftplugin/css.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftplugin/html.vim".text = ''
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftdetect/html.vim".text = ''
        autocmd BufNewFile,BufRead *.html.tera setf html
      '';
      ".config/nvim/ftplugin/htmldjango.vim".text = ''
        let g:neoformat_htmldjango_htmlbeautify = {
          \ 'exe': 'html-beautify',
          \ 'args': ['--indent-size ' .shiftwidth()],
          \ 'stdin': 1,
          \ }
        let g:neoformat_enabled_htmldjango = ['htmlbeautify']
        nmap <buffer><leader>mf :Neoformat<cr>
      '';
      ".config/nvim/ftdetect/toml.vim".text = ''
        " From: https://github.com/cespare/vim-toml/blob/master/ftdetect/toml.vim
        " Go dep and Rust use several TOML config files that are not named with .toml.
        autocmd BufNewFile,BufRead *.toml,Gopkg.lock,Cargo.lock,*/.cargo/config,*/.cargo/credentials,Pipfile setf toml
      '';
      # ABI incompatibilities. Should use https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lockfile.json
      # ".config/nvim/parser/rust.so".source = "${master.tree-sitter.builtGrammars.rust}/parser";
      # ".config/nvim/parser/python.so".source = "${master.tree-sitter.builtGrammars.python}/parser";
      # ".config/nvim/parser/toml.so".source = "${master.tree-sitter.builtGrammars.toml}/parser";
      # ".config/nvim/parser/bash.so".source = "${master.tree-sitter.builtGrammars.bash}/parser";
    };

}
