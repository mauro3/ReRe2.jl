## General utility functions
using LibGit2

function make_sha_filename(basename, ext)
    ## Bash command line invocation (maybe not so portable between operating systems)
    # git rev-parse --short=10 HEAD

    # Open the repository in the current directory
    repo = LibGit2.GitRepoExt(".")

    # Get the object ID of the HEAD commit
    head_commit_id = LibGit2.head_oid(repo)
    # Convert the object ID to a hexadecimal string and take the first 10 characters
    short_hash = string(head_commit_id)[1:10]

    # check if there are uncommitted changes
    if LibGit2.isdirty(repo)
        postfix = short_hash * "-dirty"
    else
        postfix = short_hash
    end

    return basename * "-" * postfix * ext
end

make_sha_filename("test", ".png")
