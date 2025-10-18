# check=skip=FromPlatformFlagConstDisallowed
FROM --platform=amd64 cm2network/steamcmd:root

# Setup directories
RUN mkdir /server
RUN mkdir /gamedata

COPY config.txt /server/config.txt
COPY run.sh /server/run.sh
RUN chmod +x /server/run.sh

# Setup permissions
RUN chown -R "steam:steam" /server
RUN chown -R "steam:steam" /gamedata

# Be the steam user
USER steam

# Run steamcmd, download and validate server
# 
# TODO: Remove un-needed files
RUN ./steamcmd.sh \
  +force_install_dir /gamedata \
  +login anonymous \
  +app_update 4940 validate \
  +exit

EXPOSE 27015/udp
EXPOSE 27016/udp

ENTRYPOINT ["/server/run.sh"]
