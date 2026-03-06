{ pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.starship.enable = true;
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
    oh-my-zsh = {
      enable = true;
      plugins = [
        "colored-man-pages"
	"colorize"
	"command-not-found"
	"copyfile"
      ];
    };
  };

  home.sessionVariables = {
    HYPHEN_INSENSITIVE = "true";
    COMPLETION_WAITING_DOTS="true";
  };

  # Prompt
  programs.starship = {
    enableZshIntegration = true;
    settings = {
      add_newline = true;
      nix_shell = {symbol = " ";};
      directory = {read_only = " 󰌾";};
      os.symbols = {
        Alpine = " ";
        Arch = " ";
	Debian = " ";
	Fedora = " ";
	Kali = " ";
	Macos = " ";
	Redhat = " ";
        Ubuntu = " ";
	Windows = "󰍲 ";
      };
      python = {symbol = " ";};
    };
  };

  # 'ls' alternative
  programs.eza = {
    enableZshIntegration = true;
    colors = "auto";
    icons = "auto";
  };
}
