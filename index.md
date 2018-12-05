
![Screenshot](https://raw.githubusercontent.com/btd1337/elementary-script/master/screenshot.jpeg)

## OS Version Compatibility

This script will support the lastest stable version of:
- elementary OS
- Linux Mint
- Ubuntu
- and others Ubuntu based systems

## Run
#### Method 1 | With curl
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/btd1337/elementary-script/master/elementary-script.sh)"
```

#### Method 2 | With wget
```shell
bash -c "$(wget https://raw.githubusercontent.com/btd1337/elementary-script/master/elementary-script.sh -O -)"
```
#### Method 3 | With git
Copy and paste the following line into a terminal window in order to run the script.

```bash
sudo apt install git
git clone https://github.com/btd1337/elementary-script
cd elementary-script
./elementary-script.sh
```

## Known Issues
* Oibaf Repository:

  If after adding **Oibaf Repository** elementary stucks in the boot sequence and panel and main menu don't appear any more (and also the shortcut to open the terminal doesn't work any more)

  1. Use `ctrl+alt+f1` to get to a text terminal (`ctrl+alt+f7` goes back)

  2. Login with user name and password

  3. Execute the commands below:
  ```
  sudo apt install purge-ppa
  sudo purge-ppa ppa:oibaf/graphics-drivers
  sudo reboot
  ```

	The system boots up completely again.
  
## Problems or Ideas
Report here: [Support](https://github.com/btd1337/elementary-script/issues)

## References
[Diolinux](http://www.diolinux.com.br/2016/12/elementary-script-pos-instalacao.html)

[Terminal Aberto](http://terminalaberto.com/2017/03/01/elementary-script-um-facilitador-de-servico-para-o-elementary-os/)

## Donate
[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=X85LVKF3HYPZL&lc=US&item_name=btd1337&item_number=elementary%2dscript&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted)

## License
This project is a fork of [ylrxeidx/elementary-script](https://github.com/ylrxeidx/elementary-script) and follows your license.

[The MIT License](http://ylrxeidx.mit-license.org/ "The MIT License")
