#use .bashrc file, so use it to source
#  actual settings

#.profile, which contains zsh AND bash compliant profile
#  (via detection)
source ~/.profile

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ghbrown/Tools/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ghbrown/Tools/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/ghbrown/Tools/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/ghbrown/Tools/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

