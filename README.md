# Microservices
## Docker
### Docker Setup
In order to set up docker on your computer, you need to follow these steps:
- Install Docker Desktop for windows. You will need to restart your computer.
- Go to apps and features on windows search bar, click on programs and features, turn windows features on and off, and finally click of Hyper -v. You will need to restart your computer
- Install WSL2
- Go to the desktop Docker app,hover over the whale logo in the bottom left, if it says `engine running` then everything is set up correctly. 

Common docker commands:
- `docker push`
- `docker pull`
- `docker run`
- `docker images` shows the images being run and provides information about them
- `docker rmi hello-world -f` will delete an image. The -f forces it
- `alias docker="winpty docker"` - because we are using windows, we need to make sure it executes the commands properly.
- `docker login` verifies your docker credentials
- `docker run -p 2368:2368 ghost`, the -p is for ports, the two ports are for port mapping.
- `docker ps` shows which images are running `docker ps -a` shows all the images that have been run
- `docker run -d -p 2368:2368 ghost` will run it but with the screen mode, will launch ghost
- `docker stop ID` will stop an image if you provide an ID
- `docker rm ID` will delete an image if provided with an ID, note multiple IDs can be put here
- `docker run -d -p 80:80 nginx` will run nginx on port 80
- `docker run -d -p 99:80 nginx`
- `docker run -d -p 80:2368 ghost`
- `docker run -d -p 4000:4000 docs/docker.github.io`
- `docker logs ID` will give you the log on the container. This can be used for debugging.