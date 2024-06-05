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

"""
    download_file(url, destination;
                    force_download=false)

Download a file, if it has not been downloaded already.

For password protected access use the `~/.netrc` file to store passwords, see
https://everything.curl.dev/usingcurl/netrc .

For downloading files on the local file system prefix their path with `file://`
as you would to see them in a browser.

# Input
- url -- url for download
- destination -- path (directory + file) where to store it

## Optional keyword args
- force_download -- force the download, even if file is present

# Output:
- file with full path

"""
function download_file(url, dir, file; force_download=false)

    dirfile = joinpath(dir, file)
    mkpath(dir)

    if isfile(dirfile) && !force_download
        # do nothing
        print(" ... already downloaded ... ")
    elseif isfile(dirfile)
        # delete and re-download
        rm(dirfile)
        print(" ... downloading ... ")
        Downloads.download(url, dirfile)
    else
        # download
        Downloads.download(url, dirfile)
    end
    return dirfile
end
