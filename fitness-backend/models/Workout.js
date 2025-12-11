const mongoose = require('mongoose');

const WorkoutSchema = new mongoose.Schema({
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    title: { type: String, required: true },
    exercises: [{ name: String, reps: Number, sets: Number }],
    date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Workout', WorkoutSchema);
