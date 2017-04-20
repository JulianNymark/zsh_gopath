# recurse upwards, look for ./go & set GOPATH
# (tested in zsh)
set_gopath() {
    set_gopath_recurse "$(pwd)"
}

set_gopath_recurse() {
    if [ -d "$1/go" ]; then
        new_gopath "$(realpath $1)/go"
        return
    fi;

    if [ "$(realpath $1)" = "/" ]; then
        if [ -z $GOPATH ]; then
            echo "GOPATH NOT SET ( recursive 'cd ..' found no ./go )"
        fi;
        return
    fi;
    set_gopath_recurse $1"/.."
}

new_gopath() {
    if [ "$1" != "$GOPATH" ]; then
        echo "GOPATH=$1"
        export "GOPATH=$1"
    fi;
}

# attach set_gopath to hook function on chpwd (whenever working dir changes)
chpwd_functions=(${chpwd_functions[@]} "set_gopath")
