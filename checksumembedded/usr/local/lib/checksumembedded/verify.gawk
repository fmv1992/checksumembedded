#! /usr/bin/gawk --exec
BEGIN {
    n_matches = 0
    sha256_hash = ""
    should_return_with_error = 0
}

should_return_with_error {
    exit 1
}

begin_is_matching {
    lines[i] = $0
    i++
}

$0 ~ checksumembedded_start_pattern {
    begin_is_matching = 1
    end_is_matching = 0
    i = 0
}

$0 ~ checksumembedded_end_pattern {
    # Fix `i`.
    i--
    begin_is_matching = 0
    end_is_matching = 1
    sha256_hash = get_sha256(lines, i)
    i = 0
    n_matches++
}

end_is_matching {
    begin_is_matching = 0
    end_is_matching = 0
    getline
    check_line = $0
    pat = "checksum: .*:" sha256_hash
    if (check_line ~ pat) {
        print "Good verification on line number " NR ":" sha256_hash "."
    } else {
        print "Bad verification on line number " NR "."
        should_return_with_error = 1
    }
}

END {
    if (should_return_with_error) {
        exit 1
    }
}


function get_sha256(lines, index_max)
{
    command = "sha256sum"
    data = ""
    # Concatenate array elements with newlines
    for (j = 0; j < index_max; j++) {
        if (j > 0) {
            data = data ORS
        }
        data = data lines[j]
    }
    print data |& command
    close(command, "to")
    command |& getline result
    close(command)
    split(result, fields, " ")
    return fields[1]
}
