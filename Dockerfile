# Use the official Node.js image as the base image
FROM node:14

# Set the working directory in the container
WORKDIR /app # Depeebds on where the file is locally on your machine

RUN npm install -g truffle
RUN npm install

COPY . .
EXPOSE [Fill in Exposed Port]

CMD ["RUN","truffle", "develop"]

