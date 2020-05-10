#!/bin/bash

CONDAINIT='eval "$(/miniconda/bin/conda shell.bash hook)" && conda init'
JCONF=/jupyter-config/jupyter_notebook_config.json

uid=${id::4}
uid=${uid:-1000}

gid=${id:5:4}
gid=${gid:-1000}

user=${user:-conda}

echo "setting up container with:"
echo "uid: $uid"
echo "gid: $gid"
echo "user: $user"

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

chown $user:$user $JCONF /jupyter-config/pass.txt
cp $JCONF /home/$user/.jupyter/
chown -R $user:$user /home/$user

exec su -l $user -c "$CONDAINIT && $@"
