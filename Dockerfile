FROM myoung34/github-runner:latest

RUN echo $'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main\n\
    deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main\n' >> /etc/apt/sources.list

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt update

RUN apt install -y clang-15

RUN apt install -y cmake

# Install gcc-12 (Pain)

ENV GCC_VERSION "12.2.0"
ENV INSTALLDIR "/platform"

RUN apt install -y gcc-multilib

RUN cd /tmp && \
    wget https://mirror.koddos.net/gcc/releases/gcc-${GCC_VERSION}/gcc-${GCC_VERSION}.tar.xz && \
    tar -xf gcc-${GCC_VERSION}.tar.xz && \
    cd gcc-${GCC_VERSION} && \
    ./contrib/download_prerequisites

RUN cd /tmp \
    && mkdir gcc-build \
    && cd gcc-build \
    && ../gcc-${GCC_VERSION}/configure                      \
    --prefix=${INSTALLDIR}                           \
    --enable-shared                                  \
    --enable-threads=posix                           \
    --enable-__cxa_atexit                            \
    --enable-clocale=gnu                             \
    --enable-languages=all                           \
    && make -j4 \
    && make install

RUN rm -rf /tmp/gcc-${VERSION}.tar.xz /tmp/gcc-${VERSION} /tmp/gcc-build
