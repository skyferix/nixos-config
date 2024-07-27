{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
    sha256 = "0c83di08nhkzq0cwc3v7aax3x8y5m7qahyzxppinzwxi3r8fnjq3";
  };
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.skyferix = {
    home.stateVersion = "24.05";
    programs.git = {
      enable = true;
      userName  = "Skyferix";
      userEmail = "skyferix-sky@gmail.com";
      aliases = {
        pushfwl = "push --force-with-lease";
      };
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
    };
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
        # Load __git_ps1 bash command.
        . ~/.nix-profile/share/git/contrib/completion/git-prompt.sh
        # Also load git command completions for bash.
        . ~/.nix-profile/share/git/contrib/completion/git-completion.bash

        # Show git branch status in terminal shell.
        # export PS1='\[\033[01;34m\]\w\[\033[00m\]\[\033[01;32m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
        export PS1='\n\[\033[$PROMPT_COLOR\]\u@\h:\[\033[01;34m\]\w\[\033[01;31m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ '
      '';
    };
  };
}
