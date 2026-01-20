Require fish
Require om
Require eza

# Outputs
Output out.gif
Output out.mp4

# Configurations
Set Shell fish
Set FontSize 16
Set FontFamily "JetbrainsMono Nerd Font"
Set Height 1000
Set Margin 8
Set MarginFill "#7E7EFF"
Set BorderRadius 10
Set CursorBlink false

# Stage 1: Module Generation
Type "om init github:juspay/nixos-unified-template -o ./$output_dir && cd ./$output_dir"
Sleep 1s
Enter
Hide
Wait+Line@100s /(?i)\bSelect\s+a\s+template\b/
Show
Sleep 1.5s
Down
Sleep 300ms
Down
Sleep 300ms
Up
Sleep 300ms
Up
Sleep 300ms
Down
Sleep 300ms
Down
Sleep 1s
Enter
Type "hostname"
Sleep 1s
Enter
Type "johndoe"
Sleep 1s
Enter
Sleep 1s
Type "John Doe"
Sleep 1s
Enter
Sleep 1s
Type "johndoe@example.com"
Sleep 1s
Enter
Sleep 1.5s
Type "y"
Enter
Sleep 1.5s
Enter
Sleep 1.5s

# Stage 2: Module Exploration
Hide
Type "clear"
Show
Enter
Hide
Type "eza --tree --icons ."
Show
Enter
Sleep 7s
