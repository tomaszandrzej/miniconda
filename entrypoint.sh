#!/bin/bash

condainit='eval "$(/miniconda/bin/conda shell.bash hook)" && conda init'


if [ -n "$USER" ] && [ "$USER" != "root" ]
 then
  echo "user set as $USER"
  useradd -m -s /bin/bash $USER
  usermod -a -G conda $USER
  chown -R $USER /notebooks
  mkdir /home/$USER/.jupyter

  if [ -n "$JPASS" ]
   then
    /scripts/nb_passwd.py $JPASS

   if [ $? -eq 0 ]
    then
     echo "password aquired successfully, copying"
     cp /jupyter-config/* /home/$USER/.jupyter/
     chown -R $USER /home/$USER
   fi
  fi

  exec su -l $USER -c "$condainit && $@"


else

  if [ -n "$JPASS" ]
   then
    /scripts/nb_passwd.py $JPASS
    echo "password aquired successfully, copying"
    mkdir /root/.jupyter
    cp /jupyter-config/* /root/.jupyter/
    chown -R $USER /home/$USER
    su -l root -c "$condainit && $@"
  fi
fi

