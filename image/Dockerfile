# Pull images from know safe locations and not from randomer on the internet ;)
# Idealy mirroring through our own Artifactory instance or similar to reduce risk from a supply chain attack
ARG CONTAINER_REGISTRY="registry.access.redhat.com/"
ARG BUILD_IMAGE_BASE="ubi8/ubi"
ARG BUILD_IMAGE_BASE_VERSION="8.5-226@sha256:cbc1e8cea8c78cfa1490c4f01b2be59d43ddbbad6987d938def1960f64bcd02c"
ARG BUILD_IMAGE="${CONTAINER_REGISTRY}${BUILD_IMAGE_BASE}:${BUILD_IMAGE_BASE_VERSION}"
# Alpine is a common minimal image, but Redhat's Universal Base image is better for production as it is more security focused
# and will usually have security issues fixed quicker. NOTE I am not using a premium subscription so there may be vulnerabilities in this image
ARG FINAL_IMAGE_BASE="ubi8/ubi8-minimal"
ARG FINAL_IMAGE_BASE_VERSION="8.5-230@sha256:3aa3f379a81013bd3264faa0af87d201cdaa5981050d78c567b48fdfd5b38bb8"
ARG FINAL_IMAGE="${CONTAINER_REGISTRY}${FINAL_IMAGE_BASE}:${FINAL_IMAGE_BASE_VERSION}"

ARG LITECOIN_VERSION="0.18.1"

FROM ${CONTAINER_REGISTRY}${BUILD_IMAGE_BASE}:${BUILD_IMAGE_BASE_VERSION} as build-image
ARG LITECOIN_VERSION

COPY CHECKSUMS /CHECKSUMS

# using an intermediate image for the
# set -x to fail fast
# Always attempt to update OS packages don't assume the image maintainer is providing them
# Reduce the layers to a minimum to prevent the image bloating in size. Multiple RUNS used if build time is an issue and
# you can leverage layer caching, but in production we disable caching to ensure everything is fully upto date.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Ignore DL3003 Use WORKDIR to switch to a directory as we do not care for the build image
# hadolint ignore=DL3003
RUN set -x \
    && yum upgrade -y \
    && yum clean all \
    && mkdir /litecoin; cd /litecoin \
    && curl -O "https://download.litecoin.org/litecoin-${LITECOIN_VERSION}/linux/litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz" \
    && sha256sum -c /CHECKSUMS 2>&1 | grep OK \
    && tar -xzvf "litecoin-${LITECOIN_VERSION}-x86_64-linux-gnu.tar.gz" \
    && echo "TODO: Implement GPG Verification https://download.litecoin.org/README-HOWTO-GPG-VERIFY-TEAM-MEMBERS-KEY.txt"



FROM  ${CONTAINER_REGISTRY}${FINAL_IMAGE_BASE}:${FINAL_IMAGE_BASE_VERSION} as final-image

ARG LITECOIN_VERSION

ENV USER="litecoin"
ENV GROUP="litecoin"
ENV LITECOIN_PERSISTANT_DATA="${HOME}/.litecoin"

RUN set -x \
    && microdnf upgrade -y \
    && microdnf install shadow-utils python3 -y  \
    && microdnf clean all  \
    && groupadd --gid 1000 --system "${GROUP}" \
    && useradd --uid 1000 --system --gid "${USER}" --create-home "${USER}"

COPY --from=build-image /litecoin/litecoin-${LITECOIN_VERSION}/bin /usr/local/bin
COPY scripts/ /home/${USER}
COPY entrypoint.sh /

# This is where a persistant volume will mount
VOLUME "${LITECOIN_PERSISTANT_DATA}"

RUN mkdir -p "${LITECOIN_PERSISTANT_DATA}" \
    && chmod 770 "$LITECOIN_PERSISTANT_DATA" \
    && chown -R "${USER}":"${GROUP}" "$LITECOIN_PERSISTANT_DATA"

# Always use non root user
USER "${USER}"

# Expose does not actual do anything, It is used as an indicator to others which ports this application runs
# I pulled the default ports from https://litecoin.info/index.php/Litecoin.conf
# 9332 - Listen for RPC connections
# 9333 - listen for connections

EXPOSE 9332 9333

ENTRYPOINT ["/entrypoint.sh"]