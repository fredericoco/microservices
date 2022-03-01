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

The diagram above shows the basics of how docker works. A client will pull an image from a registry, if it isn't already on the system. If it's already on the system it will create a new container of it.

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
Now you can `docker build -t fredericoco121/eng103a`
Now we run it`docker run -d -p 40:80 fredericoco121/eng103a`
This should now work and a website should be up
Now push it to docker hub `docker push fredericoco121/eng103a`