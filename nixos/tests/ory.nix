import ./make-test.nix ({ pkgs, ...} : {
  name = "ory";

  nodes = {
    machine = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ ory-hydra ory-oathkeeper ory-keto ];

      # We requires at least 1GiB of free disk space to run.
      virtualisation.diskSize = 4 * 1024;
    };
  };

  testScript =
    ''
      startAll;
      $machine->succeed("hydra version");
      $machine->succeed("hydra serve all");
      $machine->succeed("oathkeeper version");
      $machine->succeed("keto version");
      $machine->shutdown;

    '';
})
