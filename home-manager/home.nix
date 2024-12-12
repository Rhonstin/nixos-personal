{ config, pkgs, ... }:

{
	home.username = "devops";
	home.homeDirectory = "/home/devops";
 	home.packages = with pkgs; [
  		fastfetch #os-info
  		mc #file-manager
 		
		#archivators
		zip
		xz
		unzip
		p7zip

		#sys-utils
		ripgrep
		jq
		yq-go
		eza
		fzf

		#network-utils
		mtr
		iperf3
		dnsutils
		ldns
		aria2
		socat
		nmap
		ipcalc

		#basic-utils
		cowsay
		file
		which
		tree
		gnused
		gnutar
		gawk
		zstd
		gnupg
   
		#?
		nix-output-monitor
		hugo
		glow

		#resurch monitor
		btop
		iotop
		iftop
    
		strace
		ltrace
		lsof

		sysstat
		lm_sensors
		ethtool
		pciutils
		usbutils
	];

	programs.git = {
		enable = true;
  		userName = "Bohdan";
  		userEmail = "rhonstin@gmail.com";
 	};

 	programs.starship = {
		enable = true;
  		settings = {
   			add_newline = false;
   			aws.disabled = true;
			gcloud.disabled = true;
			line_break.disabled = true;
  		};
	};

	programs.bash = {
		enable = true;
		enableCompletion = true;
		bashrcExtra = ''
			export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
		'';
	};
	
	home.stateVersion = "24.11";
	programs.home-manager.enable = true;
}

