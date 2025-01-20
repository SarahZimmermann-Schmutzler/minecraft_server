# Minecraft Server Setup And Containerization

This repository serves as a guide for containerizing a simple **Minecraft Server: Java Edition** using **Docker Compose**.  
  
This Repository was created as part of my training at the Developer Academy.  

## Table of Contents
1. <a href="#technologies">Technologies</a>  
2. <a href="#description">Description</a>  
3. <a href="#getting-started">Getting Started</a>  
4. <a href="#usage">Usage</a>  
5. <a href="#additional-notes">Additional Notes</a>  

## Technologies
* **Docker** 24.0.7
    * **Compose** v2.32.4 (module to install, <a href="https://docs.docker.com/compose/">More Information</a>)
* **Minecraft Server Java Edition** 1.21.4 (server to download, <a href="https://www.minecraft.net/de-de/download/server">More Information</a>)

## Description
### Minecraft
Minecraft is a popular sandbox game that allows players to explore, build, and adventure in their own worlds. Alone or in multiplayer mode.

### Minecraft Server
A Minecraft server is a program that allows players to play Minecraft online in a multiplayer environment. A server hosts these worlds and allows multiple players to connect and play together at the same time. A Minecraft server typically runs on a dedicated computer or virtual machine and can be operated in various configurations. Players connect to the server via its IP address and port.  
  
If you want to use mods and/or plugins, there are something to keep in mind:
- Standard Minecraft server software (vanilla) - that is used here - does not support mods, only the basic functions of the game.
    - You can customize the game a little using data packs and configuration files (like <a href="https://minecraft.wiki/w/Server.properties">server.properties</a>) (e.g. the number of players allowed, etc.)
- To use mods and/or plugins you must use an advanced server:
    - Mod-Server: <a href="https://files.minecraftforge.net/net/minecraftforge/forge/">Forge</a> or <a href="https://fabricmc.net/use/server/">Fabric</a>
    - Plugin-Server: <a href="https://getbukkit.org/download/spigot">Spigot</a> or <a href="https://papermc.io/">Paper</a>
    - Hybrid Server like <a href="https://mohistmc.com/">Mohist</a> (Forge + Plugins)

### Minecraft Server Edition
There is the *Java Edition* and the *Bedrock Edition* of Minecraft. Two different versions of the game that differ in technology, features and compatibility.  
  
This repository containerizes the **Java Server**:
- only suitable for the PC
- runs via the Java Runtime Environment (JRE)
- easy to set up
- saves resources  
  
>i: If you are interested in a cross-platform application, for example because you want to play Minecraft on a console, you need the <a href="https://www.minecraft.net/de-de/download/server/bedrock">Bedrock Server</a>.


## Getting Started
0) <a href="https://docs.github.com/de/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo">Fork</a> the project to your namespace, if you want to make changes or open a <a href="https://docs.github.com/de/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests">Pull Request</a>.

1) <a href="https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository">Clone</a> the project to your platform if you just want to use it:
    - <ins>Example</ins>: Clone the repo e.g. using an SSH-Key:  
    ```bash
    git clone git@github.com:SarahZimmermann-Schmutzler/minecraft_server.git
    ```

2) Download the Java Server file from the Minecraft webpage. For copyright reasons, the server file will not be uploaded to github.:
    ```bash
    https://www.minecraft.net/de-de/download/server
    ```

3) Make the file executable if necessary
    ```bash
    chmod +x server.jar
    ```

4) Build and start the container that runs in the background (detached mode):
    ```bash
    docker compose up --build -d
    ```

5) Check whether the server is running correctly:
- The Minecraft server can be reached under the IP address of your cloud VM on port 8888:
    - http://IP_Address_VM:8888

- If you want to make sure that the Minecraft server is accessible on the correct port, you can also use a tool like telnet or nc:
    ```bash
    nc IP_Address_VM 8888
    ```

- If you have a Minecraft account: You can connect to the server on your cloud VM from your <a href="https://www.minecraft.net/de-de/download">Java Minecraft client</a> on your computer and play Minecraft.

- Use a <a href="https://mcstatus.io/" >website</a> that offers status checks for Minecraft servers or try to establish a connection to the Minecraft Server using the <a href="https://github.com/py-mine/mcstatus">python `mcstatus` module</a>.

## Usage
### Installation and Preparation
1) <a href="https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository">Clone</a> the project to your platform if you just want to use it.
    - <ins>Example</ins>: Clone the repo e.g. using an SSH-Key:  
    ```bash
    git clone git@github.com:SarahZimmermann-Schmutzler/minecraft_server.git
    ```

2) Download the Java Server file from the Minecraft webpage. For copyright reasons, the server file will not be uploaded to github.:
    ```bash
    https://www.minecraft.net/de-de/download/server
    ```
    - Don't forget to move the server file to the project folder, e.g. from Windows PC to a VM via SSH:
        - scp /path/to/minecraft_server/server.jar username@vm-ip:/path/to/minecraft_server

3) It may be that the server file needs to be made executable:
    - View rights of the files in the directory:
    ```bash
    ls -l
    ```
    
    - For the server.jar file it should look like that:
        - -rwxr-xr-x
    
    - Set execute permissions if they don't exist:
    ```bash
    chmod +x server.jar
    ```


### Containerization with Docker Compose
1) The `Dockerfile` describes how a single Docker image should be created. It serves as the basis for a service in the Docker Compose file:
    ```bash
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
    ```

2) The `compose.yaml` is responsible for managing and orchestrating the Minecraft Server container. It defines what configurations it should have:
    ```bash
    # version of the Compose format used by Docker Compose
    version: '3.9'

    # container configuration
    services:
    # name of the service
    mc-server:
        # creates an image from the Dockerfile in the current directory
        build: .
    
        # defines port forwarding between host and container
        ports:
        # hostPort:containerPort
        # forwards port 25565 on the container to port 8888 on the host
        # Clients that connect to port 8888 on the host communicate with port 25565 in the container
        - 8888:25565
    
        # mounts volumes (mechanism to persistently store data) between the host and the container 
        volumes:
        # volume_name:containerPath
        - minecraft-server-volume:/app
    
        # The container will automatically restart if an error occurs that causes the container to terminate.
        # If the container is stopped manually, it will not restart.
        restart: on-failure

    volumes:
    minecraft-server-volume:
    ```

3) The `server.properties` file plays a central role in setting up a Minecraft Java server. It contains the configuration options that allow you to customize the behavior of the server, the game rules and the technical characteristics:
    ```bash
    ## Server Security

    # With a whitelist enabled, users not on the whitelist cannot connect. Ops are automatically whitelisted.
    white-list=true


    ## World and biome settings

    # Sets the starting value for the world.
    # The coordinates X: -1883 / Z: 263 brings you to a Biome with Forest, Beach and River.
    level-seed=7777777777777777777

    # This determines the server-side viewing distance.
    # 10 is the default/recommended value - a lower value saves resources.
    view-distance=6


    ## Game mechanics

    # The maximum number of players that can play on the server at the same time.
    # 20 is the default value. The fewer players play, the better the performance at low resources.
    max-players=5
    ```
    - You can read about which properties can be changed <a href="https://minecraft.wiki/w/Server.properties">here</a>.

4) Build and start the container that runs in the background (detached mode):
    ```bash
    docker compose up --build -d
    ```
    - To view the log files:
        ```bash
        docker compose logs -f
        ```
    - To stop the container:
        ```bash
        docker compose stop <container-name>
        ```
    - To delete the container:
        ```bash
        docker compose down <container-name>
        ```
    - To list all containers that are operatet by Docker Compose:
        ```bash
        docker compose ps
        ```

5) Check whether the server is running correctly:
- The Minecraft server can be reached under the IP address of your cloud VM on port 8888:
    - http://IP_Address_VM:8888
    - Result: The ERR_EMPTY_RESPONSE error message means that the browser tried to communicate with the server but did not receive any data. This is to be expected since a Minecraft Server doesn't send HTTP data that a browser can interpret. The Minecraft server uses Minecraft's own protocol, which is not compatible with a web browser.The Minecraft Server is running correctly and listening on the specified port (e.g. 8888), but it only responds to requests from Minecraft clients, not HTTP requests.  
    <img alt="ip_adress:8888" src="https://github.com/SarahZimmermann-Schmutzler/minecraft_server/blob/main/ipaddress.png"></img>  

- If you want to make sure that the Minecraft server is accessible on the correct port, you can also use a tool like telnet or nc:
    ```bash
    nc IP_Address_VM 8888
    ```

- If you have a Minecraft account: You can connect to the server on your cloud VM from your <a href="https://www.minecraft.net/de-de/download">Java Minecraft client</a> on your computer and play Minecraft.



- Use a <a href="https://mcstatus.io/" >website</a> that offers status checks for Minecraft servers or try to establish a connection to the Minecraft Server using the <a href="https://github.com/py-mine/mcstatus">python `mcstatus` module</a>.
    - mcstatus.io:
    <img alt="mcsrv" src="https://github.com/SarahZimmermann-Schmutzler/minecraft_server/blob/main/mcsrv.png"></img>

    - python script `mcstatus`:
    
## Additional Notes
<ins>Alternative</ins>: 
You can work with the <a href="https://github.com/itzg/docker-minecraft-server">Docker Minecraft Server</a> that uses the base image `itzg/minecraft-server`. This image already containes the server file and the java environment.  
  
The <a href="https://minecraft.wiki/w/Tutorial:Setting_up_a_server#Docker">Minecraft Wiki</a> offers a setup for this but points out that the contents of this setup are not supported by Mojang Studios or the Minecraft Wiki.