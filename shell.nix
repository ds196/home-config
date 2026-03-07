{ pkgs, lib, ... }:
{
  programs.zsh.enable = true;
  home.packages = [ pkgs.zsh-powerlevel10k ];
  programs.eza.enable = true;
  programs.pay-respects.enable = true;

  imports = [
    ./shell-aliases.nix
  ];

  # Shell
  programs.zsh = {
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = false;
    autosuggestion.enable = true;
    completionInit = "autoload -Uz compinit && compinit && zstyle ':completion:*' completer _expand_alias _complete _ignored _correct && zstyle ':completion:*' regular true && zstyle ':completion:*' max-errors 2 && zstyle ':completion:*' rehash true";  # Still doesn't tab-complete aliases... not sure why.
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi

          path+="$HOME/.local/bin"
          fpath+=~/.zfunc  # python typer completions
          export ZSH_COMPDUMP=$HOME/.cache/.zcompdump-$HOST  # Just cleans up ~ a little bit
        '';
        zshConfig = lib.mkOrder 1000 ''
          # Setup cdr instead of the directory stack
          #autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
          #add-zsh-hook chpwd chpwd_recent_dirs
          #zstyle ':completion:*:*:cdr:*:*' menu selection
          #zstyle ':chpwd:*' recent-dirs-file ~/.zchpwd/chpwd-recent-dirs-''${TTY##*/} +

          # Exit shell on Ctrl+D even if the command line is filled
          exit_zsh() { exit }
          zle -N exit_zsh
          bindkey '^D' exit_zsh

          # oh-my-zsh/directories defines these for some reason, I use md as a markdown viewer
          unalias md
          unalias rd
        '';
        zshConfigAfter = lib.mkOrder 1500 ''
          export PAGER=bat  # Set after oh-my-zsh
          eval "$(register-python-argcomplete ros2)"
          eval "$(register-python-argcomplete colcon)"
          [ -f $HOME/.ros2helpers.sh ] && source $HOME/.ros2helpers.sh
          [ -f $HOME/.tmpros.sh ] && source $HOME/.tmpros.sh

          # Enforce powerlevel10k configuration depending on environment
          # To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh.
          if [ "$TERM" = "linux" ]; then
            [[ ! -f ~/.p10k.ascii.zsh ]]  || source ~/.p10k.ascii.zsh
          elif [ "$TERM_PROGRAM" = "vscode" ]; then
            [[ ! -f ~/.p10k.vscode.zsh ]] || source ~/.p10k.vscode.zsh
          else
            [[ ! -f ~/.p10k.uni.zsh ]]    || source ~/.p10k.uni.zsh
          fi
        '';
      in
      lib.mkMerge [
        zshConfigEarlyInit
        zshConfig
        zshConfigAfter
      ];

    localVariables = {
      HYPHEN_INSENSITIVE = "true";
      ZLE_RPROMPT_INDENT = 0;
      CC = "gcc";
      CXX = "g++";
      MANPAGER = "sh -c 'col -bx | bat -l man -p'";
      MANROFFOPT = "-c";
      #PAGER = "bat";  # Gets overwritten by oh-my-zsh...
    };

    oh-my-zsh = {
      enable = true;
      plugins = [
        "colored-man-pages"
        "colorize"
        "command-not-found"
        "copyfile"
	"direnv"
	"z"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k-config";  # Leaving this in just in case ig
        src = ./packages;
        file = ".p10k.uni.zsh";
      }
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];

    setOptions = [
      "EXTENDED_HISTORY"
      "HIST_IGNORE_SPACE"
      "INTERACTIVE_COMMENTS"
    ];
    shellAliases = {
      "diff" = "diff --color=auto";
      "grep" = "grep --color=auto";
      #"ls" = "ls --color=auto -h";  # Options moved to shell-aliases.nix, alias ls="eza ..."
    };

  };

  home.file.".p10k.ascii.zsh".source = packages/.p10k.ascii.zsh;
  home.file.".p10k.vscode.zsh".source = packages/.p10k.vscode.zsh;
  home.file.".p10k.uni.zsh".source = packages/.p10k.uni.zsh;
  home.file.".ros2helpers.sh".source = packages/.ros2helpers.sh;

  # 'ls' alternative
  programs.eza = {
    enableZshIntegration = true;
    colors = "auto";
    icons = "auto";
  };

  # 'thefuck' alternative
  programs.pay-respects = {
    enableZshIntegration = true;
  };
}
