#!/bin/sh

docker run -v /etc/grid-security:/etc/grid-security \
           -v /etc/voms.json:/etc/voms.json \
           -v /etc/atrope:/etc/atrope \
           -v /mnt/data/image_data:/image_data \
           egifedcloud/atrope atrope --debug dispatch
