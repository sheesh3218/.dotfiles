{ ... }:

{
  home.username = "daisy";
  home.homeDirectory = "/Users/daisy";
  home.stateVersion = "24.05";

  home.file = {
    ".gitconfig".source = ./apps/git/.gitconfig;
    ".git_func".source = ./apps/git/.git_func;
    ".gitemojis/commit-msg".source = ./apps/git/gitemojis/commit-msg;
    ".gitemojis/prepare-commit-msg".source = ./apps/git/gitemojis/prepare-commit-msg;

    ".zshrc".source = ./apps/zsh/.zshrc;
    ".zshenv".source = ./apps/zsh/.zshenv;
    ".zprofile".source = ./apps/zsh/.zprofile;
    ".exports".source = ./apps/zsh/.exports;
    ".aliases".source = ./apps/zsh/.aliases;
    ".functions".source = ./apps/zsh/.functions;

    ".yabairc".source = ./apps/yabai/.yabairc;
    ".skhdrc".source = ./apps/yabai/.skhdrc;
    ".yabai_func".source = ./apps/yabai/.yabai_func;

    ".condarc".source = ./apps/conda/.condarc;
    ".conda_func".source = ./apps/conda/.conda_func;

    "Library/Application Support/Code/User/settings.json".source = ./apps/vscode/settings.json;
    "Library/Application Support/Code/User/keybindings.json".source = ./apps/vscode/keybindings.json;

    ".hushlogin".source = ./docs/assets/.hushlogin;
    ".curlrc".source = ./apps/curl/.curlrc;
  };
  
  programs.home-manager.enable = true;
}
