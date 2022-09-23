FROM myoung34/github-runner:latest

RUN echo $'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-14 main\n\
deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-14 main\n' >> /etc/apt/sources.list

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt update

RUN apt install -y clang-14

RUN apt install -y cmake
