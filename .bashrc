# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

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

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

shopt -s dotglob #considers files beginning with . in cp and rm etc.

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
    (cd ${CONFIGURATIONS};\
    cp ~/.bashrc ~/.emacs ${CONFIGURATIONS};\
    cp ~/Documents/Coding/Vimium/vimium-options.json ${CONFIGURATIONS};\
    git add .;\
    git commit -m "Scripted update.";\
    git push; \
    )
    }
function zadig { #fixed drivers for GameCube controller and Slippi
    sudo rm -f /etc/udev/rules.d/51-gcadapter.rules && sudo touch /etc/udev/rules.d/50-gcadapter.rules && echo 'SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"' | sudo tee /etc/udev/rules.d/51-gcadapter.rules > /dev/null && sudo udevadm control --reload-rules
    }

#Standard aliases
alias sourcebashrc='source ~/.bashrc'
alias clrtmp='rm -dr ~/Temporary/*; mkdir ${CPBUFF} ${RMBUFF}'
alias rmdup='srm *~'
alias mv='mv -i'
alias cp='cp -i'
alias cdtools='cd ${TOOLS}'
alias cdjohnson='cd ${JOHNSON}'
alias cdsolomonik='cd ${SOLOMONIK}'
alias emacs='(cd $HOME; xmodmap .swapAlt_CAPSLOCK); emacs -nw'

#Standard variables
export CONFIGURATIONS=/home/ghbrown/Documents/Coding/Configurations
export CPBUFF=/home/ghbrown/Temporary/cpbuffer
export RMBUFF=/home/ghbrown/Temporary/rmbuffer
export JOHNSON=/home/ghbrown/Documents/Research/Johnson
export SOLOMONIK=/home/ghbrown/Documents/Research/Solomonik
export PYTHONMODULES=/home/ghbrown/.local/lib/python3.8/site-packages
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

