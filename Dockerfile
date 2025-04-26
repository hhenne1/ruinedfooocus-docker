FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies (e.g., Python, git)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the necessary files from the main repository
COPY . /app

# Install the requirements for RuinedFooocus
COPY ruinedfooocus-code/requirements_versions.txt /app/requirements_versions.txt
RUN pip3 install -r requirements_versions.txt
# Copy the RuinedFooocus code from the submodule.
COPY ruinedfooocus-code /app
# Expose the port that RuinedFooocus listens on
EXPOSE 7860

# Define a healthcheck.  This command checks if the application is
# running correctly.  A failed healthcheck will cause the container
# to be restarted.  This assumes that the application listens on port 7860
# and that a simple HTTP GET request will return a 200 status code
# if the application is healthy.  Adjust the port and endpoint as needed.
HEALTHCHECK --interval=60s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Add a volume.  This is good practice to allow the user to mount
# a directory from the host machine.  This is commonly used for
# storing generated images, models, or configuration.
VOLUME /app/settings
VOLUME /app/models
VOLUME /app/wildcards

# Command to run RuinedFooocus
CMD ["python3", "launch.py", "--listen"]
