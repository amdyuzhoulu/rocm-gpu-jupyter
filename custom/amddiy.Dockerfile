USER root

RUN groupmod -g 992 render
RUN usermod -aG video,render ${NB_USER}
RUN echo "jovyan:jovyan" | chpasswd

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
COPY ./introduction_to_hip_notebooks  /share/notebook

# Change ownership of /share/notebook to jovyan
USER root
RUN chown -R $NB_UID:$NB_GID /share/notebook

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
WORKDIR /share/notebook
