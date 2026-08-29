# Local Hugo environment, pinned to the same version CI uses (see
# .github/workflows/hugo.yml). Extended edition — the theme uses SCSS.
#
#   Serve (live reload, drafts):  docker compose up
#   One-off production build:     docker compose run --rm hugo hugo --minify
#
# Architecture is detected from the base image (arm64 / amd64), so this builds
# natively on both Apple Silicon and x86 without depending on BuildKit.
FROM debian:bookworm-slim

ARG HUGO_VERSION=0.140.2

RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates wget \
 && ARCH="$(dpkg --print-architecture)" \
 && wget -O /tmp/hugo.deb \
      "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-${ARCH}.deb" \
 && dpkg -i /tmp/hugo.deb \
 && apt-get purge -y --auto-remove wget \
 && rm -rf /tmp/hugo.deb /var/lib/apt/lists/*

WORKDIR /src
EXPOSE 1313

ENTRYPOINT ["hugo"]
# Default: dev server bound to all interfaces (so it's reachable from the host),
# including drafts. Override with any hugo args, e.g. `hugo --minify`.
CMD ["server", "--bind", "0.0.0.0", "--baseURL", "http://localhost:1313/", "-D"]
