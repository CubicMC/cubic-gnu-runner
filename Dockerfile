FROM eclipse-temurin:17.0.7_7-jdk-focal as jre-build

# Generate smaller java runtime without unneeded files
# for now we include the full module path to maintain compatibility
# while still saving space
RUN jlink \
         --add-modules ALL-MODULE-PATH \
         --no-man-pages \
         --compress=2 \
         --output /javaruntime

FROM ubuntu:22.04

RUN apt update

RUN apt install -y gcc-12 g++-12 cmake pkg-config libgtkmm-3.0-dev openjdk-11-jdk
