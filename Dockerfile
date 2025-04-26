FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install necessary dependencies (e.g., Python, git)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 python3-pip git && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app
COPY . /app

# Install the requirements for RuinedFooocus
COPY ruinedfooocus-code/requirements_versions.txt /fooocus/requirements_versions.txt

# Copy the RuinedFooocus code from the submodule
COPY ruinedfooocus-code/ /fooocus/
WORKDIR /fooocus
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install -r requirements_versions.txt
RUN pip3 install insightface==0.7.3 gfpgan==1.3.8 git+https://github.com/rodjjo/filterpy.git --require-virtualenv

# Expose the port that RuinedFooocus listens on
EXPOSE 7865

# Define a healthcheck.
HEALTHCHECK --interval=60s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:7860/ || exit 1

# Add volumes
#VOLUME /fooocus/cache
VOLUME /fooocus/settings
VOLUME /fooocus/models
VOLUME /fooocus/wildcards

# Startup
CMD ["python3", "launch.py", "--listen"]
