#!/bin/bash

cd /root/aquasim-ng/ns-3.29
python waf configure --build-profile=debug --enable-examples --disable-python
python waf clean
cp ./src/applications/model/onoff-application.h ./build/ns3
python waf build