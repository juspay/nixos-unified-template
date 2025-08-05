{ flake, pkgs, lib, ... }:
let
  initContent = lib.optionalString pkgs.stdenv.isDarwin # sh
    ''
      # Workaround for linker errors like https://github.com/nammayatri/nammayatri/blob/49b26c595681b68536f0357884c82766047805b1/Backend/README.md?plain=1#L97-L103
      # see also: <https://github.com/juspay/nixone/issues/34>
      ulimit -s 65500
    '';
in
{
  home.packages = [
    # Setup Claude Code using Google Vertex AI Platform
    # https://github.com/juspay/vertex
    flake.inputs.vertex.packages.${pkgs.system}.default
  ];

  programs = {
    bash.initExtra = initContent;
    zsh = {
      inherit initContent;
    };

    # Hides gcloud email in prompt (used by vertex CLI)
    # See: https://github.com/juspay/nixos-unified-template/discussions/184
    starship.settings.gcloud.disabled = true;
  };
}
