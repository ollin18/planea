FROM ollin18/base:0.1

LABEL maintainer="Ollin Demian Langle Chimal <Ollin.Langle@uvm.edu>"

ENV REFRESHED_AT 2020-04-29

ADD http://dist.neo4j.org/neo4j-enterprise-3.4.10-unix.tar.gz /var/lib
RUN tar -xzvf /var/lib/neo4j-enterprise-3.4.10-unix.tar.gz
RUN mv neo4j-enterprise-3.4.10 /var/lib/neo4j

ADD src/create_db.sh /var/lib/neo4j/create_db.sh
ADD src/create_and_run.sh /var/lib/neo4j/create_and_run.sh

WORKDIR /var/lib/neo4j

VOLUME /data

ADD http://dist.neo4j.org/jexp/shell/neo4j-shell-tools_3.0.1.zip  /var/lib/neo4j/lib

RUN yes | unzip /var/lib/neo4j/lib/neo4j-shell-tools_3.0.1.zip -d /var/lib/neo4j/lib && rm /var/lib/neo4j/lib/*.zip

RUN chmod +x /var/lib/neo4j/lib/*.jar

WORKDIR /var/lib/neo4j

RUN wget https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/3.4.0.4/apoc-3.4.0.4-all.jar --directory-prefix=plugins

RUN mkdir graphml

VOLUME /data

COPY src/docker-entrypoint.sh /tmp/docker-entrypoint.sh
EXPOSE 7474 7473 7687

ENTRYPOINT ["/tmp/docker-entrypoint.sh"]

CMD ["neo4j"]
