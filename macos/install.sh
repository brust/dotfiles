#!/bin/bash
clear

echo
echo "+-------------------------+"
echo "| Workspace setup script  |"
echo "+-------------------------+"
echo
echo "Installing command line tools..."

if xcode-select -p &> /dev/null; then
  echo "Command line tools already installed"
else
  echo -n "Click 'Install' to download and install. Press RETURN after finished or any other key to abort. "

  xcode-select --install &> /dev/null
  read -s -n 1 key

  if [[ $key != "" ]]; then
    exit
  fi
fi

echo
echo "+-------------------------+"
echo "| Installing Homebrew...  |"
echo "+-------------------------+"
echo

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew tap homebrew/versions &> /dev/null
brew tap caskroom/versions &> /dev/null
brew update &> /dev/null
brew upgrade &> /dev/null

echo
echo "+-------------------------+"
echo "| Git config              |"
echo "+-------------------------+"
echo

brew install git

echo -n "Enter your name: "
read name
echo -n "Enter your e-mail: "
read email

git config --global color.ui true &> /dev/null
git config --global user.name "$name" &> /dev/null
git config --global user.email "$email" &> /dev/null

echo ".DS_Store" > ~/.gitignore_global

git config --global core.excludesfile "~/.gitignore_global" &> /dev/null

echo
echo "+-------------------------+"
echo "| Generating SSH key...   |"
echo "+-------------------------+"
echo

ssh-keygen -q -b 2048 -t rsa -N "" -C “$email” -f $HOME/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub | pbcopy

echo -n "Your SSH public key has been copied to your clipboard. Press any key to continue. "
read key

echo
echo "+-------------------------+"
echo "| Installing RVM...       |"
echo "+-------------------------+"
echo

brew install gpg
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable

rvm install 2.3.1

echo
echo "+-------------------------+"
echo "| Installing apps...      |"
echo "+-------------------------+"
echo

brew install zsh
brew install heroku-toolbelt
brew install memcached
brew install mysql56
brew install postgresql94
brew install redis
brew install speedtest_cli
brew install leiningen

brew cask install 1password
brew cask install firefox
brew cask install google-chrome
brew cask install iterm2
brew cask install ngrok
brew cask install postico
brew cask install qlcolorcode
brew cask install qlimagesize
brew cask install qlmarkdown
brew cask install qlprettypatch
brew cask install qlstephen
brew cask install quicklook-csv
brew cask install quicklook-json
brew cask install sequel-pro
brew cask install skype
brew cask install slack
brew cask install sublime-text3
brew cask install intellij-idea-ce
brew cask install suspicious-package
brew cask install webpquicklook
brew cask install dropbox

mkdir -p ~/Library/LaunchAgents &> /dev/null

ln -sfv /usr/local/opt/mysql56/*.plist ~/Library/LaunchAgents &> /dev/null
ln -sfv /usr/local/opt/postgresql94/*.plist ~/Library/LaunchAgents &> /dev/null
ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents &> /dev/null
ln -sfv /usr/local/opt/memcached/*.plist ~/Library/LaunchAgents &> /dev/null

launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql56.plist &> /dev/null
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql94.plist &> /dev/null
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.redis.plist &> /dev/null
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.memcached.plist &> /dev/null

brew cleanup &> /dev/null
brew cask cleanup &> /dev/null

echo
echo "+-------------------------+"
echo "| Setup Oh My Zsh... |"
echo "+-------------------------+"
echo

chsh -s /bin/zsh

echo
echo "+-------------------------+"
echo "| Tuning up OS X...       |"
echo "+-------------------------+"
echo

# Reload QuickLook plugins
qlmanager -r

# Disable press & hold keys for accents
defaults write -g ApplePressAndHoldEnabled -bool false

env zsh