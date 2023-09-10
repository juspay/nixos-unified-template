{
  # Starship configuration from this example:
  # https://github.com/srid/nixos-config/blob/f9cf0def19fbc7aa1e836be481ce50d214e34036/home/starship.nix#L4-L19
  programs.starship = {
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
}
