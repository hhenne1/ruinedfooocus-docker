FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    python3 python3.10-dev python3-pip python3.10-venv git build-essential libpq-dev libffi-dev libsm6 libxext6 ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# copy RuinedFooocus submodule and install dependencies in a venv
COPY ruinedfooocus-code/ /fooocus/
WORKDIR /fooocus
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip3 install --upgrade pip setuptools wheel
RUN pip3 install -r requirements_versions.txt
RUN pip3 install gfpgan==1.3.8 filterpy insightface==0.7.3 torchaudio

# Expose the port that RuinedFooocus listens on
EXPOSE 7860

# Define a healthcheck.
HEALTHCHECK --interval=60s --timeout=30s --retries=3 \
    CMD curl -f http://localhost:7865/ || exit 1

# Add volumes
VOLUME /fooocus/cache
VOLUME /fooocus/settings
VOLUME /fooocus/models
VOLUME /fooocus/wildcards
VOLUME /fooocus/outputs

# Startup
CMD ["python3", "launch.py", "--listen"]
