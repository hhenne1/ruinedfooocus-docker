#!/bin/bash
cd /fooocus
echo "Starting RuinedFooocus..."
exec python launch.py --listen 2>&1 | tee /dev/stdout
