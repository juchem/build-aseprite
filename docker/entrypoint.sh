#!/bin/bash -xe

build_aseprite() {
  pushd "${ASEPRITE_SRC}" > /dev/null

  build_version="${ASEPRITE_VERSION:-HEAD}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive --depth=1

  # https://github.com/aseprite/aseprite/blob/main/INSTALL.md
  mkdir -p "${ASEPRITE_SRC}/build"
  pushd "${ASEPRITE_SRC}/build" > /dev/null
  (set -x; \
    CFLAGS='-Wno-deprecated-declarations' \
    CXXFLAGS='-Wno-deprecated-declarations' \
      time cmake -G Ninja \
        -DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}" \
        -DCMAKE_BUILD_TYPE=Release \
        -DLAF_BACKEND=skia \
        -DSKIA_DIR="${SKIA_SRC}" \
        -DSKIA_LIBRARY_DIR="${SKIA_SRC}/build" \
        .. \
    && time ninja \
    && time ninja install \
  )
  popd > /dev/null

  popd > /dev/null

  rm -rf \
    "${PREFIX_DIR}/bin/curl-config" \
    "${PREFIX_DIR}/include" \
    "${PREFIX_DIR}/lib" \
    "${PREFIX_DIR}/share/man"
}

build_skia() {
  pushd "${SKIA_SRC}" > /dev/null

  build_version="${SKIA_VERSION:-HEAD}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd
  git submodule update --init --recursive --depth=1

  # https://github.com/aseprite/skia?tab=readme-ov-file#skia-on-linux
  (set -x; )
  (set -x; \
    time python3 tools/git-sync-deps \
    && time gn gen build \
      --args="is_debug=false is_official_build=true skia_use_system_expat=false skia_use_system_icu=false skia_use_system_libjpeg_turbo=false skia_use_system_libpng=false skia_use_system_libwebp=false skia_use_system_zlib=false skia_use_sfntly=false skia_use_freetype=true skia_use_harfbuzz=true skia_pdf_subset_harfbuzz=true skia_use_system_freetype2=false skia_use_system_harfbuzz=false" \
    && time ninja -C build skia modules \
  )

  popd > /dev/null
}

build_depot_tools() {
  pushd "${DEPOT_TOOLS_SRC}" > /dev/null

  build_version="${DEPOT_TOOLS_VERSION:-HEAD}"
  git fetch --depth=1 origin "${build_version}"
  git checkout -b "build-${build_version}-$(date +%s)" FETCH_HEAD
  git clean -xfd

  popd > /dev/null
}

(set -x; apt-get update)
(set -x; apt-get upgrade -y --only-upgrade --no-install-recommends)

(set -x; build_depot_tools "$@")
(set -x; build_skia "$@")
(set -x; build_aseprite "$@")

cat <<EOF

Successfully built aseprite.
EOF
