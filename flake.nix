{
  inputs = {
    neovim.url = "github:neovim/neovim?dir=contrib";
    nvimPlenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
    nvimPopup = {
      url = "github:nvim-lua/popup.nvim";
      flake = false;
    };
    nvimLspExtensions = {
      url = "github:nvim-lua/lsp_extensions.nvim";
      flake = false;
    };
    nvimTelescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    nvimTreesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvimTreesitterTextobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    nvimMonochrome = {
      url = "github:fxn/vim-monochrome";
      flake = false;
    };
    nvimVimColorsPencil = {
      url = "github:reedes/vim-colors-pencil";
      flake = false;
    };
    nvimPhoton = {
      url = "github:axvr/photon.vim";
      flake = false;
    };
    nvimCompletionNvim = {
      url = "github:nvim-lua/completion-nvim";
      flake = false;
    };
    nvimVimLoclistFollow = {
      url = "github:elbeardmorez/vim-loclist-follow";
      flake = false;
    };
    nvimColorbuddyNvim = {
      url = "github:tjdevries/colorbuddy.nvim";
      flake = false;
    };
    nvimColorizerLua = {
      url = "github:norcalli/nvim-colorizer.lua";
      flake = false;
    };
    nvimMinimapVim = {
      url = "github:wfxr/minimap.vim";
      flake = false;
    };
    nvimRegistersNvim = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    awesomeSharedtags = {
      url = "github:Drauthius/awesome-sharedtags";
      flake = false;
    };
    awesomeLain = {
      url = "github:lcpz/lain";
      flake = false;
    };
    awesomeFreedesktop = {
      url = "github:lcpz/awesome-freedesktop";
      flake = false;
    };
  };
  outputs =
    { self
    , nixpkgs
    , neovim
    , nvimPlenary
    , nvimPopup
    , nvimLspExtensions
    , nvimTelescope
    , nvimTreesitter
    , nvimTreesitterTextobjects
    , nvimMonochrome
    , nvimVimColorsPencil
    , nvimPhoton
    , nvimCompletionNvim
    , nvimVimLoclistFollow
    , nvimColorbuddyNvim
    , nvimColorizerLua
    , nvimMinimapVim
    , nvimRegistersNvim
    , awesomeSharedtags
    , awesomeLain
    , awesomeFreedesktop
    }: {
      builtPackages = { inherit neovim; };
      sources = {
        inherit nvimPlenary nvimPopup nvimLspExtensions nvimTelescope nvimTreesitter nvimTreesitterTextobjects
          nvimMonochrome nvimVimColorsPencil nvimPhoton nvimColorbuddyNvim nvimColorizerLua nvimMinimapVim nvimRegistersNvim
          nvimCompletionNvim nvimVimLoclistFollow awesomeSharedtags awesomeLain awesomeFreedesktop;
      };
    };
}
