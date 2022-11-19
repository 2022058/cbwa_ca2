# Include a line containing the base image in the Dockerfile.
# syntax=docker/dockerfile:1
FROM node as build

# The RUN, CMD, ENTRYPOINT, COPY, and ADD instructions that come after the WORKDIR directive in the Dockerfile establish the working directory.
# Creating a working directory.
WORKDIR /app

# Copying app from GitHub
RUN wget https://github.com/2022058/mobdev_ca3/archive/main.tar.gz \
&& tar xf main.tar.gz \
&& rm main.tar.gz

# Change workdir
WORKDIR /app/mobdev_ca3-main/

# Ionic installation with npm
RUN npm install -g ionic

# Installtion dependencies and devDependencies, do
RUN npm install

# Build App
RUN npm run build --prod

# Nginx is a free and open source web server
#Open server nginx and alpine to service.
FROM nginx:alpine

# This instructs Docker that because TCP is the default protocol, your web server will accept connections on port 80.
EXPOSE 80

#path to html
RUN rm -rf /usr/share/nginx/html/*

# To protect running commands in the image build and container runtime processes, create a user called static.
#USER static

# The COPY command adds new files or directories to the container's filesystem at the path specified by <dest> by copying them from <src>.
# Add app files into /usr/share/nginx/html
COPY --from=build /app/mobdev_ca3-main/www/ /usr/share/nginx/html/
