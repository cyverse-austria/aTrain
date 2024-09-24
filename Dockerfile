# docker build --no-cache -t mbwali/atrain:v1.1.0
# docker run -it -p 8080:8080 mbwali/atrain:v1.1.0

FROM python:3.11-slim-bullseye

ARG USERNAME=atrainuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Creating the user and usergroup
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USERNAME -m -s /bin/bash $USERNAME 

# Set /home/atrainuser as the workspace directory
RUN mkdir -p /home/atrainuser && \
    chown -R $USERNAME:$USERNAME /home/atrainuser

# Install necessary packages and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $USERNAME

# Set the working directory to /home/atrainuser (also the workspace)
WORKDIR /home/atrainuser/

# Install Python dependencies without caching
RUN pip install --no-cache-dir git+https://github.com/cyverse-austria/aTrain.git@version1 --extra-index-url https://download.pytorch.org/whl/cu118

# Expose port 8080
EXPOSE 8080

# Set entry point for the container
ENTRYPOINT ["/home/atrainuser/.local/bin/aTrain", "startserver"]
