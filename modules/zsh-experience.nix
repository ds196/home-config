{ pkgs, lib, ... }:
{
  programs.zsh.enable = true;
  programs.eza.enable = true;
  programs.pay-respects.enable = true;
  programs.direnv.enable = true;
  home.packages = with pkgs; [
    zsh-powerlevel10k
    zsh-nix-shell
  ];

  imports = [
    ./shell-aliases.nix
  ];

  # Shell
  programs.zsh = {
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = false;
    autosuggestion.enable = true;
    completionInit = "autoload -Uz compinit && compinit && zstyle ':completion:*' completer _expand_alias _complete _ignored _correct && zstyle ':completion:*' regular true && zstyle ':completion:*' max-errors 2 && zstyle ':completion:*' rehash true"; # Still doesn't tab-complete aliases... not sure why.
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    defaultKeymap = "viins";

    initContent =
      let
        zshConfigEarlyInit = lib.mkOrder 500 ''
          # https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#how-do-i-initialize-direnv-when-using-instant-prompt
          (( ''${+commands[direnv]} )) && emulate zsh -c "$(direnv export zsh)"

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
        zshConfig = lib.mkOrder 1000 /* sh */ ''
          # Setup cdr instead of the directory stack
          #autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
          #add-zsh-hook chpwd chpwd_recent_dirs
          #zstyle ':completion:*:*:cdr:*:*' menu selection
          #zstyle ':chpwd:*' recent-dirs-file ~/.zchpwd/chpwd-recent-dirs-''${TTY##*/} +

          # Exit shell on Ctrl+D even if the command line is filled
          exit_zsh() { exit }
          zle -N exit_zsh
          bindkey '^D' exit_zsh

          bindkey -v
          bindkey '^R' history-incremental-search-backward

          # oh-my-zsh/directories defines these for some reason, I use md as a markdown viewer
          unalias md
          unalias rd
        '';
        zshConfigAfter = lib.mkOrder 1500 /* sh */ ''
          (( ''${+commands[direnv]} )) && emulate zsh -c "$(direnv hook zsh)"  # After oh-my-zsh
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
        "z"
      ];
    };

    plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell/";
        file = "nix-shell.plugin.zsh";
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

  home.file.".p10k.ascii.zsh".source = ./.p10k.ascii.zsh;
  home.file.".p10k.vscode.zsh".source = ./.p10k.vscode.zsh;
  home.file.".p10k.uni.zsh".source = ./.p10k.uni.zsh;
  home.file.".ros2helpers.sh".source = ./.ros2helpers.sh;

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

  # Direnv
  programs.direnv = {
    nix-direnv.enable = true;
  };
}
