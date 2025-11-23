const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

let tasks = [];
let idCounter = 1;

// Create a task
app.post('/tasks', (req, res) => {
  const { title, description } = req.body;
  console.log('Creating task with title:', title);
  if (!title) return res.status(400).json({ error: 'Title is required' });
  const task = { id: idCounter++, title, description: description || '' };
  tasks.push(task);
  res.status(201).json(task);
});

// Read all tasks
app.get('/tasks', (req, res) => {
  console.log('Fetching all tasks');
  res.json(tasks);
});

// Read a single task
app.get('/tasks/:id', (req, res) => {
  console.log('Fetching task with id:', req.params.id);
  const task = tasks.find(t => t.id === parseInt(req.params.id));
  if (!task) return res.status(404).json({ error: 'Task not found' });
  res.json(task);
});

// Update a task
app.put('/tasks/:id', (req, res) => {
  console.log('Updating task with id:', req.params.id);
  const task = tasks.find(t => t.id === parseInt(req.params.id));
  if (!task) return res.status(404).json({ error: 'Task not found' });
  const { title, description } = req.body;
  if (title) task.title = title;
  if (description) task.description = description;
  res.json(task);
});

// Delete a task
app.delete('/tasks/:id', (req, res) => {
  console.log('Deleting task with id:', req.params.id);
  const index = tasks.findIndex(t => t.id === parseInt(req.params.id));
  if (index === -1) return res.status(404).json({ error: 'Task not found' });
  tasks.splice(index, 1);
  res.status(204).send();
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
