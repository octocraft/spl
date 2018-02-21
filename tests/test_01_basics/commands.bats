#!/usr/bin/env bats

@test "sbpl help" {

    run ./sbpl.sh help
    [ "$status" -eq 0 ]
    [ "${lines[0]}" = "help    - print usage information" ]
    [ "${lines[1]}" = "update  - download packages" ]
    [ "${lines[2]}" = "upgrade - upgrade to latest sbpl version" ]
    [ "${lines[3]}" = "clean   - clear vendor dir" ]
    [ "${lines[4]}" = "version - print sbpl version information" ]
    [ "${lines[5]}" = "envvars - print sbpl env vars in bash format" ]

}

@test "sbpl version" {

    run ./sbpl.sh version
    [ "$status" -eq 0 ]
    [ "$output" = "Simple Bash Package Loader - 1.0.0" ]
}

@test "sbpl usage" {

    run ./sbpl.sh unknownoption
    [ "$status" -eq 2 ]
    [ "${lines[0]}" = "./sbpl.sh: Unknown option unknownoption" ]
    [ "${lines[1]}" = "Use ./sbpl.sh help for help with command-line options," ]
    [ "${lines[2]}" = "or see the online docs at https://github.com/octocraft/sbpl" ]
}

@test "sbpl clean" {

    # Create test file
    mkdir -p "vendor/test"
    echo "123" > "vendor/test/test.txt"

    # test the tester
    [ $(cat "vendor/test/test.txt") = "123" ]

    run ./sbpl.sh clean
    [ "$status" -eq 0 ]

    ! [ -f "vendor/test/test.txt" ]
    ! [ -d "vendor/test" ]
}

@test "sbpl envvars" {

    base_path="$(readlink -f .)/."
    export OS="linux"
    export ARCH="amd64"

    run ./sbpl.sh envvars
    [ "$status" -eq 0 ]    

    unset OS
    unset ARCH
    eval "$output"

    [ "$OS"   = "linux" ]
    [ "$ARCH" = "amd64" ]
    [ "$sbpl_version" = "1.0.0" ]
    [ "$sbpl_path" = "$base_path" ]
    [ "$sbpl_pkg_path" = "$base_path/vendor" ]
}
