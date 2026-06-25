FROM eclipse-temurin:21-jdk AS build

WORKDIR /workspace
COPY PerpusYUK/web /workspace/web
COPY PerpusYUK/src/java /workspace/src/java

RUN mkdir -p /workspace/web/WEB-INF/classes \
    && find /workspace/src/java -name "*.java" > /workspace/sources.txt \
    && javac -encoding UTF-8 -cp "/workspace/web/WEB-INF/lib/*" -d /workspace/web/WEB-INF/classes @/workspace/sources.txt

FROM tomcat:10.1-jdk21-temurin

ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /workspace/web /usr/local/tomcat/webapps/ROOT

EXPOSE 8080
