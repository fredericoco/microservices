# Microservices
## Docker
Docker is a key part of the tech world
### Docker Setup
In order to set up docker on your computer, you need to follow these steps:
- Install Docker Desktop for windows. You will need to restart your computer.
- Go to apps and features on windows search bar, click on programs and features, turn windows features on and off, and finally click of Hyper -v. You will need to restart your computer
- Install WSL2
- Go to the desktop Docker app,hover over the whale logo in the bottom left, if it says `engine running` then everything is set up correctly. 
- Type `docker --version` in the gitbash terminal in order to check if docker is installed. If there is an error then it is not installed.
### Docker container lifecycle
In order to get a container, which is something we need to use in order to host websites or run applications we need to run an application to get a container from an image first. In order to do this we run `docker run Name_of_container`, if it isn't on the system then it will retrieve it from docker hub. We did this with `hello-world`.

If the application requires a port, the command needed is `docker run -d -p Port_1:Port_2 Name_of_container`.The `-d` means that it is in detached mode, meaning that you can continue to use the terminal when you are finished. The first port is the one you are mapping your localhost to, the second port is the port that the docker image is listening on. We did this example with ghost and nginx, so the commands would be
![why docker](https://user-images.githubusercontent.com/39882040/156179107-7690cbc4-480d-48a6-94e7-386dededd412.PNG)

The diagram above shows the basics of how docker works.Using `docker run` a client will pull an image from a registry, if it isn't already on the system and create an image of it. If it's already on the system it will create a new container of it. `docker pull` will just pull an image. `docker push` will push an image or container to docker hub.

Common docker commands:
- `docker push` - Used to push an image or a repository to a registry
- `docker pull` - Used to pull images from the docker repository
- `docker run` - Used to create a container from an image
- `docker images` - shows the images being run and provides information about them
- `docker rmi hello-world -f`- will delete an image. The -f forces it
- `alias docker="winpty docker"` - because we are using windows, we need to make sure it executes the commands properly.
- `docker login` -verifies your docker credentials
- `docker run -p 2368:2368 ghost`- the -p is for ports, the two ports are for port mapping.
- `docker ps` -shows which images are running `docker ps -a` shows all the images that have been run
- `docker run -d -p 2368:2368 ghost`- will run it but with the screen mode, will launch ghost
- `docker stop ID` - will stop an image if you provide an ID
- `docker rm ID` - will delete an image if provided with an ID, note multiple IDs can be put here
- `docker run -d -p 80:80 nginx` - will run nginx on port 80
- `docker run -d -p 99:80 nginx` -
- `docker run -d -p 80:2368 ghost`
- `docker run -d -p 4000:4000 docs/docker.github.io`
- `docker logs ID` will give you the log on the container. This can be used for debugging.

# Docker part 2
- `alias docker="winpty docker"` - sets an alias
- `docker exec -it ID sh` - will ssh into the container
- `cd /usr/share/nginx/html` - In nginx container, to go to html setting this is the path
- `update and upgrade`
- `apt-get install nano`
You can now edit the html script for the page

#### Hosting static website with Nginx using Docker
-  copy the index.html from localhost to default location of nginx
-  `cd /usr/share/nginx/html/`
-  `docker cp file.html container_ID:/usr/share/nginx/html/file.html` - THis command will copy a file from local host to the container 

In order to push a container to docker hub we need to:
- create an image from a container `docker run -d -p 80:80 nginx` and `docker cp file.html container_ID:/usr/share/nginx/html/file.html`
- The image ID can be seen using `docker images`
-  `docker tag container_ID fredericoco121/docker_eng103a` to tag it, this defaults to latest version 
-  `docker push fredericoco121/docker_eng103a` to push it
-  Now anyone could run `docker run -d -p 80:80 fredericoco121/docker_eng103a:latest` to run the image we've created.

## Automating the process
We've created a Dockerfile which automates what we've just done. In the docker file we need the commands below:

```
# from which image - image we used as our base image Nginx
FROM nginx 

# label to communicate with team members
LABEL MAINTAINER=FJOHNSON@SPARTAGLOBAL.COM

# copy data from localhost to container
COPY index.html /usr/share/nginx/html

# expose port 80
EXPOSE 80

# launch/create a container
CMD ["nginx", "-g","daemon off;"]
```
Now you can `docker build -t fredericoco121/eng103a .`
Now we run it`docker run -d -p 40:80 fredericoco121/eng103a`
This should now work and a website should be up
Now push it to docker hub `docker push fredericoco121/eng103a`
`docker exec -it ID bash` to open the terminal

## Creating the app image
The steps to create the app image using Dockerfile:
- step 1: get a fresh version of the app from the zip file
- step 2: move the app file to the microservices directory
- step 3: Create a dockerfile outside of the app file, this is where we're going to work from. The code we need for this is:
```
FROM node:latest

WORKDIR /usr/src/app

COPY /app /usr/src/app

RUN npm install

EXPOSE 3000

CMD ["node", "app.js"]
``` 
- The `FROM node:latest` will import the latest version of node (6 I believe)
- `WORKDIR /usr/src/app` Sets the work directory
- `COPY /app /usr/src/app` This copies the app file from this directory to the /usr/src/app
- `RUN npm install` This runs npm install
- `EXPOSE 3000` This exposes port 3000
- `CMD ["node", "app.js"]` This runs the two commands `node` and `app.js`

## Docker part 3
- build production ready - Multi-stage build
- current image is in working state
- listening on required port (EXPOSE 3000)
- copy app folder
- npm install
- npm install express
- CMD [node,app.js]
- `localhost:3000` displays node app home page
- add production ready layer
- find the slimmer/smaller size of image to use `docker hub`
- create alias for our base image to use with next stage
- --from=app path of WRKDIR PATH:new image WORKDIR
- size `105gb` to `250mb` approx

```
FROM node:latest as APP

WORKDIR /usr/src/app/

COPY app /usr/src/app/

RUN npm install

FROM node:alpine

COPY --from=APP /usr/src/app/ /usr/src/app

WORKDIR /usr/src/app/

EXPOSE 3000

CMD ["node", "app.js"]
```

### Downloading from a container to localhost
If you are running a command which launchs a foreign container, and you want to get this data onto your localhost the command you need is:
- `docker cp container_ID:/path_to_WORKDIR path_to_where_you_want_to_place_content`
- In our case the command was `docker cp 683a15351e70:/usr/src/app .`, where the workdir is the same as in the Dockerfile and the fullstop just puts in in the area it was executed. If you build and run with the new content there should be a different localhost page.

### Docker compose and DB
In order to access another container so that we can access posts, we need to create a docker compose file. This docker compose file is a .yml file.

The steps we did to get the posts directory to work were:
- `docker pull mongo` to pull the image from docker hub
- `docker image` to see if the docker image
- Now you have to make a docker compose file. This file is going to be a yml file. See the code for how it is going to be documented.
- `docker compose up -d` to execute the docker compose file. This does it in detached mode. remove the d for troubleshooting. The docker compose file is below.
```
version: "3"

services: 

  mongo:

    image: mongo

    container_name: mongo

 #   restart: always

    volumes:

      - ./mongod.conf:/etc/mongod.conf

     # - ./logs:/var/log/mongod/

     # - ./db:/var/lib/mongodb

      #- ./mongod.service:/lib/systemd/system/mongod.service

    ports:

      - "27017:27017"



  app:

    container_name: small_app_update

    restart: always

    build: ./app

    ports:

      - "3000:3000"

    links:

      - mongo

    environment: 

      - DB_HOST=mongodb://mongo:27017/posts

    #command: node app/seeds/seed.js
```
ssh into the app and `node seeds/seed.js` if this doesn't work. Updated code below for the dockerfile and compose file
`FROM node:latest as APP

WORKDIR /usr/src/app/

COPY app /usr/src/app/

RUN npm install -g npm@latest
RUN npm install express
#RUN seeds/seed.js
FROM node:alpine

COPY --from=APP /usr/src/app/ /usr/src/app

WORKDIR /usr/src/app/

EXPOSE 3000

CMD node seeds/seed.js && npm start``

```
yml file
```
version: "3"

services: 

  mongo:

    image: mongo

    container_name: mongo

 #   restart: always

    volumes:

      - ./mongod.conf:/etc/mongod.conf

     # - ./logs:/var/log/mongod/

     # - ./db:/var/lib/mongodb

      #- ./mongod.service:/lib/systemd/system/mongod.service

    ports:

      - "27017:27017"

    healthcheck:
      test: echo 'db.runCommand("ping").ok' | mongo mongo:27017/posts --quiet
      interval: 5s
      timeout: 5s
      retries: 8

  app:
    depends_on:
      mongo:
        condition: service_healthy

    container_name: small_app_update

    restart: always

    image: fredericoco121/app_posts

    ports:

      - "80:3000"

    links:

      - mongo

    environment: 

      - DB_HOST=mongodb://mongo:27017/posts
```