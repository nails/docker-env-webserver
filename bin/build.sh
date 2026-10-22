#!/usr/bin/env bash
#
# Build one or more image directories under ./apache.
#
#   bin/build.sh php85 php85-nails ...
#       Builds each directory for linux/amd64 AND linux/arm64 and pushes a
#       multi-arch manifest to Docker Hub as nails/docker-env-webserver:apache-<dir>.
#       Works the same from an Apple Silicon Mac or an x86 machine; the
#       non-native architecture is built under emulation, so it is slower.
#
#   LOCAL=1 bin/build.sh php85 php85-nails ...
#       Builds for the host architecture only and loads the result into the
#       local Docker image store. Nothing is pushed. Use this to test changes.
#
# Environment:
#   PLATFORMS  Platforms to build (default: linux/amd64,linux/arm64)
#   BUILDER    buildx builder to use/create (default: nails-multiarch)
#
# Directories are built in the order given. Framework and xdebug images use
# FROM nails/docker-env-webserver:apache-<parent>, which a multi-arch build
# pulls from Docker Hub, so always build (and therefore push) parents first.

set -euo pipefail

REPO="nails/docker-env-webserver"
PLATFORMS="${PLATFORMS:-linux/amd64,linux/arm64}"
BUILDER="${BUILDER:-nails-multiarch}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ $# -eq 0 ]; then
    echo "Usage: [LOCAL=1] $0 <dir> [<dir>...]   (e.g. php85 php85-nails)" >&2
    exit 1
fi

for dir in "$@"; do
    if [ ! -f "$ROOT/apache/$dir/Dockerfile" ]; then
        echo "ERROR: $ROOT/apache/$dir/Dockerfile not found" >&2
        exit 1
    fi
done

# --------------------------------------------------------------------------
# Local, single-architecture build (no push)
# --------------------------------------------------------------------------

if [ "${LOCAL:-0}" = "1" ]; then
    for dir in "$@"; do
        echo "==> [local] $REPO:apache-$dir"
        docker build -t "$REPO:apache-$dir" "$ROOT/apache/$dir"
    done
    exit 0
fi

# --------------------------------------------------------------------------
# Multi-architecture build and push
# --------------------------------------------------------------------------

# The default "docker" driver cannot build multiple platforms into one
# manifest, so use a dedicated docker-container builder. It is created once
# and reused; it does not change the machine's default builder.
if ! docker buildx inspect "$BUILDER" >/dev/null 2>&1; then
    echo "==> Creating buildx builder '$BUILDER'"
    docker buildx create --name "$BUILDER" --driver docker-container --bootstrap
fi

for dir in "$@"; do
    tag="$REPO:apache-$dir"
    echo "==> [$PLATFORMS] $tag"

    # --pull so framework images always pick up the parent that was pushed
    # moments ago, rather than a stale copy in the builder's cache.
    docker buildx build \
        --builder "$BUILDER" \
        --platform "$PLATFORMS" \
        --pull \
        --push \
        --tag "$tag" \
        "$ROOT/apache/$dir"

    # Verify the published manifest has every requested platform, so an
    # incomplete push fails loudly here instead of on a production server.
    published=$(docker buildx imagetools inspect "$tag" \
        | awk '/Platform:/ {print $2}' \
        | grep -v '^unknown/' \
        | sort -u \
        | paste -sd, -)

    for platform in ${PLATFORMS//,/ }; do
        case ",$published," in
            *",$platform,"*) ;;
            *)
                echo "ERROR: $tag is missing $platform (published: ${published:-none})" >&2
                exit 1
                ;;
        esac
    done

    echo "==> OK $tag [$published]"
done
