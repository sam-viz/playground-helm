This repository is a playground to play with Helm capabilities.
The goal would be the following:
## Node.js Task Manager CRUD API

A simple Express.js application for managing tasks (Create, Read, Update, Delete).

## Endpoints

- `POST /tasks` — Create a new task
- `GET /tasks` — List all tasks
- `GET /tasks/:id` — Get a single task
- `PUT /tasks/:id` — Update a task
- `DELETE /tasks/:id` — Delete a task

## Getting Started

1. Install dependencies:
	```sh
	npm install
	```
2. Start the server:
	```sh
	npm start
	```
3. The API will run on `http://localhost:3000` by default.

## Next Steps
- You can package this app with Docker and Helm as needed.