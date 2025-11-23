# Use an official Node.js runtime as a parent image
FROM node:22.21-alpine

RUN npm install -g @usebruno/cli@2.14.2

RUN apk add --no-cache ca-certificates
# Set the working directory in the container
WORKDIR /app

COPY task-manager ./task-manager
WORKDIR /app/task-manager

# Set default environment variable (can be overridden at runtime)
ENV BRUNO_ENV=default
ENV BASE_URL=http://host.docker.internal:3000
ENV PORT=3000

# Inject env variable into Bruno run
CMD ["sh", "-c", "bru run --env $BRUNO_ENV --env-var base_url=$BASE_URL"]