# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Detect if running from bash or zsh and setup appropriately
if [ -n "$ZSH_VERSION" ]; then
   # assume Zsh
    setopt globdots #includes files beginning with . in cp and rm etc.
    PS1='%n@%m : %~$ ' #set zsh command prompt
elif [ -n "$BASH_VERSION" ]; then
   # assume Bash
    shopt -s dotglob #includes files beginning with . in cp and rm etc.
    shopt -s histappend #append to the history file, don't overwrite it
    shopt -s checkwinsize #update the values of LINES and COLUMNS.
    PS1='\u@\h : \w$' #set bash command prompt
else
   # assume something else, p
    echo 'Shell != bash, zsh'
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
# enable programmable completion features (you don't need to enable
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


#Functions
function cpb { #copy to buffer
    rm -dfr ${CPBUFF}/*
    cp -r "$@" ${CPBUFF}/
    }

function cpfb { #copy from buffer
    cp -r ${CPBUFF}/* "$1"
    }
function huion { #set up buttons for Huion 610P
	#STYLUS, buttom numbers: 2 (lower), 3 (upper)
		xsetwacom --set 'HUION Huion Tablet Pen stylus' Button 2 "key +ctrl" #set lower button as color sampler

	#TABLET, button numbers (top to bottom): 1,2,3,8,9,10,11,12
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 1 "key +ctrl +z -z -ctrl" #set undo
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 2 "key +E -E" #set eraser mode
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 3 "key +B -B" #set freehand brush
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 8 "key +ctrl +space" #set zoom by drag
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 9 "key +space" #set pan by drag
		xsetwacom --set "HUION Huion Tablet Pad pad" Button 10 "key +shift" #set change brush size by drag
		#xsetwacom --set "HUION Huion Tablet Pad pad" Button 11 "key "
		#xsetwacom --set "HUION Huion Tablet Pad pad" Button 12 "key "
	
    }
function srm {  #safe rm
    mv -f --backup=t "$@" ${RMBUFF}/
    }
function scpcc { #ssh copy to campus cluster
    toCopy=${*%${!#}} #all arguments but the last
    destination=${@:$#} #only the last argument
    scp -r ${toCopy} ghbrown3@cc-xfer.campuscluster.illinois.edu:${destination}
    }
function sshcc { #login to campus cluster
    ssh ghbrown3@cc-login.campuscluster.illinois.edu
    }
function updateconfigs { #updates GitHub with all configuration files (.bashrc, etc.)
    #dpkg --get-selections > ~/.applicationNameBackup.txt;\ #for Debian system
    #for Arch system (below)
    pacman -Qqe > ${CONFIGURATIONS}/.application_name_backup.txt
    #call unaliased cp (below)
    \cp -f ~/.profile ~/.bashrc ~/.zshrc ~/.emacs ${CONFIGURATIONS}
    \cp -f ~/Documents/Coding/Vimium/vimium-options.json ${CONFIGURATIONS}
    #backup conda environments as .yml files
    (cd ${CONFIGURATIONS};\
    python3 backup_conda_envs.py;\
    )
    #update remote repository
    (cd ${CONFIGURATIONS};\
    git add .;\
    git commit -m "${@}";\
    git push;\
    )
    }
function usb_gc_controller { #allow GameCube controller to work as USB controller
    #execute program
    sudo ~/Documents/Games/Emulation/Controllers/wii-u-gc-adapter/wii-u-gc-adapter
    }
function slippi_controller { #fix drivers for GameCube controller and Slippi
    sudo rm -f /etc/udev/rules.d/51-gcadapter.rules && sudo touch /etc/udev/rules.d/50-gcadapter.rules && echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules > /dev/null && sudo udevadm control --reload-rules
    sudo systemctl restart udev.service
    }

#Configuration variables
#perhaps some X11/Wayland stuff to get rid of annoying Qt/conda/matplotlib error

#Standard aliases
alias sourceprofile='source ~/.profile'
alias clrtmp='rm -dr ~/Temporary/*; mkdir ${CPBUFF} ${RMBUFF}'
alias srmdup='srm *~'
alias mv='mv -i'
alias cdd='cd ..'
alias cp='cp -i'
alias cls='clear; ls'
alias cdtools='cd ${TOOLS}'
alias cdjohnson='cd ${JOHNSON}'
alias cdsolomonik='cd ${SOLOMONIK}'
alias emacs='(cd $HOME); emacs -nw'

#Standard variables
export CONDA=${TOOLS}/anaconda3
export CONFIGURATIONS=/home/ghbrown/Documents/Coding/Configurations
export CPBUFF=/home/ghbrown/Temporary/cpbuffer
export RMBUFF=/home/ghbrown/Temporary/rmbuffer
export JOHNSON=/home/ghbrown/Documents/Research/Johnson
export SOLOMONIK=/home/ghbrown/Documents/Research/Solomonik
export PYTHONMODULESSTD=/home/ghbrown/Tools/anaconda3/envs/std/lib/python3.9/site-packages #these modules are internal to the std conda environment
export TOOLS=/home/ghbrown/Tools

#Aliases for computation
alias pdb2lmp='${TOOLS}/qmd-progress/build/changecoords'
alias skf2dat='python3 ${LATTE_DIR}/tools/DLtab/DLtab.py'

#Variables for computation
export BML_DIR=${TOOLS}/bml
export PROGRESS_DIR=${TOOLS}/qmd-progress
export LATTE_DIR=${TOOLS}/LATTE
export LATTEDOUBLE=${LATTE_DIR}/LATTE_DOUBLE
export LAMMPS_DIR=${TOOLS}/lammps
export LMP_SERIAL=${LAMMPS_DIR}/src/lmp_serial
#export LAMMPS_ARCH=g++_mpich_link_mine

#set conda environment to my standard
conda activate std

#clear prompt and provide ls output at top of prompt
cls
