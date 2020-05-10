#!/bin/bash

CONDAINIT='eval "$(/miniconda/bin/conda shell.bash hook)" && conda init'
JCONF='/jupyter-config/jupyter_notebook_config.json'
PASSF='/jupyter-config/pass.txt'


uid=${id::4}
uid=${uid:-1000}

gid=${id:5:4}
gid=${gid:-1000}

user=${user:-conda}

echo "setting up the container with:"
echo " uid: $uid"
echo " gid: $gid"
echo "ownership of files will set with those"
echo "username within the container: $user"
echo "this does not affect file ownership"


groupadd -g $gid $user
useradd -m -s /bin/bash -u $uid -g $gid $user
mkdir /home/$user/.jupyter


if [ ! -f $JCONF ]
 then
  /scripts/nb_passwd.py $pass

else [ -f $JCONF ]
  echo "using mounted jupyter config file"
  echo "ignoring passphrase if given"

fi


if [ -f $PASSF ]
 then
 chown $user:$user $PASSF

fi

chown $user:$user $JCONF
cp $JCONF /home/$user/.jupyter/
chown -R $user:$user /home/$user

echo "starting up, conda init messages:"

exec su -l $user -c "$CONDAINIT && $@"
