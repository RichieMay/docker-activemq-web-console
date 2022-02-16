FROM richiemay/alpine-jdk:8u301

# Setup useful environment variables
ENV APPLICATION_VERSION     5.16.2
ENV APPLICATION_NAME        jetty-activemq-web-console
ENV APPLICATION_INSTALL     /opt/${APPLICATION_NAME}

# Setup initial directory structure.
RUN mkdir -p "${APPLICATION_INSTALL}" && chmod -R 700 "${APPLICATION_INSTALL}"

# Add application
RUN curl -jksSL "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.39.v20210325/jetty-distribution-9.4.39.v20210325.tar.gz" | \
    tar -zxf - -C /opt && \
    cp -a "/opt/jetty-distribution-9.4.39.v20210325/." "${APPLICATION_INSTALL}" && \
    rm -rf "/opt/jetty-distribution-9.4.39.v20210325" && \
    curl -o "${APPLICATION_INSTALL}/webapps/ROOT.war" -ksSL "https://repo1.maven.org/maven2/org/apache/activemq/activemq-web-console/${APPLICATION_VERSION}/activemq-web-console-${APPLICATION_VERSION}.war"

# alpine bash has a bug that execute [ -r file ], so del the rows
RUN sed -i '268,273d' "${APPLICATION_INSTALL}/bin/jetty.sh" 

# Expose default HTTP connector port.
EXPOSE 8080

# Set the default working directory as the program logs directory.
WORKDIR "${APPLICATION_INSTALL}"

# Run program as a foreground process by default.
ENTRYPOINT ["bin/jetty.sh", "run"]
