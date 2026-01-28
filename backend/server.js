const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const jwt = require('jsonwebtoken');

const app = express();
const PORT = 3000;
const SECRET_KEY = 'super_secret_key';

app.use(cors());
app.use(bodyParser.json());

// Mock Data
let users = [
    { id: 1, username: 'admin', password: 'password' }
];

let tasks = [
    { id: 1, title: "Doctor Appointment", description: "Visit Dr. Smith at 5 PM", isCompleted: false, remarks: "", updatedAt: new Date().toISOString() },
    { id: 2, title: "Buy Groceries", description: "Milk, Bread, Eggs", isCompleted: true, remarks: "Done", updatedAt: new Date().toISOString() },
    { id: 3, title: "Team Meeting", description: "Project update via Zoom", isCompleted: false, remarks: "", updatedAt: new Date().toISOString() }
];

// Helper to verify token
const verifyToken = (req, res, next) => {
    const bearerHeader = req.headers['authorization'];
    if (typeof bearerHeader !== 'undefined') {
        const bearer = bearerHeader.split(' ');
        const bearerToken = bearer[1];
        jwt.verify(bearerToken, SECRET_KEY, (err, authData) => {
            if (err) {
                res.sendStatus(403);
            } else {
                req.user = authData;
                next();
            }
        });
    } else {
        res.sendStatus(403);
    }
};

// Login Route
app.post('/login', (req, res) => {
    const { username, password } = req.body;
    const user = users.find(u => u.username === username && u.password === password);

    if (user) {
        jwt.sign({ user }, SECRET_KEY, { expiresIn: '1h' }, (err, token) => {
            if (err) {
                res.status(500).json({ error: "Error generating token" });
            } else {
                res.json({
                    token,
                    user: { id: user.id, username: user.username }
                });
            }
        });
    } else {
        res.status(401).json({ error: "Invalid credentials" });
    }
});

// Get Tasks
app.get('/tasks', verifyToken, (req, res) => {
    res.json({ data: tasks });
});

// Create Task
app.post('/tasks', verifyToken, (req, res) => {
    const newTask = {
        id: tasks.length + 1,
        title: req.body.title,
        description: req.body.description,
        isCompleted: false,
        remarks: "",
        updatedAt: new Date().toISOString()
    };
    tasks.push(newTask);
    res.json({ data: newTask });
});

// Update Task
app.put('/tasks/:id', verifyToken, (req, res) => {
    const id = parseInt(req.params.id);
    const taskIndex = tasks.findIndex(t => t.id === id);

    if (taskIndex > -1) {
        tasks[taskIndex] = { ...tasks[taskIndex], ...req.body, updatedAt: new Date().toISOString() };
        res.json({ data: tasks[taskIndex] });
    } else {
        res.status(404).json({ error: "Task not found" });
    }
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
