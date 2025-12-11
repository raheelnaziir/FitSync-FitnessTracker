const express = require('express');
const router = express.Router();
const Workout = require('../models/Workout');
const jwt = require('jsonwebtoken');

// Middleware for authentication
const auth = (req, res, next) => {
    try {
        const token = req.headers.authorization?.split(' ')[1];
        
        if (!token) {
            return res.status(401).json({ message: 'No token provided' });
        }
        
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        req.user = decoded.id;
        next();
    } catch(err) {
        console.error('Auth error:', err.message);
        return res.status(401).json({ message: 'Invalid or expired token' });
    }
};

// Create workout
router.post('/', auth, async (req, res) => {
    try {
        const { title, exercises, date } = req.body;
        
        if (!title) {
            return res.status(400).json({ message: 'Title is required' });
        }
        
        const workout = await Workout.create({
            user: req.user,
            title,
            exercises: exercises || [],
            date: date ? new Date(date) : new Date()
        });
        
        res.status(201).json(workout);
    } catch(err) {
        console.error('Create workout error:', err.message);
        res.status(500).json({ message: 'Failed to create workout: ' + err.message });
    }
});

// Get all workouts for user
router.get('/', auth, async (req, res) => {
    try {
        const workouts = await Workout.find({ user: req.user }).sort({ date: -1 });
        res.json(workouts);
    } catch(err) {
        console.error('Get workouts error:', err.message);
        res.status(500).json({ message: 'Failed to fetch workouts: ' + err.message });
    }
});

// Get single workout
router.get('/:id', auth, async (req, res) => {
    try {
        const workout = await Workout.findOne({ _id: req.params.id, user: req.user });
        if (!workout) {
            return res.status(404).json({ message: 'Workout not found' });
        }
        res.json(workout);
    } catch(err) {
        console.error('Get workout error:', err.message);
        res.status(500).json({ message: 'Failed to fetch workout: ' + err.message });
    }
});

// Update workout
router.put('/:id', auth, async (req, res) => {
    try {
        const workout = await Workout.findOneAndUpdate(
            { _id: req.params.id, user: req.user },
            req.body,
            { new: true }
        );
        if (!workout) {
            return res.status(404).json({ message: 'Workout not found' });
        }
        res.json(workout);
    } catch(err) {
        console.error('Update workout error:', err.message);
        res.status(500).json({ message: 'Failed to update workout: ' + err.message });
    }
});

// Delete workout
router.delete('/:id', auth, async (req, res) => {
    try {
        const workout = await Workout.findOneAndDelete({ _id: req.params.id, user: req.user });
        if (!workout) {
            return res.status(404).json({ message: 'Workout not found' });
        }
        res.json({ message: 'Workout deleted' });
    } catch(err) {
        console.error('Delete workout error:', err.message);
        res.status(500).json({ message: 'Failed to delete workout: ' + err.message });
    }
});

module.exports = router;
