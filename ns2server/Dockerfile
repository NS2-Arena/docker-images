# check=skip=FromPlatformFlagConstDisallowed,SecretsUsedInArgOrEnv
FROM --platform=amd64 cm2network/steamcmd:root AS builder
RUN mkdir /gamedata
RUN chown -R "steam:steam" /gamedata
USER steam
RUN ./steamcmd.sh \
  +force_install_dir /gamedata \
  +login anonymous \
  +app_update 4940 validate \
  +exit

# Use gamedata from builder stage to build minimal server image
FROM --platform=amd64 ubuntu:24.04

USER root

RUN apt update && \
  apt upgrade -y && \
  apt install -y --no-install-recommends unzip jq && \
  rm -rf /var/cache/apt/archives /var/lib/apt/lists

# TODO: These RUNs should probably not be cached to make sure we always have the latest version of awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip -q awscliv2.zip
RUN ./aws/install
RUN rm awscliv2.zip

RUN useradd -m ns2arena
USER ns2arena

WORKDIR /home/ns2arena

USER root

# Setup directories
RUN mkdir /server
RUN mkdir /gamedata

COPY --chown=ns2arena:ns2arena run.sh /home/ns2server/run.sh
RUN chmod +x /home/ns2server/run.sh

# Setup permissions
RUN chown -R "ns2server:ns2server" /server
RUN chown -R "ns2server:ns2server" /gamedata

COPY --chown=ns2arena:ns2arena --from=builder /gamedata /gamedata

USER ns2arena

EXPOSE 27015/udp
EXPOSE 27016/udp
EXPOSE 27017

ENV NAME="NS2 Dedicated Server"
ENV MAP="ns2_veil"

# Required vars to be set by the host
ENV PASSWORD=""
ENV LAUNCH_CONFIG=""
ENV TASK_TOKEN=""

SHELL ["/bin/bash", "-c"]
ENTRYPOINT /home/steam/run.sh "${NAME}" "${MAP}" "${PASSWORD}" "${LAUNCH_CONFIG}"
