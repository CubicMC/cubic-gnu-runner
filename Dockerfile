FROM ubuntu:22.04

RUN apt update

RUN apt install -y gcc-12 g++-12 cmake pkg-config gtkmm-3.0
