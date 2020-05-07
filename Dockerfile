FROM ubuntu:20.04

RUN apt-get update \
    && apt-get install -y wget \
    && rm -rf /var/lib/apt/lists/* \
    && wget -q -O miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  \
    && bash miniconda.sh -b -p /miniconda \
    && rm miniconda.sh \
    && apt-get remove -y wget \
    && apt autoremove -y \
    && groupadd conda \
    && mkdir /notebooks /jupyter-config \
    && chown -R :conda /miniconda /notebooks /jupyter-config \
    && chmod -R 770 /miniconda /notebooks /jupyter-config \
    && /miniconda/bin/conda init \
    && PATH="/miniconda/bin:/miniconda/condabin:$PATH" \
    && conda update -y conda \
    && conda install -y jupyter nb_conda_kernels

ADD entrypoint.sh /

RUN chown :root /entrypoint.sh \
    && chmod +x /entrypoint.sh


EXPOSE 8888

ENTRYPOINT ["/entrypoint.sh"]

CMD ["jupyter notebook --no-browser --ip=0.0.0.0 --notebook-dir=/notebooks"]
