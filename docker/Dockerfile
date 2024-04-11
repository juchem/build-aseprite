FROM debian:testing-slim

#################
# base settings #
#################

ENV DEBIAN_PRIORITY=critical
ENV DEBIAN_FRONTEND=noninteractive

RUN truncate --size=0 /etc/apt/sources.list
RUN rm -rf /etc/apt/sources.list.d
RUN mkdir -p /etc/apt/sources.list.d
COPY debian-testing.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
  ca-certificates \
  file cpio coreutils time \
  curl wget git \
  gzip bzip2 xz-utils 7zip \
  gettext gettext-base pkgconf \
  python-is-python3 python3 python3-dev \
  build-essential \
  g++ clang clang-format \
  cmake cmake-extras meson ninja-build \
  gdb



# aseprite repo: https://github.com/aseprite/aseprite

ENV ASEPRITE_SRC="/src/aseprite"

RUN mkdir -p "${ASEPRITE_SRC}"
RUN cd "${ASEPRITE_SRC}" \
  && git init \
  && git remote add origin "https://github.com/aseprite/aseprite.git"

# aseprite build deps
# - https://github.com/aseprite/aseprite/blob/main/INSTALL.md

RUN apt-get install -y --no-install-recommends \
  libssl-dev libcrypt-dev \
  qt6-wayland-dev \
  libasio-dev libasound2-dev \
  libfdk-aac-dev \
  libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev libavutil-dev \
  libcmocka-dev libcurl4-openssl-dev libdrm-dev libfdk-aac-dev \
  libfontconfig-dev libfreetype6-dev \
  libgl1-mesa-dev libgles2-mesa-dev libglvnd-dev \
  libjack-jackd2-dev libjansson-dev libluajit-5.1-dev libmbedtls-dev \
  libpci-dev libpipewire-0.3-dev libpulse-dev libqrcodegencpp-dev \
  librist-dev libsndio-dev libspeexdsp-dev libsrt-openssl-dev libswresample-dev \
  libswscale-dev libudev-dev libv4l-dev libva-dev libvlc-dev libvpl-dev \
  libwayland-dev libwebsocketpp-dev nlohmann-json3-dev \
  libx11-dev libx11-xcb-dev libx264-dev \
  libxcb-composite0-dev libxcb-randr0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-xinerama0-dev \
  libxcb1-dev libxcomposite-dev libxinerama-dev libxss-dev \
  libqt6svg6-dev qt6-base-dev qt6-base-private-dev qt6-image-formats-plugins qt6-wayland

RUN apt-get install -y --no-install-recommends \
  libharfbuzz-dev \
  libfreetype-dev \
  libx11-dev \
  libxcursor-dev \
  libxi-dev \
  libgl1-mesa-dev \
  libfontconfig1-dev \
  xorg-dev \
  libwlroots-dev



# aseprite/skia repo: https://github.com/aseprite/skia

ENV SKIA_SRC="/src/skia"
ENV SKIA_VERSION="aseprite-m102"

RUN mkdir -p "${SKIA_SRC}"
RUN cd "${SKIA_SRC}" \
  && git init \
  && git remote add origin "https://github.com/aseprite/skia.git"



# depot_tools repo: https://github.com/aseprite/skia

ENV DEPOT_TOOLS_SRC="/src/depot_tools"
ENV PATH="${PATH}:${DEPOT_TOOLS_SRC}"

RUN mkdir -p "${DEPOT_TOOLS_SRC}"
RUN cd "${DEPOT_TOOLS_SRC}" \
  && git init \
  && git remote add origin "https://chromium.googlesource.com/chromium/tools/depot_tools.git"



# finish

RUN apt autoremove --purge -y
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/*

WORKDIR "/src"
RUN mkdir -p /out

ENV PREFIX_DIR="/out"

COPY entrypoint.sh /srv
ENTRYPOINT "/srv/entrypoint.sh"
