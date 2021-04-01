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


# Link config files
link_if_not_exists .vimrc ~/.vimrc
link_if_not_exists .gitconfig ~/.gitconfig
link_if_not_exists MyBundle.bundle "${HOME}/Library/Keyboard Layouts/MyBundle.bundle"
link_if_not_exists config ~/.ssh/config

mkdir -p ~/.julia/config/
link_if_not_exists startup.jl ~/.julia/config/

