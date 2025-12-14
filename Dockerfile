# Use a Node.js LTS base image
FROM node:20-alpine

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json and package-lock.json are copied
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# The Node.js app is expected to listen on port 3000 (standard for the assignment's simple app)
EXPOSE 3000

# Start the application
CMD [ "node", "index.js" ]