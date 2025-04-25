# Dockerfile for RuinedFooocus
#
# This Dockerfile automates the process of building a Docker image for RuinedFooocus.
# It's designed to:
#   1. Use an Ubuntu base image.
#   2. Install necessary dependencies (git, python3, pip).
#   3. Clone the RuinedFooocus repository.
#   4. Set up the required environment.
#   5. Define the entrypoint to run RuinedFooocus.
#
# Key differences from a generic Python Dockerfile:
#   - Explicitly clones the RuinedFooocus repository.
#   - Assumes specific directory structure and execution commands.
#   - Includes a healthcheck.

# Use Ubuntu as the base image.  This is a common choice for Python
# applications and provides a stable environment.
FROM ubuntu:22.04

# Prevent interactive prompts during package installation.  This is
# crucial forDockerfile builds to ensure they can be automated.
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies.  These are the tools needed to
# clone the repository and run the application.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    python3 \
    python3-pip \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip to the latest version.  This ensures we're using
# a current version of the package installer.
RUN pip3 install --upgrade pip

# Clone the RuinedFooocus repository.  This downloads the application
# source code into the container.
RUN git clone https://github.com/runew0lf/RuinedFooocus /app

# Install Python dependencies.  This uses pip to install the
# packages listed in the requirements.txt file.
RUN pip3 install -r /app/requirements.txt

# Copy the entire application.  While the clone already put it in
# /app, this ensures that any local changes in the same directory
# as the Dockerfile get copied into the image.  If the clone is
# sufficient, this can be removed.
# COPY . /app

# Set the working directory.  This is the directory where commands
# like `CMD` and `ENTRYPOINT` will be executed.
WORKDIR /app

# Define the entrypoint.  This is the command that will be run
# when the container starts.  It assumes that RuinedFooocus is run
# by executing a Python script.  Adjust this as needed.
ENTRYPOINT ["python3", "run_fooocus.py"]

# Define a healthcheck.  This command checks if the application is
# running correctly.  A failed healthcheck will cause the container
# to be restarted.  This assumes that the application listens on port 7860
# and that a simple HTTP GET request will return a 200 status code
# if the application is healthy.  Adjust the port and endpoint as needed.
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Expose the port that RuinedFooocus listens on.  This makes the
# application accessible from outside the container.  The default
# port is often 7860, but this might need to be adjusted.
EXPOSE 7860

# Add a volume.  This is good practice to allow the user to mount
# a directory from the host machine.  This is commonly used for
# storing generated images, models, or configuration.
VOLUME /app/outputs
