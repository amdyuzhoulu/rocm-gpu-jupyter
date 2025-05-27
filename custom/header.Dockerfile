# Use ROCM BASE image as base image and run the same installation as in the other packages.
# The version of cuda must match those of the packages installed in src/Dockerfile.gpulibs
FROM rocm/dev-ubuntu-24.04:6.4-complete
LABEL authors="Christoph Schranz <christoph.schranz@salzburgresearch.at> yuzhoulu@amd.com"

# This is a concatenated Dockerfile, the maintainers of subsequent sections may vary.
RUN chmod 1777 /tmp && chmod 1777 /var/tmp

# install apt-utils in header to fix warnings in docker-stacks
RUN apt-get update && \
    apt-get -y install apt-utils

RUN userdel -r ubuntu    
USER root