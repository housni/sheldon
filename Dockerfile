FROM bash:4.3
MAINTAINER Housni Yakoob <housni.yakoob@gmail.com>

ARG SHELLCHECK_VERSION="stable"

RUN apk --update add --no-cache \
        git \
    && rm -rf /var/cache/apk

# Install a custom version of 'shellcheck'.
RUN wget -nv "https://storage.googleapis.com/shellcheck/shellcheck-${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
    && tar --xz -xvf shellcheck-"${SHELLCHECK_VERSION}".linux.x86_64.tar.xz \
    && cp shellcheck-"${SHELLCHECK_VERSION}"/shellcheck /usr/bin/ \
    && shellcheck --version

# Install dockerfilelint.
RUN git clone --depth 1 https://github.com/replicatedhq/dockerfilelint.git ./dockerfilelint \
    && ln -s ${PWD}/dockerfilelint/bin/dockerfilelint /usr/bin/dockerfilelint # \
#    && dockerfilelint --version

WORKDIR /usr/lib/sheldon

ENTRYPOINT ["./.ci/build.sh"]
