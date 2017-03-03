FROM alpine:latest

ENV JMETER_HOME=/opt/jmeter \
    JMETER_VERSION=3.1 \
    PATH=/opt/jmeter/bin/:$PATH \
    PLUGINS_PATH=/tmp/plugins \
    TIMEZONE=Europe/Warsaw

RUN apk --update add openjdk8-jre-base openssl unzip tzdata fontconfig ttf-dejavu\
 && mkdir -p ${JMETER_HOME} \
 && wget -O /tmp/jmeter.tgz http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
 && tar -C /tmp -xvzf /tmp/jmeter.tgz \
 && mv /tmp/apache-jmeter-${JMETER_VERSION}/* ${JMETER_HOME} \
 && rm -rf /tmp/jmeter.tgz /tmp/apache-jmeter-${JMETER_VERSION} /var/cache/apk/* \
 && cp /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
 && echo "$TIMEZONE" >  /etc/timezone \
 && mkdir -p $PLUGINS_PATH \
 && wget https://jmeter-plugins.org/files/packages/jpgc-cmd-2.1.zip \
 && unzip -o -d $PLUGINS_PATH jpgc-cmd-2.1.zip \
 && cp $PLUGINS_PATH/lib/*.jar $JMETER_HOME/lib/ \
 && cp $PLUGINS_PATH/bin/* $JMETER_HOME/bin/ \
 && cp $PLUGINS_PATH/lib/ext/*.jar $JMETER_HOME/lib/ext/ \
 && wget -q http://download.softagency.net/MySQL/Downloads/Connector-J/mysql-connector-java-5.1.41.zip \
 && unzip -o -d $PLUGINS_PATH mysql-connector-java-5.1.41.zip \
 && cp $PLUGINS_PATH/mysql-connector-java-5.1.41/mysql-connector-java-5.1.41-bin.jar $JMETER_HOME/lib/mysql-connector-java-5.1.41-bin.jar \
 && rm -rf $PLUGINS_PATH \
 && wget -O $JMETER_HOME/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
 && wget -O  $JMETER_HOME/lib/cmdrunner-2.0.jar http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar

ADD user.properties $JMETER_HOME/bin/
WORKDIR /opt/jmeter/
RUN ./bin/jmeter.sh -n -v \
 && java -cp /opt/jmeter/lib/ext/jmeter-plugins-manager-0.11.jar org.jmeterplugins.repository.PluginManagerCMDInstaller
RUN ./bin/PluginsManagerCMD.sh  install jpgc-oauth,jpgc-json,jpgc-casutg,jpgc-graphs-additional,jpgc-synthesis

CMD  ["./bin/jmeter.sh -n -h"]