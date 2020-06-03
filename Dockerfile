FROM openjdk:alpine
MAINTAINER foresterre <garm@ilumeo.com>

ENV SERVER_PORT 25565

WORKDIR /minecraft

USER root

COPY ./settings-local.sh /minecraft/cfg/settings-local.sh

RUN adduser -D minecraft
RUN apk --no-cache add curl wget
RUN mkdir -p /minecraft/world
RUN mkdir -p /minecraft/cfg
RUN mkdir -p /minecraft/backups
RUN curl -SLO https://media.forgecdn.net/files/2787/18/SkyFactory_4_Server_4.1.0.zip
RUN unzip SkyFactory_4_Server_4.1.0.zip
RUN mv SkyFactory_4_Server_4.1.0/* .
RUN echo "eula=true" > /minecraft/eula.txt
RUN ls
RUN chmod u+x /minecraft/*.sh
RUN echo "[]" > /minecraft/cfg/ops.json
RUN echo "[]" > /minecraft/cfg/whitelist.json
RUN echo "[]" > /minecraft/cfg/banned-ips.json
RUN echo "[]" > /minecraft/cfg/banned-players.json
#RUN echo "[]" > /minecraft/cfg/server.properties
RUN ln -s /minecraft/cfg/ops.json /minecraft/ops.json
RUN ln -s /minecraft/cfg/whitelist.json /minecraft/whitelist.json
RUN ln -s /minecraft/cfg/banned-ips.json /minecraft/banned-ips.json
RUN ln -s /minecraft/cfg/banned-players.json /minecraft/banned-players.json
#RUN ln -s /minecraft/cfg/server.properties /minecraft/server.properties
RUN ln -s /minecraft/cfg/settings-local.sh /minecraft/settings-local.sh
RUN chown -R minecraft:minecraft /minecraft

USER minecraft

RUN /bin/sh /minecraft/Install.sh

VOLUME ["/minecraft/world"]
VOLUME ["/minecraft/cfg"]
VOLUME ["/minecraft/backups"]

EXPOSE ${SERVER_PORT}

CMD ["/bin/sh", "/minecraft/ServerStart.sh"]
