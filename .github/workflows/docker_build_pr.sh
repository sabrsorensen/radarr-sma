#!/bin/bash
BASEIMAGE="ghcr.io/hotio/radarr:release"
docker pull $BASEIMAGE
TAG=${GITHUB_REF//refs\/pull\//PR}
TAG=${TAG//\/merge/}
docker buildx build \
    --platform ${ARCHITECTURE//-/\/} \
    --output "type=image,push=false" \
    --tag ghcr.io/${GITHUB_REPOSITORY}:${TAG}-${GITHUB_SHA:0:7}-${ARCHITECTURE//linux-/} \
    --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg COMMIT_AUTHOR="$(git log -1 --pretty=format:'%ae')" \
    --build-arg VCS_REF="${GITHUB_SHA}" \
    --build-arg VCS_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}" \
    --build-arg SMA_REF=`curl -sX GET "https://api.github.com/repos/mdhiggins/sickbeard_mp4_automator/commits/master" | jq '.sha' | tr -d '"'` \
    --build-arg BASE_REF=`docker inspect $BASEIMAGE --format '{{ index .Config.Labels "org.opencontainers.image.revision"}}'` \
    --file ./Dockerfile ./