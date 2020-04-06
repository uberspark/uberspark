#! /usr/bin/env fish
#

set log_file_path "$PWD/docker_build.log"
set my_version (basename $PWD)
set bare_version (string sub --start 2 $my_version)
set archive_name "CompCert-$bare_version.tgz"
set compcert_tag "compcert-$my_version:latest"


# ***** Begin helper functions. *****

function exit_fail
    echo "Build failed. Check the log."
    popd
    exit 1
end

function log_and_fail
    echo $argv[1] | tee --append $log_file_path
    exit_fail
end

# ***** End helper functions. *****



# Conduct preliminary checks of the environment.
set docker_bin (which docker)
if test $docker_bin = ""
	log_and_fail "Docker is required to build the container. Install Docker and try again."
end

set grep_bin (which grep)
if test $grep_bin = ""
	log_and_fail "Somehow, your system does not have grep. Install grep and try again."
end


# First, clean up if necessary.
if test -e $log_file_path
	echo "Cleaning up old build log..."
    rm $log_file_path || log_and_fail "Failed to remove log file. Check permissions."
end

if test -e ./DOCKER/
	echo "Cleaning up prior build..."  | tee --append docker_build.log
    rm -rf ./DOCKER || log_and_fail "Failed to remove DOCKER folder. Check permissions."
end


# Start anew.
mkdir -p DOCKER


# Insist on the existence of build deps or fail?
set my_build_files (ls *.tgz)


# Set up the build folder.
pushd DOCKER

for n in $my_build_files
    echo "Copying build file: $n" | tee --append ../docker_build.log
    cp ../$n . || log_and_fail "Copying $n failed. Exiting."

    # echo "Extracting build file: $n" | tee --append ../docker_build.log
    # tar xzf $n || log_and_fail "Extracting $n failed. Exiting."
end

cp ../Dockerfile .
cp ../install.sh .
cp ../compiler_script.sh .


# Prepare to build image.
set docker_version ($docker_bin version | $grep_bin "Version:" | head -n 1)
echo "Using Docker version: $docker_version" | tee --append ../docker_build.log

docker build -t $compcert_tag --build-arg hprox=$http_proxy --build-arg hsprox=$https_proxy --build-arg HPROX=$http_proxy --build-arg HSPROX=$https_proxy --build-arg archive_name=$archive_name . || log_and_fail "Docker build failed."

echo "Build completed successfully!" | tee --append ../docker_build.log
popd

