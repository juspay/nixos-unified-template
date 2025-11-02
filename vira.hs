-- CI configuration <https://vira.nixos.asia/>
\ctx pipeline ->
  let isMain = ctx.branch == "main"
  in pipeline
    { build.systems =
        [ "x86_64-linux"
        , "aarch64-darwin"
        ]
    , signoff.enable = True
    }
