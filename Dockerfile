# docker build --no-cache -t mbwali/atrain:v1.1.0
# docker run -it -p 8080:8080 mbwali/atrain:v1.1.0
FROM python:3.11-slim-bullseye

# Create a non-root user and group, and set the home directory
RUN groupadd -r atrainuser && useradd --no-log-init -r -g atrainuser -d /home/atrainuser atrainuser && \
    mkdir -p /home/atrainuser && chown atrainuser:atrainuser /home/atrainuser

# Install necessary packages and clean up to reduce image size
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set the working directory to the non-root user's home
WORKDIR /home/atrainuser

# Switch to non-root user
USER atrainuser

# Set environment variables to ensure Python packages are installed in the user's home directory
ENV PATH="/home/atrainuser/.local/bin:${PATH}"
ENV PYTHONUSERBASE="/home/atrainuser/.local"

# Install Python dependencies as the non-root user
RUN pip3 install --user aTrain@git+https://github.com/cyverse-austria/aTrain.git@docker --extra-index-url https://download.pytorch.org/whl/cu118

# Initialize aTrain as the non-root user
RUN aTrain init

# Expose port 8080
EXPOSE 8080

# Run as non-root user
ENTRYPOINT ["aTrain", "startserver"]
