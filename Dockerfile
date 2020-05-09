FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  \
    && bash miniconda.sh -b -p /miniconda \
    && rm miniconda.sh \
    && apt-get remove -y wget \
    && apt autoremove -y \
    && PATH="/miniconda/bin:$PATH" \
    && conda update -y conda \
    && conda install -y jupyter nb_conda_kernels \
    && chmod -R 777 /miniconda


ADD entrypoint.sh nb_passwd.py /scripts/


RUN mkdir /jupyter-config /notebooks \
    && chmod -R 777 /jupyter-config /notebooks /scripts


EXPOSE 8888


ENTRYPOINT ["/scripts/entrypoint.sh"]


CMD ["jupyter notebook --no-browser --ip=0.0.0.0 --notebook-dir=/notebooks"]
