# docker-jaspersoft-studio

This container provides the Jaspersoft-Studio running in a container using
the X-Windows server running on the docker host.

## GUI

The container uses the approach of letting the application communicate with the X server running on the host by using specific X11 files located on the host server. The application can be started as though it were residing on the host server. The mounted files and directories are as follows:

 * `/tmp/.X11-unix`
 * `/etc/machine-id`
 * `$HOME/.Xauthority`

## Accessing Jaspersoft-Studio files from outside the container

The aim of the container is to let the user consistently read and write studio files located on the host server without having to worry about mismatching UID or GID. In order to achieve this the following measures have been taken:

 * provide a user (`jaspersoft`) in the container and run the application using that user and its default group,
 * dynamically change the UID of that user and the GID of its group to match the UID and GID of the host user starting the container,
 * add the username of the calling user to the container name so that possible several users can call the run script and have seperate containers without collision,
 * map the home directory of the calling user as `home_on_host` in the home directory of user `jaspersoft`,
 
## Usage

On a linux system just copy the [run.sh](bin/run.sh) to your local file system, make it executable and run it. Use the script [build.sh](bin/build.sh) to build the container locally after cloning https://github.com/accso/docker-jaspersoft-studio.

## Dockerfile

The [Dockerfile](Dockerfile) executes the following steps:

 * retrieve the Debian installation package from [SourceForge](https://netcologne.dl.sourceforge.net/project/jasperstudio),
 * install the package using `dpkg -i`,
 * load all other required Debian packages using `apt-get install -f`,
 * install a `docker-entrypoint.sh` script.
 
## Caveats

* Exiting the application does not terminate the container. It must be stopped manually.

