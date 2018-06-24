{ }:

rec {
  config.allowUnfree = true;

  config.packageOverrides = pkgs:
    rec {
      lib = import ../../lib { inherit (pkgs) lib; };

      #pkgsLocal = import /home/mechetel/projects/nixpkgs { config = { allowUnfree = true; }; };

      callPackageFromGithubThatHasDefaultNix = revisionDataPath:
        pkgs.callPackage (
          pkgs.fetchFromGitHub (
            lib.fetchFromGitHubAttrsFromRevision revisionDataPath
          )
        );

      dunsted-volume       = pkgs.callPackage ../../pkgs/dunsted-volume {};
      randomize_background = pkgs.callPackage ../../pkgs/randomize_background {};
      switch_touchpad      = pkgs.callPackage ../../pkgs/switch_touchpad {};
      tmuxx                = pkgs.callPackage ../../pkgs/tmuxx {};

      hubstaff = import ../../pkgs/hubstaff;
    };
}
