# base image: contains a Java environment because the Minecraft server requires a JVM (Java Virtual Machine).
FROM openjdk:21-jdk-slim

# directory on the container that contains all the data
WORKDIR /app

# all contents of the current directory are copied to the folder named under the variable WORKDIR
COPY . $WORKDIR

# a separate entrypoint script is used that must be made executable
# RUN chmod +x /app/entrypoint.sh

# port of the container that is opened for external access
# 25565 is the standard port of the Minecraft Server
EXPOSE 25565

# link to the entrypoint script
# ENTRYPOINT [ "/bin/sh", "-c", "/app/entrypoint.sh" ]

# Start the Minecraft server directly
ENTRYPOINT ["java", "-Xmx1024M", "-Xms512M", "-jar", "minecraft_server.1.21.4.jar", "nogui"]