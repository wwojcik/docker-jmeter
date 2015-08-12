FROM gliderlabs/alpine:latest

MAINTAINER Wojciech Wójcik <wojtaswojcik@gmail.com>

ENV JMETER_HOME=/opt/jmeter \
    JMETER_VERSION=2.13 \
    PLUGINS_VERSION=1.3.0 \
    PATH=/opt/jmeter/bin/:$PATH
ENV PLUGINS_PATH $JMETER_HOME/plugins

RUN apk --update add openjdk7-jre-base openssl unzip \
    && mkdir -p ${JMETER_HOME} \
    && wget -O /tmp/jmeter.tgz http://ftp.piotrkosoft.net/pub/mirrors/ftp.apache.org//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz \
    && tar -C /tmp -xvzf /tmp/jmeter.tgz \
    && mv /tmp/apache-jmeter-${JMETER_VERSION}/* ${JMETER_HOME} \
    && rm -rf /tmp/jmeter.tgz /tmp/apache-jmeter-${JMETER_VERSION} /var/cache/apk/*

RUN mkdir -p $PLUGINS_PATH && \
    wget -q http://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-$PLUGINS_VERSION.zip && \
    unzip -o -d $PLUGINS_PATH JMeterPlugins-ExtrasLibs-$PLUGINS_VERSION.zip && \
    wget -q http://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-$PLUGINS_VERSION.zip && \
    unzip -o -d $PLUGINS_PATH JMeterPlugins-Extras-$PLUGINS_VERSION.zip && \
    wget -q http://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-$PLUGINS_VERSION.zip && \
    unzip -o -d $PLUGINS_PATH JMeterPlugins-Standard-$PLUGINS_VERSION.zip
# Copy plugins to jmeter enviroment
RUN cp $PLUGINS_PATH/lib/*.jar $JMETER_HOME/lib/
RUN cp $PLUGINS_PATH/lib/ext/*.jar $JMETER_HOME/lib/ext/
RUN wget -O $JMETER_HOME/lib/postgresql-9.4-1201.jdbc41.jar https://jdbc.postgresql.org/download/postgresql-9.4-1201.jdbc41.jar

ADD user.properties $JMETER_HOME/bin/


ENTRYPOINT ["/opt/jmeter/bin/jmeter.sh"]
CMD  ["-h"]