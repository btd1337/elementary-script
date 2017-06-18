#!/bin/bash

function installPackage() {
		local name=$1
		package=$(dpkg --get-selections | grep "$name" )
		echo "Verifying that the $name package is installed."
		echo "$package"
		if [ -n "$package" ] ;
		then echo
		     echo "Package $name is already installed."
		else echo
		     echo "Package $name required-> Not installed"
		     echo "Automatically installing the package..."
		     sudo apt -y install $name
		fi
}

function addRepository() {
	# repository=$1
	# sudo apt-add-repository -r $repository -y    #remove if already installed
	# sudo apt update
	# sudo add-apt-repository -y $repository
	# sudo apt update
	echo "$1 couldn'n be added due to ppa being disabled"
}

function error_msg() {
	zenity --error --text="${1}" --ellipsize
}

function ppa_error_msg() {
	error_msg "The package $1 couldn't be installed\nWe disabled any package that use ppa's for now."
}

function not_implemented_error_msg() {
	error_msg "This action($1) wasn't implemented yet."
}

function main() {
	#Install x11-utils, we need xwininfo for auto adjust window
	installPackage x11-utils

	#define the height in px of the top system-bar and sum in px of all horizontal borders:
	TOPMARGIN=27
	RIGHTMARGIN=10

	# get width of screen and height of screen
	SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
	SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')

	# new width and height
	W=$(( $SCREEN_WIDTH / 1 - $RIGHTMARGIN ))
	H=$(( $SCREEN_HEIGHT - 2 * $TOPMARGIN ))

	# Zenity
	GUI=$(zenity --list --checklist \
		--height $H \
		--width $W \
		--name="elementary 0.4.1 post-install script" \
		--title="elementary 0.4.1 post-install script" \
		--text "Pick one or multiple Actions to execute." \
		--column=Picks --column=Actions --column=Description \
		FALSE "Fix keyboard accents on latin keyboard" "Autostart ibus-daemon, you may want to check it if you're having issues with accents on Qt apps" \
		FALSE "Fix screenshot shortcut" "Set screenshot shortcuts keys, check this if the screenshot keys aren't working as they should" \
		FALSE "Update System" "Updates the package lists, the system packages and Applications."  \
		FALSE "Install Support for Archive Formats" "Installs support for archive formats(.zip, .rar, .p7)." \
		FALSE "Enable PPAs" "Another extra layer of security and another level of annoyance. You cannot add PPA by default in Loki." \
		FALSE "Install Elementary Tweaks" "Installing themes in elementary OS is a much easier task thanks to elementary Tweaks tool." \
		FALSE "Install Elementary Full Icon Theme" "Installs Elementary Full Icon Theme. A mega pack of icons for elementary OS." \
		FALSE "Add Oibaf Repository" "This repository contain updated and optimized open graphics drivers." \
		FALSE "Install Gufw Firewall" "Gufw is an easy and intuitive way to manage your linux firewall." \
		FALSE "Install Startup Disk Creator" "Startup Disk Creator converts a USB key or SD card into a volume from which you can start up and run OS Linux" \
		FALSE "Install GDebi" "Installs GDebi. A simple tool to install deb files." \
		FALSE "Install Google Chrome" "Installs Google Chrome 64bits. A browser that combines a minimal design with sophisticated technology to make the web faster, safer, and easier." \
		FALSE "Install Chromium" "Installs Chromium. An open-source browser project that aims to build a safer, faster, and more stable way for all Internet users to experience the web." \
		FALSE "Install Opera" "Installs Opera. Fast, secure, easy-to-use browser" \
		FALSE "Install Firefox" "Installs Firefox. A free and open-source web browser." \
		FALSE "Install Skype" "Video chat, make international calls, instant message and more with Skype." \
		FALSE "Install Dropbox" "Installs Dropbox with wingpanel support. Dropbox is a free service that lets you bring your photos, docs, and videos anywhere and share them easily." \
		FALSE "Install Liferea" "Installs Liferea. a web feed reader/news aggregator that brings together all of the content from your favorite subscriptions into a simple interface that makes it easy to organize and browse feeds. Its GUI is similar to a desktop mail/newsclient, with an embedded graphical browser." \
		FALSE "Install Go For It!" "Go For It! is a simple and stylish productivity app, featuring a to-do list, merged with a timer that keeps your focus on the current task." \
		FALSE "Install Klavaro" "Installs the Klavaro a free touch typing tutor program." \
		FALSE "Install VLC" "Installs VLC. A free and open source cross-platform multimedia player and framework that plays most multimedia files as well as DVDs, Audio CDs, VCDs, and various streaming protocols." \
		FALSE "Install Clementine Music Player" "Installs Clementine. One of the Best Music Players and library organizer on Linux." \
		FALSE "Install Gimp" "GIMP is an advanced picture editor. You can use it to edit, enhance, and retouch photos and scans, create drawings, and make your own images." \
		FALSE "Install Deluge" "Deluge is a lightweight, Free Software, cross-platform BitTorrent client." \
		FALSE "Install Transmission" "Installs the Transmission BitTorrent client." \
		FALSE "Install Atom" "Installs Atom. A hackable text editor for the 21st Century." \
		FALSE "Install Sublime Text 3" "Installs Sublime Text 3. A sophisticated text editor for code, markup and prose." \
		FALSE "Install LibreOffice" "Installs LibreOffice. A powerful office suite." \
		FALSE "Install WPS Office" "Installs WPS Office. The most compatible free office suite." \
		FALSE "Install TLP" "Install TLP to save battery and prevent overheating." \
		FALSE "Install Redshift" "Use night shift to save your eyes." \
		FALSE "Install Disk Utility" "Gnome Disk Utility is a tool to manage disk drives and media." \
		FALSE "Install Brasero" "A CD/DVD burning application for Linux" \
		FALSE "Install Spotify" "A desktop software to listen music by streaming with the possibility to create and share playlists.." \
		FALSE "Install Ubuntu Restricted Extras" "Installs commonly used applications with restricted copyright (mp3, avi, mpeg, TrueType, Java, Flash, Codecs)." \
		FALSE "Fix Broken Packages" "Fixes the broken packages." \
		FALSE "Clean-Up Junk" "Removes unnecessary packages and the local repository of retrieved package files." \
		--separator=', ');

		if ( parse_opt $GUI ); then
			# Notification
			notify-send -i utilities-terminal elementary-script "All tasks ran successfully!"
		else
			return 1
		fi
}

function parse_opt() {
	opt="$*"

	if [[ $opt == *"Fix keyboard accents on latin keyboard"* ]]
	then
		echo "Setting up ibus daemon..."
		if !(test -e ~/.xprofile); then
			touch ~/.xprofile
		fi
		if (cat ~/.xprofile | grep "ibus">/dev/null); then
			echo "ibus-daemon already start up on login"
		else
			echo "ibus-daemon -drx" >> ~/.xprofile
		fi
	fi

	if [[ $opt == *"Fix screenshot shortcut"* ]]
	then
		not_implemented_error_msg "Fix screenshot shortcut"
	fi

	# Update System Action
	if [[ $opt == *"Update System"* ]]
	then
		echo "Updating system..."
		sudo apt -y update
		sudo apt -y full-upgrade
	fi

	# Enable PPAs
	if [[ $opt == *"Enable PPAs"* ]]
	then
		echo "Enabling PPAs..."
		installPackage software-properties-common
	fi

	# Install Elementary Tweaks Action
	if [[ $opt == *"Install Elementary Tweaks"* ]]
	then
		echo "Installing Elementary Tweaks..."
		# addRepository ppa:philip.scott/elementary-tweaks
		# installPackage elementary-tweaks
		ppa_error_msg "Elementary Tweaks"
	fi

	# Install  Elementary Full Icon Theme
	if [[ $opt == *"Install Elementary Full Icon Theme"* ]]
	then
		installPackage git

		directory=/usr/share/icons/elementary-full-icon-theme
		if [ -d "$directory" ];	#Verifying if directory exists
		then
			echo "The icon-pack already installed. They will be updated now..."
	  	cd /usr/share/icons/elementary-full-icon-theme
			git pull
		else
			echo "Installing Elementary Full Icon Theme..."
			git clone https://github.com/btd1337/elementary-full-icon-theme
			sudo mv elementary-full-icon-theme /usr/share/icons/
		fi
		gsettings set org.gnome.desktop.interface icon-theme "elementary-full-icon-theme"
	fi

	# Add Oibaf Repository
	if [[ $opt == *"Add Oibaf Repository"* ]]
	then
		# echo "Adding Oibaf Repository and updating..."
		# addRepository ppa:oibaf/graphics-drivers
		# sudo apt -y full-upgrade
		ppa_error_msg "Oibaf"
	fi

	# Install Gufw Firewall Action
	if [[ $opt == *"Install Gufw Firewall"* ]]
	then
		echo "Installing Gufw Firewall..."
		installPackage gufw
	fi

	# Install Startup Disk Creator
	if [[ $opt == *"Install Startup Disk Creator"* ]]
	then
		echo "Installing Startup Disk Creator"
		installPackage usb-creator-gtk
	fi

	# Install Support for Archive Formats Action
	if [[ $opt == *"Install Support for Archive Formats"* ]]
	then
		echo "Installing Support for Archive Formats"
		installPackage zip
		installPackage unzip
		installPackage p7zip
		installPackage p7zip-rar
		installPackage rar
		installPackage unrar
	fi

	# Install GDebi Action
	if [[ $opt == *"Install GDebi"* ]]
	then
		echo "Installing GDebi..."
		installPackage gdebi
	fi

	# Install Google Chrome Action
	if [[ $opt == *"Install Google Chrome"* ]]
	then
		echo "Installing Google Chrome..."
		wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb
	fi

	# Install Chromium
	if [[ $opt == *"Install Chromium"* ]]
	then
		echo "Installing Chromium..."
		installPackage chromium-browser
	fi

	# Install Opera
	if [[ $opt == *"Install Opera"* ]]
	then
		echo "Installing Opera..."
		sudo add-apt-repository 'deb https://deb.opera.com/opera-stable/ stable non-free' -y
		wget -qO- https://deb.opera.com/archive.key | sudo apt-key add -
		sudo apt update
		installPackage opera-stable
	fi

	# Install Firefox Action
	if [[ $opt == *"Install Firefox"* ]]
	then
		echo "Installing Firefox..."
		installPackage firefox
	fi

	# Install Thunderbird Action
	if [[ $opt == *"Replace Pantheon Mail by the Thunderbird Mail"* ]]
	then
		echo "Removing Pantheon Mail..."
		sudo apt --purge remove -y pantheon-mail
		echo "Installing Thunderbird..."
		installPackage thunderbird
	fi

	# Install Skype Action
	if [[ $opt == *"Install Skype"* ]]
	then
		echo "Installing Skype..."
		if [[ $(uname -m) == "i686" ]]
		then
			wget -O /tmp/skype.deb https://download.skype.com/linux/skype-ubuntu-precise_4.3.0.37-1_i386.deb
		elif [[ $(uname -m) == "x86_64" ]]
		then
			wget -O /tmp/skype.deb https://go.skype.com/skypeforlinux-64-alpha.deb
		fi
		sudo dpkg -i /tmp/skype.deb
		sudo apt -f install -y
	fi

	# Install Dropbox Action
	if [[ $opt == *"Install Dropbox"* ]]
	then
		echo "Installing Drobox..."
		installPackage git
		sudo apt --purge remove -y dropbox*
		installPackage python-gpgme
		git clone https://github.com/zant95/elementary-dropbox /tmp/elementary-dropbox
		sudo bash /tmp/elementary-dropbox/install.sh
	fi

	# Install Liferea Action
	if [[ $opt == *"Install Liferea"* ]]
	then
		echo "Installing Liferea..."
		installPackage liferea
	fi

	# Install Go For It!
	if [[ $opt == *"Install Go For It!"* ]]
	then
		echo "Installing Go For It!..."
		# addRepository ppa:go-for-it-team/go-for-it-daily
		# installPackage go-for-it
		ppa_error_msg "Go for it"
	fi

	# Install Klavaro Action
	if [[ $opt == *"Install Klavaro"* ]]
	then
		echo "Installing Klavaro..."
		installPackage klavaro
	fi

	# Install VLC Action
	if [[ $opt == *"Install VLC"* ]]
	then
		echo "Installing VLC..."
		installPackage vlc
	fi

	# Install Clementine Action
	if [[ $opt == *"Install Clementine Music Player"* ]]
	then
		echo "Installing Clementine Music Player..."
		installPackage clementine
	fi

	# Install Gimp Action
	if [[ $opt == *"Install Gimp"* ]]
	then
		echo "Installing Gimp Image Editor..."
		installPackage gimp
	fi

	# Install Deluge Action
	if [[ $opt == *"Install Deluge"* ]]
	then
		echo "Installing Deluge..."
		installPackage deluge
	fi

	# Install Transmission Action
	if [[ $opt == *"Install Transmission"* ]]
	then
		echo "Installing Transmission..."
		installPackage transmission
	fi

	# Install Atom Action
	if [[ $opt == *"Install Atom"* ]]
	then
		echo "Installing Atom..."
		# addRepository ppa:webupd8team/atom
		# installPackage atom
		ppa_error_msg "Atom"
	fi

	# Install Sublime Text 3 Action
	if [[ $opt == *"Install Sublime Text 3"* ]]
	then
		echo "Installing Sublime Text 3..."
	  # addRepository ppa:webupd8team/sublime-text-3
		# installPackage sublime-text-installer
		ppa_error_msg "Sublime Text 3"
	fi

	# Install LibreOffice Action
	if [[ $opt == *"Install LibreOffice"* ]]
	then
		echo "Installing LibreOffice..."
		installPackage libreoffice
	fi

	# Install WPS Office
	if [[ $opt == *"Install WPS Office"* ]]
	then
		echo "Installing WPS Office..."
		if [[ $(uname -m) == "i686" ]]
		then
			wget -O /tmp/wps-office_10.1.0.5672~a21_i386.deb http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_i386.deb
			sudo dpkg -i /tmp/wps-office_10.1.0.5672~a21_i386.deb
		elif [[ $(uname -m) == "x86_64" ]]
		then
			wget -O /tmp/wps-office_10.1.0.5672~a21_amd64.deb http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_amd64.deb
			sudo dpkg -i /tmp/wps-office_10.1.0.5672~a21_amd64.deb
		fi
		#Fonts, Interface Translate, Dictionary
		wget -O /tmp/wps-office-fonts_1.0_all.deb http://kdl.cc.ksosoft.com/wps-community/download/fonts/wps-office-fonts_1.0_all.deb
		wget -O /tmp/wps-office-ul_10.1.0.5503-0kaiana05052016_all.deb http://repo.uniaolivre.com/packages/xenial/wps-office-ul_10.1.0.5503-0kaiana05052016_all.deb
		wget -O /tmp/wps-office-language-all_0.1_all.deb https://doc-0k-5g-docs.googleusercontent.com/docs/securesc/ha0ro937gcuc7l7deffksulhg5h7mbp1/5e6qmvsn8khsfsidk1dorpbg4dmlpf8m/1495634400000/05316569172087402966/*/0B7HGeEB4kyvMaU5SbkdRRjBYWHc?e=download
		sudo dpkg -i /tmp/wps-office-fonts_1.0_all.deb
		sudo dpkg -i /tmp/wps-office-ul_10.1.0.5503-0kaiana05052016_all.deb
		sudo dpkg -i /tmp/wps-office-language-all_0.1_all.deb
	fi

	# Install TLP
	if [[ $opt == *"Install TLP"* ]]
	then
		echo "Installing TLP..."
		sudo apt --purge remove -y laptop-mode-tools	#Avoid conflict with TLP
		installPackage tlp
		installPackage tlp-rdw
	fi

	# Install Redshift Action
	if [[ $opt == *"Install Redshift"* ]]
	then
		echo "Installing Redshift..."
		installPackage redshift-gtk
	fi

	# Install Gnome Disk Utility Action
	if [[ $opt == *"Install Disk Utility"* ]]
	then
		echo "Installing Gnome Disk Utility..."
		installPackage gnome-disk-utility
	fi

	# Install Brasero Action
	if [[ $opt == *"Install Brasero"* ]]
	then
		echo "Installing Brasero..."
		installPackage brasero
	fi

	# Install Spotify Action
	if [[ $opt == *"Install Spotify"* ]]
	then
		echo "Installing Spotify..."
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
		echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
		sudo apt-get update
		installPackage spotify-client

	fi

	# Install Ubuntu Restricted Extras Action
	if [[ $opt == *"Install Ubuntu Restricted Extras"* ]]
	then
		echo "Installing Ubuntu Restricted Extras..."
		installPackage ubuntu-restricted-extras
	fi

	# Fix Broken Packages Action
	if [[ $opt == *"Fix Broken Packages"* ]]
	then
		echo "Fixing the broken packages..."
		sudo apt -y -f install
	fi

	# Clean-Up Junk Action
	if [[ $opt == *"Clean-Up Junk"* ]]
	then
		echo "Cleaning-up junk..."
		sudo apt -y autoremove
		sudo apt -y autoclean
	fi
}

main
