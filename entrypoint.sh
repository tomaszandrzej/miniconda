#!/bin/bash

CONDAINIT='eval "$(/miniconda/bin/conda shell.bash hook)" && conda init'
JCONF=/jupyter-config/jupyter_notebook_config.json

uid=${id::4}
gid=${id:5:}

echo "uid: $uid gid: $gid"


eval "$@"

: '
if [ -n "$UID" ] && [ -n "$GID" ]
 then

  if [ -z "$USER" ]
   then
    USER=conda
  fi

  groupadd -g $GID $USER
  echo "creating user: $USER, uid: $UID, gid: $GID"
  useradd -m -s /bin/bash -u $UID -g $GID $USER
  echo "adding jupyter config"
  mkdir /home/$USER/.jupyter

  if [ ! -f $JCONF ] && [ -n "$JPASS" ]
   then
    /scripts/nb_passwd.py $JPASS

  elif [ ! -f $JCONF ] && [ -z "JPASS" ]
   then
    echo "neither -e JPASS= specified nor notebook config file given"
    exit 1
  fi

  echo "config received"
  chown $USER:$USER /jupyter-config/*
  cp /jupyter-config/* /home/$USER/.jupyter/
  chown -R $USER /home/$USER
  exec su -l $USER -c "$CONDAINIT && $@"

else
 echo "-e UID= or -e GID= not specified"
 exit 1
fi

'
