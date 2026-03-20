{ pkgs, lib, ... }:
{
  programs.git.enable = true;
  programs.gh.enable = true;
  programs.difftastic.enable = true;
  programs.mergiraf.enable = true;

  programs.git = {
    package = pkgs.gitFull;
    includes = [
      {
        path = "~/.config/git/use_ssh.inc";
        contents = {
          url = {
            "ssh://git@github.com/".insteadOf = "https://github.com/";
            "ssh://gitlab.uah.edu/".insteadOf = "https://gitlab.uah.edu/";
            "ssh://gitlab.ece.uah.edu/".insteadOf = "https://gitlab.ece.uah.edu/";
          };
        };
      }
      {
        path = "~/.config/git/laptop_key.inc";
        contents = {
          signingkey = "38211C0985C4B55";
        };
      }
    ];
    settings = {
      user = {
        name = "David";
        email = "ds0196@uah.edu";
        signingkey = "38211C0985C4B55F";
      };
      init.defaultBranch = "main";
      core.pager = "${pkgs.bat}/bin/bat -p";
    };
    signing = {
      format = "openpgp";
      signByDefault = true;
    };
  };

  programs.difftastic.git.enable = true;
}
