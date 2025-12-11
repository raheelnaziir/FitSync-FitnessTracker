import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../services/api_service.dart';

class WorkoutScreen extends StatefulWidget {
  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List<Workout> workouts = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    setState(() { loading = true; });
    try {
      final res = await WorkoutService.getWorkouts();
      if (!mounted) return;
      setState(() {
        workouts = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching workouts: ${e.toString()}'),
            backgroundColor: Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          )
      );
    }
  }

  void addWorkout() async {
    TextEditingController titleController = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add New Workout', style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Workout Title',
            prefixIcon: Icon(Icons.fitness_center, color: Color(0xFF6C5CE7)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, null), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C5CE7)),
            onPressed: () => Navigator.pop(context, titleController.text.trim()),
            child: Text('Add'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      if (!mounted) return;
      setState(() { loading = true; });
      try {
        Workout w = await WorkoutService.createWorkout(Workout(id: '', title: result, exercises: [], date: DateTime.now()));
        if (!mounted) return;
        setState(() {
          workouts.add(w);
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workout added successfully!'),
            backgroundColor: Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        setState(() { loading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add workout: ${e.toString()}'),
            backgroundColor: Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void editWorkout(int index) async {
    TextEditingController titleController = TextEditingController(text: workouts[index].title);
    final result = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit Workout', style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold)),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Workout Title',
            prefixIcon: Icon(Icons.fitness_center, color: Color(0xFF6C5CE7)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFF6C5CE7), width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, null), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C5CE7)),
            onPressed: () => Navigator.pop(context, titleController.text.trim()),
            child: Text('Update'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      if (!mounted) return;
      setState(() { loading = true; });
      try {
        Workout updatedWorkout = Workout(
          id: workouts[index].id,
          title: result,
          exercises: workouts[index].exercises,
          date: workouts[index].date,
        );
        await WorkoutService.updateWorkout(workouts[index].id, updatedWorkout);
        if (!mounted) return;
        setState(() {
          workouts[index] = updatedWorkout;
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workout updated successfully!'),
            backgroundColor: Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        setState(() { loading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update workout: ${e.toString()}'),
            backgroundColor: Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void deleteWorkout(int index) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete Workout?', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${workouts[index].title}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFE53935)),
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!mounted) return;
      setState(() { loading = true; });
      try {
        await WorkoutService.deleteWorkout(workouts[index].id);
        if (!mounted) return;
        setState(() {
          workouts.removeAt(index);
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workout deleted successfully!'),
            backgroundColor: Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        if (!mounted) return;
        setState(() { loading = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete workout: ${e.toString()}'),
            backgroundColor: Color(0xFFE53935),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Plans', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Color(0xFF6C5CE7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7))))
          : workouts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fitness_center, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text('No workouts yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      SizedBox(height: 8),
                      Text('Create your first workout to get started!', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchWorkouts,
                  color: Color(0xFF6C5CE7),
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: workouts.length,
                    itemBuilder: (_, i) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Dismissible(
                        key: Key(workouts[i].id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          deleteWorkout(i);
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Color(0xFFE53935),
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          child: Icon(Icons.delete, color: Colors.white, size: 28),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              leading: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.fitness_center, color: Colors.white, size: 28),
                              ),
                              title: Text(
                                workouts[i].title,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                              ),
                              subtitle: Text(
                                '${workouts[i].exercises.length} exercises',
                                style: TextStyle(color: Colors.white70),
                              ),
                              trailing: PopupMenuButton(
                                color: Colors.white,
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    editWorkout(i);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, color: Color(0xFF6C5CE7), size: 20),
                                        SizedBox(width: 10),
                                        Text('Edit', style: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ],
                                child: Icon(Icons.more_vert, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: addWorkout,
        backgroundColor: Color(0xFF6C5CE7),
        elevation: 4,
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}
