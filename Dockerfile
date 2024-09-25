# docker build --no-cache -t mbwali/atrain:v1.1.0
# docker run -it -p 8080:8080 mbwali/atrain:v1.1.0

FROM python:3.11-slim-bullseye

ARG USERNAME=atrainuser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Creating the user and usergroup
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USERNAME -m -s /bin/bash $USERNAME 

# Create workspace and set permissions
RUN mkdir -p /home/workspace && \
    chown -R $USERNAME:$USERNAME /home/workspace

# Install necessary packages and clean up
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER $USERNAME

WORKDIR /home/workspace/

# Install Python dependencies without caching
RUN pip install aTrain@git+https://github.com/cyverse-austria/aTrain.git@docker --extra-index-url https://download.pytorch.org/whl/cu118
RUN /home/atrainuser/.local/bin/aTrain init

# Expose port 8080
EXPOSE 8080

# Set entry point for the container
ENTRYPOINT ["/home/atrainuser/.local/bin/aTrain", "startserver"]

# outputs
# /home/atrainuser/.local/bin/aTrain/transcriptions