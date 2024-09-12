#FROM debian:latest
# https://github.com/JuergenFleiss/aTrain/pull/21
# https://github.com/SjDayg/aTrain/tree/main
# docker build --no-cache -t mbwali/atrain:v1.1.0
# docker run -it -p 8080:8080 mbwali/atrain:v1.1.0
FROM python:3.11-bullseye

# Create a non-root user and group, and set the home directory
RUN groupadd -r atrainuser && useradd --no-log-init -r -g atrainuser -d /home/atrainuser atrainuser

# Create the home directory and set appropriate permissions
RUN mkdir -p /home/atrainuser && chown atrainuser:atrainuser /home/atrainuser

# Install necessary packages as root
RUN apt update && apt install -y ffmpeg

# Set the working directory to the non-root user's home
WORKDIR /home/atrainuser

# Switch to non-root user before installing Python packages to avoid permission issues
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

