# recurse upwards, look for ./go & set GOPATH
# (tested in zsh)
set_gopath() {
    # unhook chpwd (we'll be using cd inside set_gopath_recurse)
    chpwd_functions=(${chpwd_functions[@]:#"set_gopath"})
    set_gopath_recurse "$(pwd)"
    # rehook chpwd
    chpwd_functions=(${chpwd_functions[@]} "set_gopath")
}

set_gopath_recurse() {
    if [ -d "./go" ]; then
        new_gopath "$(pwd)/go"
        cd $1
        return
    fi;

    if [ "$(pwd)" = "/" ]; then
        if [ -z $GOPATH ]; then
            echo "GOPATH NOT SET ( recursive 'cd ..' found no ./go )"
        fi;
        cd $1
        return
    fi;
    cd ..
    set_gopath_recurse $1
}

new_gopath() {
    if [ "$1" != "$GOPATH" ]; then
        echo "GOPATH=$1"
        export "GOPATH=$1"
    fi;
}

# attach set_gopath to hook function on chpwd (whenever working dir changes)
chpwd_functions=(${chpwd_functions[@]} "set_gopath")
