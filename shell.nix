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
          autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
          add-zsh-hook chpwd chpwd_recent_dirs
          zstyle ':completion:*:*:cdr:*:*' menu selection
          zstyle ':chpwd:*' recent-dirs-file ~/.zchpwd/chpwd-recent-dirs-''${TTY##*/} +

          # Exit shell on Ctrl+D even if the command line is filled
          exit_zsh() { exit }
          zle -N exit_zsh
          bindkey '^D' exit_zsh
        '';
        zshConfigAfter = lib.mkOrder 1500 ''
          export PAGER=bat  # Set after oh-my-zsh
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
        name = "powerlevel10k-config";
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
