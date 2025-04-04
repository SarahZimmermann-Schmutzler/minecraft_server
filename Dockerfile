# base image: contains a Java environment because the Minecraft server requires a JVM (Java Virtual Machine).
FROM openjdk:21-jdk-slim

# directory on the container that contains all the data
WORKDIR /app

# all contents of the current directory are copied to the folder named under the variable WORKDIR
COPY . $WORKDIR

#accepts the Minecraft EULA (End User License Agreement)
# is required by the Minecraft server to start
RUN echo "eula=true" > /app/eula.txt

# port of the container that is opened for external access
# 25565 is the standard port of the Minecraft Server
EXPOSE 25565

# Start the Minecraft server directly
ENTRYPOINT ["java", "-Xmx1024M", "-Xms512M", "-jar", "/app/server.jar", "nogui"]