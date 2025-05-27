LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at> yuzhoulu@amd.com"

# Install dependencies for e.g. PyTorch
RUN mamba install --quiet --yes \
    pyyaml setuptools cmake cffi typing && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install Tensorflow, check compatibility here:
# https://www.tensorflow.org/install/source#gpu
# installation via conda leads to errors in version 4.8.2
# Install CUDA-specific nvidia libraries and update libcudnn8 before that
# using device_lib.list_local_devices() the cudNN version is shown, adapt version to tested compat
USER ${NB_UID}
RUN pip install --upgrade pip && \
    pip install --no-cache-dir tensorflow==2.18.0 keras==3.8.0 && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Check compatibility here:
# https://pytorch.org/get-started/locally/
# Installation via conda leads to errors installing cudatoolkit=11.1
# RUN pip install --no-cache-dir torch==2.2.2 torchvision==0.17.2 torchaudio==2.2.2 \
#  && torchviz==0.0.2 --extra-index-url https://download.pytorch.org/whl/cu121
RUN set -ex \
 && buildDeps=' \
    torch \
    torchvision \
    torchaudio \
' \
 && pip install --pre --no-cache-dir $buildDeps  --index-url https://download.pytorch.org/whl/nightly/rocm6.4\
 && fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"



USER root
RUN ln -s $CONDA_DIR/bin/ptxas /usr/bin/ptxas

USER $NB_UID
