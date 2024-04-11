A self-contained, sandboxed container image that will build and install
[aseprite](https://www.aseprite.org/).

**TL;DR**: build and install latest version under `/usr/local`:
```
# build the builder image:
make

# build latest `aseprite` using the builder image:
docker run -it --rm \
  -v /usr/local:/out \
    build-aseprite
```

Choose the version to build by setting environment variables (defaults to
`HEAD` for bleeding edge):
- [`ASEPRITE_VERSION`](https://github.com/aseprite/aseprite/releases)

Binaries will be installed into the container's directory `/out`. Mount that
directory with `-v host_dir:/out` to install it into some host directory.

Customize the base installation directory by setting the environment variable
`PREFIX_DIR`. Defaults to `/usr/local`.

Example: install under `~/opt` with specific versions:
```
OUT_DIR="$HOME/opt"
mkdir -p "${OUT_DIR}"
# build aseprite using the build image
docker run -it --rm \
  -v "${OUT_DIR}:/out" \
  -e "ASEPRITE_VERSION=v1.2.3" \
    build-aseprite
```
