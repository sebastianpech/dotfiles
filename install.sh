link_if_not_exists() {
    echo "[$2]"
    if [ -f "$2" ]; then
        echo "  file already exist ... skipping linking!"
    else 
        echo "  created: $2 -> $1"
        ln -s $(pwd)/$1 "$2"
    fi
    echo ""
}

# Create nvim folder
mkdir -p ~/.config/nvim

# Link config files
link_if_not_exists .vimrc ~/.vimrc
# link_if_not_exists init.vim ~/.config/nvim/init.vim
# link_if_not_exists coc-settings.json ~/.config/nvim/coc-settings.json
link_if_not_exists .gitconfig ~/.gitconfig
link_if_not_exists MyBundle.bundle "${HOME}/Library/Keyboard Layouts/MyBundle.bundle"




