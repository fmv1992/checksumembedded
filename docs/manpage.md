<!--

https://jeromebelleman.gitlab.io/posts/publishing/manpages/

-->

% checksumembedded(1)
% Felipe M. Vieira
% November 2024

# NAME

checksumembedded – Verify checksums embedded in text files.

# SYNOPSIS

**checksumembedded** [**\--verify** FILE [...] | **\--test**]

# DESCRIPTION

**checksumembedded** verifies the sha256 checksum of a few lines of code:

<!--

note01: `gawk` exchanges ————⋯ with triple ticks. This has to do with pandoc
indenting if triple ticks is used directly (thus breaking
`checksumembedded`.).

-->

`———————————————————————————————————————————————————————————————————————————————`

This is `/path/myfile.txt`. It has some text in it:

// ----- ✂ checksumembedded: BEGIN
a = 10
print(10)
// ✂ ----- checksumembedded: END
// checksum: sha256:60aa545f7b41ee671109f6070e5c172af7ea3c6baa854e9bf21cbfee02e28d39

This is more text...

`———————————————————————————————————————————————————————————————————————————————`

# GENERAL OPTIONS

**-c**, **\--verify** FILE
:   Verify the file

**-h**, **\--help**
:   Print help and exit.

# USAGE

`———————————————————————————————————————————————————————————————————————————————`
checksumembedded --verify ./readme.md
`———————————————————————————————————————————————————————————————————————————————`

<!-- # vim: set filetype=pandoc fileformat=unix nowrap spell spelllang=en: -->
