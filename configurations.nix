{ hostname, pkgs, ... }:
{
  system.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;
  nix = {
    channel.enable = false;
    settings = {
      flake-registry = "";
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 0;
      systemd-boot = {
        enable = true;
        editor = false;
        consoleMode = "max";
      };
    };
  };

  networking = {
    hostName = hostname;
    firewall = {
      enable = true;
      checkReversePath = false;
      allowPing = false;
    };
  };

  console = {
    earlySetup = true;
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v24b.psf.gz";
    keyMap = "us";
  };

  time = {
    timeZone = "CET";
    hardwareClockInLocalTime = false;
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  users.users."armin" = {
    initialPassword = "armin";
    uid = 1000;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "podman"
    ];
  };

  environment.systemPackages = with pkgs; [
    htop
    pass
    nvme-cli
  ];
}
