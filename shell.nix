{ pkgs, lib, ... }:
{
  programs.zsh.enable = true;
  home.packages = [ pkgs.zsh-powerlevel10k ];
  programs.eza.enable = true;

  # Shell
  programs.zsh = {
    enableCompletion = true;
    enableVteIntegration = true;
    autocd = false;
    autosuggestion.enable = true;
    completionInit = "zstyle ':completion:*' completer _expand_alias _complete _ignored _correct && zstyle ':completion:*' max-errors 2 && autoload -Uz compinit && compinit";
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
	'';
        zshConfig = lib.mkOrder 1000 ""; 
      in
        lib.mkMerge [ zshConfigEarlyInit zshConfig ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        "colored-man-pages"
	"colorize"
	"command-not-found"
	"copyfile"
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

  };

  home.sessionVariables = {
    HYPHEN_INSENSITIVE = "true";
    COMPLETION_WAITING_DOTS="true";
  };

  # 'ls' alternative
  programs.eza = {
    enableZshIntegration = true;
    colors = "auto";
    icons = "auto";
  };
}
