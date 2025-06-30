{ pkgs, ... }: {
  home.stateVersion = "24.11";
  programs.home-manager.enable = true;


  home.file."dotfiles".source = builtins.fetchGit {
    url = "https://github.com/rynsy/dotfiles";
    rev = "4283eb343424e535c87a80c9c334785273bb695e"; 
    shallow = true;
  };

  home.file.".config/nvim".source = builtins.fetchGit {
    url = "https://github.com/rynsy/dotfiles";
    rev = "4283eb343424e535c87a80c9c334785273bb695e"; 
    shallow = true;
  } + "/nvim";

  home.file.".config/zsh".source = builtins.fetchGit {
    url = "https://github.com/rynsy/dotfiles";
    rev = "4283eb343424e535c87a80c9c334785273bb695e"; 
    shallow = true;
  } + "/zsh";

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ telescope-nvim nvim-treesitter ];
    extraConfig = ''
      set number relativenumber
      lua << EOF
      require("telescope").setup{}
    EOF
      '';
  };
  programs.zsh = {
    enable = true;
    initExtra = ''
        source ~/.config/zsh/.zshrc
        source ~/.config/zsh/.zshenv
        source ~/.config/zsh/.zprofile
      '';
  };
}

