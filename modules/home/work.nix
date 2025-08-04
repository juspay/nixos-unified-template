let
  initContent = # sh
    ''
      # Incraesing stack size for haskell project compilation
      # see: <https://github.com/juspay/nixone/issues/34>
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
