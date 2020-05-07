#!/bin/bash

echo 'PATH="/miniconda/bin:/miniconda/condabin:$PATH"' >> /etc/profile

if [ -n "$USER" ] && [ "$USER" != "root" ]
 then
  echo "user set as $USER"
  useradd -m -s /bin/bash $USER
  usermod -a -G conda $USER
  mkdir /home/$USER/.jupyter
  su -l $USER -c "conda init && $@"
  exit 0

elif [ "$USER" = "root" ]
 then
  echo "user set as root!"
  echo "S1: $1"
  su -l root -c "conda init && $@"
  exit 0

else
  echo "user not set!"
  echo "must set user with -e USER=[username]"
  exit 1

fi

