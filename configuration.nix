#Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #./vm.nix
      inputs.xremap-flake.nixosModules.default
    ];

  # Bootloader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "nodev" ];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
boot.kernelPackages = pkgs.linuxPackages_latest;

hardware.bluetooth.enable=true;
hardware.bluetooth.powerOnBoot=true;
hardware.bluetooth.settings = {
	General = {
		Name = "Hello";
		ControllerMode = "dual";
		FastConnectable = "true";
		Experimental = "true";
	};
};

  networking.hostName = "machine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
networking.wireless.networks = {
	TELUSF32F = {
		psk = "Tommywu1989";
	};
};

networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
services.resolved = {
	enable = true;
	dnssec = "true";
	domains = ["~."];
	fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one"];
	dnsovertls="true";
	};


  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

fonts = {
	enableDefaultPackages = true;
	packages = with pkgs; [
		unifont
		vt323
		tamsyn
		jetbrains-mono
	];
	fontconfig = {
		defaultFonts = {
			sansSerif = [ "tamsyn" ];
		};
	};
};

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

services.xremap = {
	withHypr = true;
	userName = "admin";
	yamlConfig = ''
modmap:
  - name: main remaps
    remap:
      capslock: leftctrl 
      slash:
        held: backslash
        alone: slash
        alone_timeout_millis: 150
'';
};

virtualisation.libvirtd.enable=true;
programs.virt-manager.enable=true;
virtualisation.spiceUSBRedirection.enable=true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.admin = {
    isNormalUser = true;
    description = "Admin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "vboxusers" "boinc" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
programs.hyprland.enable = true;
programs.zsh.enable = true;
programs.thunar.enable = true;
programs.steam = {
	enable = true;
	package = pkgs.steam.override{
		extraLibraries = pkgs: [pkgs.xorg.libxcb];
		extraPkgs = pkgs:
			with pkgs; [
				attr
				xorg.libXcursor
				xorg.libXi
				xorg.libXinerama
				xorg.libXScrnSaver
				libpng
				libpulseaudio
				libvorbis
				stdenv.cc.cc.lib
				libkrb5
				keyutils
				gamemode
			];
		};
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
};
programs.steam.gamescopeSession.enable = true;
programs.gamemode.enable = true;
hardware.graphics = {
	enable=true;
	enable32Bit = true;
};
programs.thunderbird.enable = true;
services.xserver.videoDrivers = ["amdgpu"];
# Allow unfree packages
  nixpkgs.config.allowUnfree = true;

hardware.uinput.enable = true;
users.groups.uinput.members = [ "admin" ];
users.groups.input.members = [ "admin" ];

programs.partition-manager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
wget
git
neovim
kitty
pkgs.waybar
pkgs.blueman
pkgs.font-awesome
pkgs.dunst
pkgs.networkmanagerapplet
pkgs.pavucontrol
pkgs.hyprpaper
pkgs.hyprwall
pkgs.swww
pkgs.mangohud
pkgs.vscode
pkgs.spotify
pkgs.bitwarden-desktop
pkgs.discord
pkgs.wineWowPackages.waylandFull
pkgs.thunderbird-latest-unwrapped
pkgs.grim
pkgs.slurp
pkgs.wl-clipboard
pkgs.tofi
pkgs.libreoffice-qt
pkgs.librewolf
pkgs.boinc
pkgs.vlc
pkgs.qbittorrent-enhanced
pkgs.qimgv
pkgs.quickemu
pkgs.os-prober
pkgs.lshw-gui
htop
unzip
waypaper
hyprpanel
#Hyprpanel
meson
ags
gjs
ninja
vesktop
pywal
nodejs_23
muse-sounds-manager
gcc
clang
libclang
lua-language-server
unrar
speedtest-cli
desktop-file-utils
];

xdg.portal.enable = true;
xdg.menus.enable = true;

xdg.mime = {
	enable = true;
	defaultApplications = {
		"image/png" = [ "qimgv.desktop" ];
	};
};

programs.appimage = {
	enable = true;
	binfmt = true;
};

virtualisation.virtualbox.host.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
nix.settings.experimental-features = [ "nix-command" "flakes"];

}
