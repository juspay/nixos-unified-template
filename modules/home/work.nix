let
  initContent = # sh
    ''
      # Workaround for linker errors like https://github.com/nammayatri/nammayatri/blob/49b26c595681b68536f0357884c82766047805b1/Backend/README.md?plain=1#L97-L103
      # see also: <https://github.com/juspay/nixone/issues/34>
      ulimit -s 65500
    '';
in
{
  programs = {
    bash.initExtra = initContent;
    zsh = {
      inherit initContent;
    };
  };
}
