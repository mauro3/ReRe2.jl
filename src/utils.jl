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
    download_file(url, destination; force_download=false)

Download a file, if it has not been downloaded already.

For password protected access use the `~/.netrc` file to store passwords, see
https://everything.curl.dev/usingcurl/netrc .

For downloading files on the local file system prefix their path with `file://`
as you would to see them in a browser.

# Input
- url -- url for download
- destination_file -- path (directory + file) where to store it

## Optional keyword args
- force_download=false -- force the download, even if file is present
"""
function download_file(url, destination_file; force_download=false)
    # make sure the directory exists
    mkpath(splitdir(destination_file)[1])

    if isfile(destination_file) && !force_download
        # do nothing
        println(" Already downloaded $destination_file")
    elseif isfile(destination_file)
        # delete and re-download
        rm(destination_file)
        print("Re-Downloading $destination_file ... ")
        Downloads.download(url, destination_file)
        println("done.")
    else
        # download
        print("Downloading $destination_file ... ")
        Downloads.download(url, destination_file)
        println("done.")
    end
    return
end

"""
    unzip_one_file(zipfile, filename, destination_file)

Unzip one file from a zip-archive.

Inputs:
- `zipfile`: path to zip-file
- `filename`: name of file within the zip-archive to unzip, including any paths within the zipfile
- 'destination_file`: path+file where to place the file
"""
function unzip_one_file(zipfile, filename, destination_file)
    # make sure the directory exists
    mkpath(splitdir(destination_file)[1])

    r = ZipFile.Reader(zipfile)
    for f in r.files
        if f.name == filename
            write(destination_file, read(f, String))
        end
    end
    return nothing
end
