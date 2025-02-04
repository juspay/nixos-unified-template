{ ... }:
{
  programs = {
    # on macOS, you probably don't need this
    bash = {
      enable = true;
      initExtra = ''
        # Custom bash profile goes here
      '';
    };

    # For macOS's default shell.
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      envExtra = ''
        # Custom ~/.zshenv goes here
      '';
      profileExtra = ''
        # Custom ~/.zprofile goes here
      '';
      loginExtra = ''
        # Custom ~/.zlogin goes here
      '';
      logoutExtra = ''
        # Custom ~/.zlogout goes here
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prmot!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  };
}
