FROM ubuntu:22.04

RUN apt update

RUN apt install -y gcc-12 g++-12 cmake pkg-config libgtkmm-3.0-dev
