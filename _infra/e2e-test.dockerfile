# Use an official Node.js runtime as a parent image
FROM node:22.21-alpine

# Set the working directory in the container
WORKDIR /app
# Copy package.json and package-lock.json (if available)
COPY package*.json ./
RUN npm config set strict-ssl false
# Install dependencies
RUN npm install
# Copy the rest of the application code
COPY src ./src
COPY task-manager ./task-manager

# Define the command to run the app
CMD ["npm", "run", "e2e:test"]