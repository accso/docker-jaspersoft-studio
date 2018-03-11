#! /bin/sh
USER_HOME=/home/${DOCKER_USER}
echo "Mapping UID $TARGET_UID and GID $TARGET_GID for container user ${DOCKER_USER}..."
sed -i s/$DOCKER_USER:x:1000:1000/$DOCKER_USER:x:$TARGET_UID:$TARGET_GID/ /etc/passwd

#export JAVA_HOME=/opt/java

echo "Mapping UID and GID in files..."
chown $DOCKER_USER.$DOCKER_USER /home/$DOCKER_USER

echo "Using $DISPLAY for contacting X server..."

#cat ~/.Xauthority

SCRIPT=$USER_HOME/start.sh
echo "#!/bin/sh" > $SCRIPT
echo "export DISPLAY=$DISPLAY" >> $SCRIPT
echo "export QT_GRAPHICSSYSTEM=opengl"  >> $SCRIPT
echo "cd /opt" >> $SCRIPT
echo "echo Starting Jaspersoft-Studio..." >> $SCRIPT
# Siehe https://community.jaspersoft.com/wiki/tibco-jaspersoft-studio-how-configure-non-default-path-jaspersoft-studio-workspace
echo "/opt/tibco/TIB_js-studiocomm_6.5.1.final/runjss.sh -data ${USER_HOME}/home_on_host/JaspersoftWorkspace" >> $SCRIPT
chmod +x $SCRIPT

#dpkg -L jaspersoftstudio

echo "Starting start script as user ${DOCKER_USER}..."
su -l $DOCKER_USER -c $SCRIPT
