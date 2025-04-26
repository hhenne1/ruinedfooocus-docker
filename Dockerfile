FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies (e.g., Python, git)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-dev python3-pip git python3-venv && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app
COPY . /app

# Install RuinedFooocus from the submodule
COPY ruinedfooocus-code/ /fooocus/
WORKDIR /fooocus
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install -r requirements_versions.txt
RUN pip3 install gfpgan==1.3.8 filterpy
RUN pip3 install insightface==0.7.3

# Expose the port that RuinedFooocus listens on
EXPOSE 7865

# Define a healthcheck.
HEALTHCHECK --interval=60s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:7865/ || exit 1

# Add volumes
#VOLUME /fooocus/cache
VOLUME /fooocus/settings
VOLUME /fooocus/models
VOLUME /fooocus/wildcards

# Startup
CMD ["python3", "launch.py", "--listen"]
