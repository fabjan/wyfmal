#! /usr/bin/env bash

set -u
set -e
set -o pipefail

fail() {
    echo "$1"
    return 1
}

which mal >/dev/null || fail "cannot find mal binary"

assert_eq() {
    test "$1" = "$2" || fail "FAIL: expected $1 but got $2"
}

wyf_test() {
    echo -n "testing $1 ... "
    out=$(echo "$2" | mal wyf.mal)
    assert_eq "$(echo -e "$3")" "$out" && echo OK
}

wyf_test "+ and print" \
"42 4711 + print" \
"4753"

wyf_test "dup and branch?" \
"-3 1 + dup dup print branch? -6" \
"-2\n-1\n0"

wyf_test ": ; * /" \
"$(cat <<-END
    : ++ 1 + ;
    : square dup * ;
    : cube square square ;
    : half 2 / ;
    6 cube 7 * 19 square + half 5 - print
END
)" \
"4711"
