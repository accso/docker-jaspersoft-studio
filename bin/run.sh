# Start the Jaspersoft-Studio in a container using the X11 server of the host
# See https://github.com/accso/docker-jaspersoft-studi

# These are paths that have been preconfigured for a typical Linux environment. You have have
# to change them to match your OS.

MACHINE_ID_FILE=${MACHINE_ID_FILE:-/etc/machine-id}
XAUTHORITY_FILE=${XAUTHORITY_FILE:-$HOME/.Xauthority}
X11_DIR=${X11_DIR:-/tmp/.X11-unix}

# Determine UID and GID of the user starting the script and pass them to the container
# so that the executing container process can be started using the very same UID and GID.

TARGET_UID=`id -u`
TARGET_GID=`id -g`

DOCKER_USER=jaspersoft
DOCKER_CONTAINER=jaspersoft-studio-${USER}

docker run --rm \
       -v $X11_DIR:/tmp/.X11-unix \
       -v $MACHINE_ID_FILE:/etc/machine-id \
       -v $XAUTHORITY_FILE:/home/$DOCKER_USER/.Xauthority \
       -h $HOSTNAME \
       -e DISPLAY=$DISPLAY \
       -e DOCKER_USER=$DOCKER_USER \
       -e TARGET_UID=$TARGET_UID \
       -e TARGET_GID=$TARGET_GID \
       -v $HOME:/home/$DOCKER_USER/home_on_host \
       --name $DOCKER_CONTAINER \
       accso/docker-jaspersoft-studio:latest 
