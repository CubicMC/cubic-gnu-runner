FROM myoung34/github-runner:latest

RUN echo $'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main\n\
    deb-src http://apt.llvm.org/focal/ llvm-toolchain-focal-15 main\n' >> /etc/apt/sources.list

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt update

RUN apt install -y clang-15

RUN apt install -y cmake

RUN apt install -y pkg-config

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
    --enable-languages=c,c++                           \
    && make -j8 \
    && make install \
    && rm -rf /tmp/gcc-${GCC_VERSION}.tar.xz \
    /tmp/gcc-${GCC_VERSION} \
    /tmp/gcc-build

RUN echo $'/plaform/lib\n\
    /platform/lib32\n\
    /platform/lib64\n' > /etc/ld.so.conf.d/gcc12.conf

RUN ldconfig -v

RUN python3 -m pip install meson

RUN python3 -m pip install ninja

RUN cd /tmp && \
    wget https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.7.tar.xz && \
    tar -xf gtkmm-3.24.7.tar.xz

RUN cd /tmp && \
    cd gtkmm-3.24.7 && \
    mkdir gtkmm3-build && \
    cd gtkmm3-build && \
    meson --prefix=/usr --buildtype=release .. && \
    ninja && \
    ninja install