# Basis-Image
FROM debian:12-slim

# Arbeitsverzeichnis festlegen
WORKDIR / 

# Installiere JDK und notwendige Tools
RUN apt-get  update && \
  apt-get upgrade -y && \
  apt-get install -y default-jre=2:1.17-74 curl=7.88.1-10+deb12u8 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Lade und installiere Tomcat 
RUN mkdir /download && \
  cd download && \
  curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.98/bin/apache-tomcat-9.0.98.tar.gz && \
  tar -xvzf apache-tomcat-9.0.98.tar.gz -C / && \
  cd / && \
  rm -rf /download

#Copy conf files
COPY ./conf /apache-tomcat-9.0.98/copy

# Umgebungsvariablen für Tomcat und Java setzen
ENV CATALINA_HOME=/apache-tomcat-9.0.98
RUN export JRE_HOME=$(readlink -f $(which java) | sed 's:/bin/java::') && \
    echo $JRE_HOME > /jre_home.txt && \
    export JRE_HOME=$(cat /jre_home.txt) && \
    rm /jre_home.txt

# Exponiere Port 8080
EXPOSE 8080

# Start-Befehl für Tomcat
CMD ["/bin/bash", "-c", "$CATALINA_HOME/bin/catalina.sh run"]