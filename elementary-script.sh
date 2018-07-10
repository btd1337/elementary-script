#!/bin/bash

# Script checked by https://www.shellcheck.net/

zenity(){
	# Need to resolve 'GtkDialog mapped without a transient parent'
    /usr/bin/zenity "$@" 2>/dev/null
}

function checkUbuntuCodename() {
	elementary_codename=$(lsb_release -sc)
	case $elementary_codename in
		"juno") ubuntu_codename="bionic" ;;
		"loki") ubuntu_codename="xenial" ;;
		"freya") ubuntu_codename="trusty" ;;
	*) ubuntu_codename=$(lsb_release -sc);;
esac
}

function installPackage() {
		local name=$1
		local package
		package=$(dpkg --get-selections | grep "$name" )
		echo "Verifying that the $name package is already installed"
		echo "$package"
		if [ -n "$package" ] ;
		then echo
		     printf "Package %s is already installed.\\n" "$name"
		else echo
		     echo "Package $name required-> Not installed"
		     echo "Automatically installing the package.."
		     sudo apt -y install "$name"
		fi
}

function addRepository() {
	local repository=$1
	local ppa="ppa:${repository}"

	if ! grep -q "^deb .*$repository" /etc/apt/sources.list /etc/apt/sources.list.d/*; 
	then
		installPackage software-properties-common	# it's necessary to add ppas

		addRepositoryMessage "${ppa}"
		sudo add-apt-repository -y "$ppa"
		sleep 5  # Waits 5 seconds.
		sudo apt update
	fi
}

function addRepositoryMessage() {
	local repository=$1
	printf "Adding Repository %s\\n\\n" "$repository"
}

function printInstallMessage() {
	local msg=$1

	printf "\\n\\n====================\\t%s    ===================\\n\\n" "${msg}"
	notify-send -i utilities-terminal elementary-script "${msg}"
}

function printMessage() {
	local msg=$1

	printf "\\n\\n%s\\n\\n" "${msg}"
	notify-send -i utilities-terminal elementary-script "${msg}"
}

function errorMessage() {
	zenity --error --text="${1}" --ellipsize
}

function notImplementedErrorMessage() {
	errorMessage "This action($1) wasn't implemented yet"
}

function ExtraMessages() {
	printMessage "If this script has helped you, consider making a small donation to keep the project running at all times."
	xdg-open http://bit.do/elementary-script_donation
	printMessage "Follow me on Github to receive updates and news ;)"
	xdg-open https://github.com/btd1337
}

function InstallElementaryIconPack() {
	installPackage meson

	printInstallMessage "Installing elementaryOS Icons"
	sudo git clone https://github.com/elementary/icons /usr/share/icons/elementary
	cd /usr/share/icons/elementary || exit
	cp elementary.gpl ~/.config/inkscape/palettes/
	cp pre-commit .git/hooks/
	sudo chmod +x .git/hooks/pre-commit

	sudo meson build --prefix=/usr
	cd build
	sudo ninja install
}

function isElementaryOS() {
	local distributorId
	distributorId = $(lsb_release -si)

	if [ "$distributorId" != "elementary" ]; then 
    	errorMessage "This feature works correctly only on elementary OS" 
		return 0
	else
		return 1  
	fi;
}

function main() {
	clear
	checkUbuntuCodename

	#Install x11-utils, we need xwininfo for auto adjust window
	installPackage x11-utils

	#define the height in px of the top system-bar and sum in px of all horizontal borders:
	TOPMARGIN=27
	RIGHTMARGIN=10

	# get width of screen and height of screen
	SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
	SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')

	# new width and height
	W=$(( SCREEN_WIDTH / 1 - RIGHTMARGIN ))
	H=$(( SCREEN_HEIGHT - 2 * TOPMARGIN ))

	# Zenity
	GUI=$(zenity --list --checklist \
		--height $H \
		--width $W \
		--name="elementary 0.4.1 post-install script" \
		--title="elementary 0.4.1 post-install script" \
		--text "Pick one or multiple Actions to execute" \
		--column=Picks --column=Actions --column=Description \
		TRUE "Update System" "Updates the package lists, the system packages and Applications"  \
		TRUE "Enable PPAs" "Another extra layer of security and another level of annoyance. You cannot add PPA by default in Loki" \
		FALSE "Install Elementary Tweaks" "Installing themes in elementary OS is a much easier task thanks to elementary Tweaks tool" \
		FALSE "Install Urutau Icons" "The most complete package of icons for third-party applications with elementary OS design" \
		FALSE "Install Elementary X" "Original elementary theme with some tweaks and OS X window controls" \
		FALSE "Install Brave Browser" "Browse faster by blocking ads and trackers that violate your privacy and cost you time and money" \
		FALSE "Install Chromium" "An open-source browser project that aims to build a safer, faster, and more stable way for all Internet users to experience the web" \
		FALSE "Install Firefox" "A free and open-source web browser" \
		FALSE "Install Google Chrome" "A browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier" \
		FALSE "Install Opera" "Fast, secure, easy-to-use browser" \
		FALSE "Install Support for Archive Formats" "Installs support for archive formats(.zip, .rar, .p7)" \
		FALSE "Fix keyboard accents on latin keyboard" "Autostart ibus-daemon, you may want to check it if you're having issues with accents on Qt apps (Telegram, WPS Office, ...)" \
		FALSE "Add Oibaf Repository" "This repository contain updated and optimized open graphics drivers" \
		FALSE "Install Gufw Firewall" "Gufw is an easy and intuitive way to manage your linux firewall" \
		FALSE "Install Startup Disk Creator" "Startup Disk Creator converts a USB key or SD card into a volume from which you can start up and run OS Linux" \
		FALSE "Install GDebi" "Installs GDebi. A simple tool to install deb files" \
		FALSE "Install Skype" "Video chat, make international calls, instant message and more with Skype" \
		FALSE "Install Telegram" "Telegram is a cloud-based instant messaging and voice over IP service" \
		FALSE "Install Dropbox" "Installs Dropbox with wingpanel support. Dropbox is a free service that lets you bring your photos, docs, and videos anywhere and share them easily" \
		FALSE "Install Liferea" "A web feed reader/news aggregator that brings together all of the content from your favorite subscriptions into a simple interface that makes it easy to organize and browse feeds. Its GUI is similar to a desktop mail/newsclient, with an embedded graphical browser" \
		FALSE "Install Klavaro" "Klavaro it's a free touch typing tutor program" \
		FALSE "Install VLC" "A free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols" \
		FALSE "Install Clementine Music Player" "One of the Best Music Players and library organizer on Linux" \
		FALSE "Install Gimp" "GIMP is an advanced picture editor. You can use it to edit, enhance, and retouch photos and scans, create drawings, and make your own images" \
		FALSE "Install Deluge" "Deluge is a lightweight, Free Software, cross-platform BitTorrent client" \
		FALSE "Install Transmission" "Installs the Transmission BitTorrent client" \
		FALSE "Install Atom" "A hackable text editor for the 21st Century" \
		FALSE "Install Sublime Text 3" "A sophisticated text editor for code, markup and prose" \
		FALSE "Install VS Code" "Visual Studio Code is a code editor redefined and optimized for building and debugging modern web and cloud applications" \
		FALSE "Install LibreOffice" "A powerful office suite" \
		FALSE "Install WPS Office" "The most compatible free office suite" \
		FALSE "Install Steam" "Steam is one of the most popular digital game download stores" \
		FALSE "Install TLP" "Install TLP to save battery and prevent overheating" \
		FALSE "Install Redshift" "Use night shift to save your eyes" \
		FALSE "Install Disk Utility" "Gnome Disk Utility is a tool to manage disk drives and media" \
		FALSE "Install Brasero" "A CD/DVD burning application for Linux" \
		FALSE "Install Spotify" "A desktop software to listen music by streaming with the possibility to create and share playlists" \
		FALSE "Install Ubuntu Restricted Extras" "Installs commonly used applications with restricted copyright (mp3, avi, mpeg, TrueType, Java, Flash, Codecs)" \
		FALSE "Intall Grub Customizer" "Grub Customizer is a graphical tool for managing the Grub boot entries" \
		TRUE "Fix Broken Packages" "Fixes the broken packages" \
		TRUE "Clean-Up Junk" "Removes unnecessary packages and the local repository of retrieved package files" \
		--separator=', ');

		if ( parse_opt "$GUI" ); then
			# Notification
			printf "\\n\\nAll tasks ran successfully!\\n\\nDiscover more native applications for elementary OS at: https://github.com/kleinrein/awesome-elementaryos\\n\\n"
			notify-send -i utilities-terminal elementary-script "All tasks ran successfully!\\n\\nDiscover more native applications for elementary OS at:\\n\\nhttps://github.com/kleinrein/awesome-elementaryos"
			ExtraMessages
		else
			return 1
		fi
}

function parse_opt() {
	opt="$*"

	# Update System Action
	if [[ $opt == *"Update System"* ]]
	then
		printInstallMessage "Updating System"
		sudo apt -y update
		sudo apt -y full-upgrade
		sleep 5  # Waits 5 seconds.
	fi

	# Enable PPAs
	if [[ $opt == *"Enable PPAs"* ]]
	then
		printInstallMessage "Enabling PPAs"
		installPackage software-properties-common
	fi

	# Install Elementary Tweaks Action
	if [[ $opt == *"Install Elementary Tweaks"* ]]
	then
		if [ isElementaryOS ];
		then
			printInstallMessage "Installing Elementary Tweaks"
			addRepository philip.scott/elementary-tweaks
			installPackage elementary-tweaks
		fi
	fi

	# Install  Urutau Icons
	if [[ $opt == *"Install Urutau Icons"* ]]
	then
		if [ isElementaryOS ];
		then
			installPackage git

			directoryElementary=/usr/share/icons/elementary
			directoryUrutau=/usr/share/icons/urutau-icons

			if [ ! -d "$directoryElementary" ];	#Verifying if directory don't exists
			then
				InstallElementaryIconPack
			fi

			if [ -d "$directoryUrutau" ];	#Verifying if directory exists
			then
				printInstallMessage "The icon-pack already installed. They will be updated now"
				cd $directoryUrutau || exit
				sudo git pull
			else
				printInstallMessage "Installing Urutau Icons"
				sudo git clone https://github.com/btd1337/urutau-icons $directoryUrutau
			fi
			gsettings set org.gnome.desktop.interface icon-theme "urutau-icons"
		fi
	fi

	# Install Elementary x
	if [[ $opt == *"Install Elementary X"* ]]
	then
		if [ isElementaryOS ];
		then
			installPackage git

			directory=/usr/share/themes/elementary-x
			if [ -d "$directory" ];	#Verifying if directory exists
			then
				printInstallMessage "The theme already installed. They will be updated now"
				cd $directory || exit
				sudo git pull
			else
				printInstallMessage "Installing elementary-x Theme"
				sudo git clone https://github.com/surajmandalcell/elementary-x.git /usr/share/themes/elementary-x
			fi
			gsettings set org.gnome.desktop.interface gtk-theme 'elementary-x'
			printInstallMessage "For enable minimize button, install Elementary Tweaks. After go to System Settings > Elementary Tweaks > Button Layout: OS X and enjoy"
		fi
	fi

	# Install Brave Browser
	if [[ $opt == *"Install Brave Browser"* ]]
	then
		printInstallMessage "Installing Brave Browser"
		if [[ $(uname -m) == "i686" ]]
		then
			printInstallMessage "Brave Browser does not support 32 bits" 
		elif [[ $(uname -m) == "x86_64" ]]
		then
			local repository="brave-${ubuntu_codename}"

			if [ ! -e /etc/apt/sources.list.d/${repository}.list ] 
			then
				addRepositoryMessage "${repository}"
				curl https://s3-us-west-2.amazonaws.com/brave-apt/keys.asc | sudo apt-key add -
				echo "deb [arch=amd64] https://s3-us-west-2.amazonaws.com/brave-apt ${ubuntu_codename} main" | sudo tee -a /etc/apt/sources.list.d/brave-${ubuntu_codename}.list
				sleep 5 # Waits 5 seconds
				sudo apt update
			fi
			installPackage brave
		fi
	fi

	# Install Chromium
	if [[ $opt == *"Install Chromium"* ]]
	then
		printInstallMessage "Installing Chromium"
		installPackage chromium-browser
	fi

	# Install Firefox
	if [[ $opt == *"Install Firefox"* ]]
	then
		printInstallMessage "Installing Firefox"
		installPackage firefox
	fi

	# Install Google Chrome
	if [[ $opt == *"Install Google Chrome"* ]]
	then
		printInstallMessage "Installing Google Chrome" 
		wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
	fi

	# Install Opera
	if [[ $opt == *"Install Opera"* ]]
	then
		printInstallMessage "Installing Opera"
		
		local repository="opera-stable"

		if [ ! -e /etc/apt/sources.list.d/${repository}.list ] 
		then
			addRepositoryMessage $repository

			wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
			sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free' -y
			sleep 5 # Waits 5 seconds
			sudo apt update
		fi
		installPackage opera-stable
	fi

	# Install Support for Archive Formats Action
	if [[ $opt == *"Install Support for Archive Formats"* ]]
	then
		printInstallMessage "Installing Support for Archive Formats"
		installPackage zip
		installPackage unzip
		installPackage p7zip
		installPackage p7zip-rar
		installPackage rar
		installPackage unrar
	fi

	# Fix keyboard accents
	if [[ $opt == *"Fix keyboard accents on latin keyboard"* ]]
	then
		printInstallMessage "Setting up ibus daemon"
		cd "$HOME" || exit
		if [ ! -e .xprofile ]; then
			echo "Creating .xprofile"
			touch ~/.xprofile
		fi
		#if [ ! -z $(grep "ibus-daemon -drx" ".xprofile") ]; then
		if (cat < .xprofile | grep "ibus-daemon -drx">/dev/null); then
			echo "ibus-daemon already start up on login!"
		else
			echo "ibus-daemon -drx" >> ~/.xprofile
		fi
	fi

	# Add Oibaf Repository
	if [[ $opt == *"Add Oibaf Repository"* ]]
	then
		printInstallMessage "Adding Oibaf Repository and updating" 
		addRepository oibaf/graphics-drivers
		sudo apt -y full-upgrade
	fi

	# Install Gufw Firewall Action
	if [[ $opt == *"Install Gufw Firewall"* ]]
	then
		printInstallMessage "Installing Gufw Firewall"
		installPackage gufw
	fi

	# Install Startup Disk Creator
	if [[ $opt == *"Install Startup Disk Creator"* ]]
	then
		printInstallMessage "Installing Startup Disk Creator"
		installPackage usb-creator-gtk
	fi

	# Install GDebi Action
	if [[ $opt == *"Install GDebi"* ]]
	then
		printInstallMessage "Installing GDebi"
		installPackage gdebi
	fi

	# Install Thunderbird Action
	if [[ $opt == *"Replace Pantheon Mail by the Thunderbird Mail"* ]]
	then
		printInstallMessage "Removing Pantheon Mail"
		sudo apt --purge remove -y pantheon-mail
		printInstallMessage "Installing Thunderbird"
		installPackage thunderbird
	fi

	# Install Skype
	if [[ $opt == *"Install Skype"* ]]
	then
		printInstallMessage "Installing Skype"
		if [[ $(uname -m) == "i686" ]]
		then
			wget -O /tmp/skype.deb https://download.skype.com/linux/skype-ubuntu-precise_4.3.0.37-1_i386.deb
			sudo dpkg -i /tmp/skype.deb
		elif [[ $(uname -m) == "x86_64" ]]
		then
			installPackage apt-transport-https

			local repository="skype-stable"

			if [ ! -e /etc/apt/sources.list.d/${repository}.list ]
			then
				addRepositoryMessage $repository

				wget -q -O - https://repo.skype.com/data/SKYPE-GPG-KEY | sudo apt-key add -
				echo "deb https://repo.skype.com/deb stable main" | sudo tee /etc/apt/sources.list.d/skypeforlinux.list
				sleep 5 # Waits 5 seconds
				sudo apt update
				sudo rm /etc/apt/sources.list.d/skypeforlinux.list	# prevent duplicate
			fi
			installPackage skypeforlinux
		fi
		sudo apt -f install -y
	fi

	# Install Telegram Action
	if [[ $opt == *"Install Telegram"* ]]
	then
		printInstallMessage "Installing Telegram"
		addRepository atareao/telegram
		installPackage telegram
	fi

	# Install Dropbox Action
	if [[ $opt == *"Install Dropbox"* ]]
	then
		printInstallMessage "Installing Drobox"
		if [ isElementaryOS ];
		then
			installPackage git
			sudo apt --purge remove -y dropbox*
			installPackage python-gpgme
			git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
			sudo bash /tmp/elementary-dropbox/install.sh
		else
			installPackage dropbox
		fi
	fi

	# Install Liferea Action
	if [[ $opt == *"Install Liferea"* ]]
	then
		printInstallMessage "Installing Liferea"
		installPackage liferea
	fi

	# Install Klavaro Action
	if [[ $opt == *"Install Klavaro"* ]]
	then
		printInstallMessage "Installing Klavaro"
		installPackage klavaro
	fi

	# Install VLC Action
	if [[ $opt == *"Install VLC"* ]]
	then
		printInstallMessage "Installing VLC"
		installPackage vlc
	fi

	# Install Clementine Action
	if [[ $opt == *"Install Clementine Music Player"* ]]
	then
		printInstallMessage "Installing Clementine Music Player"
		installPackage clementine
	fi

	# Install Gimp Action
	if [[ $opt == *"Install Gimp"* ]]
	then
		printInstallMessage "Installing Gimp Image Editor"
		installPackage gimp
	fi

	# Install Deluge Action
	if [[ $opt == *"Install Deluge"* ]]
	then
		printInstallMessage "Installing Deluge"
		installPackage deluge
	fi

	# Install Transmission Action
	if [[ $opt == *"Install Transmission"* ]]
	then
		printInstallMessage "Installing Transmission"
		installPackage transmission
	fi

	# Install Atom Action
	if [[ $opt == *"Install Atom"* ]]
	then
		printInstallMessage "Installing Atom"
		addRepository webupd8team/atom
		installPackage atom
	fi

	# Install Sublime Text 3 Action
	if [[ $opt == *"Install Sublime Text 3"* ]]
	then
		printInstallMessage "Installing Sublime Text 3"
	  	addRepository webupd8team/sublime-text-3
		installPackage sublime-text-installer
	fi

	# Install VS Code Action
	if [[ $opt == *"Install VS Code"* ]]
	then
		printInstallMessage "Installing VS Code"
		if [[ $(uname -m) == "i686" ]]
		then
			wget -O /tmp/vscode.deb https://go.microsoft.com/fwlink/?LinkID=760680
			sudo dpkg -i /tmp/vscode.deb
			sudo apt install -f
		elif [[ $(uname -m) == "x86_64" ]]
		then
			local repository="vscode"

			if [ ! -e /etc/apt/sources.list.d/${repository}.list ]
			then
				addRepositoryMessage $repository

				curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
				sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
				sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
				sleep 5 # Waits 5 seconds
				sudo apt update
				sudo apt upgrade
				sudo apt update
			fi
			installPackage code
		fi
	fi

	# Install LibreOffice Action
	if [[ $opt == *"Install LibreOffice"* ]]
	then
		printInstallMessage "Installing LibreOffice"
		installPackage libreoffice
	fi

	# Install WPS Office
	if [[ $opt == *"Install WPS Office"* ]]
	then
		printInstallMessage "Installing WPS Office"
		if [[ $(uname -m) == "i686" ]]
		then
			wget -O /tmp/wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_i386.deb
			sudo dpkg -i /tmp/wps-office.deb
		elif [[ $(uname -m) == "x86_64" ]]
		then
			wget -O /tmp/wps-office.deb http://kdl1.cache.wps.com/ksodl/download/linux/a21//wps-office_10.1.0.5707~a21_amd64.deb
			sudo dpkg -i /tmp/wps-office.deb
		fi
		#Fonts, Interface Translate, Dictionary
		wget -O /tmp/wps-office-fonts.deb http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
		wget -O /tmp/wps-office-ul.deb http://repo.uniaolivre.com/packages/xenial/wps-office-ul_10.1.0.5503-0kaiana05052016_all.deb
		wget -O /tmp/wps-office-language-all.deb https://raw.githubusercontent.com/btd1337/elementary-script/master/files/wps-office-language-all_0.1_all.deb
		sudo dpkg -i /tmp/wps-office-fonts.deb
		sudo dpkg -i /tmp/wps-office-ul.deb
		sudo dpkg -i /tmp/wps-office-language-all.deb
		sudo apt -y -f install
	fi

	# Install Steam
	if [[ $opt == *"Install Steam"* ]]
	then
		printInstallMessage "Installing Steam"
		installPackage steam
	fi

	# Install TLP
	if [[ $opt == *"Install TLP"* ]]
	then
		printInstallMessage "Installing TLP"
		sudo apt --purge remove -y laptop-mode-tools	#Avoid conflict with TLP
		installPackage tlp
		installPackage tlp-rdw
	fi

	# Install Redshift Action
	if [[ $opt == *"Install Redshift"* ]]
	then
		printInstallMessage "Installing Redshift"
		installPackage redshift-gtk
	fi

	# Install Gnome Disk Utility Action
	if [[ $opt == *"Install Disk Utility"* ]]
	then
		printInstallMessage "Installing Gnome Disk Utility"
		installPackage gnome-disk-utility
	fi

	# Install Brasero Action
	if [[ $opt == *"Install Brasero"* ]]
	then
		printInstallMessage "Installing Brasero"
		installPackage brasero
	fi

	# Install Spotify Action
	if [[ $opt == *"Install Spotify"* ]]
	then
		printInstallMessage "Installing Spotify"

		local repository="spotify"

		if [ ! -e /etc/apt/sources.list.d/${repository}.list ] 
		then
			addRepositoryMessage $repository

			sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EFDC8610341D9410
			echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
			sudo apt-get update
		fi
		installPackage spotify-client
	fi

	# Install Ubuntu Restricted Extras Action
	if [[ $opt == *"Install Ubuntu Restricted Extras"* ]]
	then
		printInstallMessage "Installing Ubuntu Restricted Extras"
		installPackage ubuntu-restricted-extras
	fi

	# Install Grub Customizer Action
	if [[ $opt == *"Install Grub Customizer"* ]]
	then
		printInstallMessage "Installing Grub Customizer"
		addRepository danielrichter2007/grub-customizer
		installPackage grub-customizer
	fi

	# Fix Broken Packages Action
	if [[ $opt == *"Fix Broken Packages"* ]]
	then
		printInstallMessage "Fixing the broken packages"
		sudo apt -y -f install
	fi

	# Clean-Up Junk Action
	if [[ $opt == *"Clean-Up Junk"* ]]
	then
		printInstallMessage "Cleaning-up junk"
		sudo apt -y autoremove
		sudo apt -y autoclean
	fi
}

main
