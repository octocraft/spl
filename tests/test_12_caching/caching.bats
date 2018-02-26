#!/usr/bin/env bats

export OS="linux"
export ARCH="amd64"

function curl () {
    export TEST_PACKGE="package/test"
    ./sbpl_mock_curl.bash $@
}

export -f curl

@test "download pkg" {

    rm -rf vendor
    rm -f sbpl-pkg.sh.lock
    
    run ./sbpl.sh
    [ -f "vendor/$OS/$ARCH/test-0.0.0/test" ]    
}

@test "dont download pkg" {

    rm "vendor/$OS/$ARCH/test-0.0.0/test"

    run ./sbpl.sh
    ! [ -f "vendor/$OS/$ARCH/test-0.0.0/test" ]
}

@test "download pkg after clean" {

    ./sbpl.sh clean
    ! [ -f "vendor/$OS/$ARCH/test-0.0.0/test" ]

    run ./sbpl.sh
    [ -f "vendor/$OS/$ARCH/test-0.0.0/test" ]
}

@test "remove pkg on error" {

    ./sbpl.sh clean

    function curl () {
        echo "Test Error" 1>&2
        exit 42
    }

    export -f curl

    run ./sbpl.sh
    echo "output: $output" 1>&2
    [ ! -d "vendor/$OS/$ARCH/test-0.0.0" ]

    rm -rf vendor
    rm -f sbpl-pkg.sh.lock
}

