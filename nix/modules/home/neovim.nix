# Neovim configuration managed using https://github.com/nix-community/nixvim
{ flake, ... }:
{
  imports = [
    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;

    # Theme
    colorschemes.tokyonight.enable = true;

    # Settings
    opts = {
      expandtab = true;
      shiftwidth = 2;
      smartindent = true;
      tabstop = 2;
      number = true;
      clipboard = "unnamedplus";
    };

    # Keymaps
    globals = {
      mapleader = " ";
    };

    plugins = {

      # UI
      lualine.enable = true;
      bufferline.enable = true;
      treesitter.enable = true;
      which-key = {
        enable = true;
      };
      noice = {
        # WARNING: This is considered experimental feature, but provides nice UX
        enable = true;
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
          #inc_rename = false;
          #lsp_doc_border = false;
        };
      };
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff" = {
            options.desc = "file finder";
            action = "find_files";
          };
          "<leader>fg" = {
            options.desc = "find via grep";
            action = "live_grep";
          };
        };
        extensions = {
          file-browser.enable = true;
        };
      };

      # Dev
      lsp = {
        enable = true;
        servers = {
          hls.enable = true;
          marksman.enable = true;
          nil-ls.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
        };
      };
    };
  };
}
