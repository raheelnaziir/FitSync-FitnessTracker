import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/api_service.dart';
import '../models/workout.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Workout> workouts = [];
  bool loading = true;
  Map<DateTime, List<String>> workoutEvents = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      workouts = await WorkoutService.getWorkouts();
      if (!mounted) return;
      workoutEvents = {};
      for (var w in workouts) {
        final day = DateTime(w.date.year, w.date.month, w.date.day);
        workoutEvents[day] = workoutEvents[day] ?? [];
        workoutEvents[day]!.add(w.title);
      }
      setState(() { loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { loading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching workouts'),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    return workoutEvents[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Calendar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Color(0xFF6C5CE7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C5CE7))))
          : RefreshIndicator(
              onRefresh: fetchWorkouts,
              color: Color(0xFF6C5CE7),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                      },
                      eventLoader: _getEventsForDay,
                      calendarStyle: CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: Color(0xFF6C5CE7),
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Color(0xFF00B4D8),
                          shape: BoxShape.circle,
                        ),
                        markersMaxCount: 3,
                        markerDecoration: BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        weekendTextStyle: TextStyle(color: Color(0xFFE53935)),
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonDecoration: BoxDecoration(
                          color: Color(0xFF6C5CE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.white),
                        titleCentered: true,
                        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Workouts for ${_selectedDay != null ? _selectedDay.toString().split(' ')[0] : _focusedDay.toString().split(' ')[0]}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                    ),
                  ),
                  Expanded(
                    child: _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_today, size: 64, color: Colors.grey[300]),
                                SizedBox(height: 12),
                                Text('No workouts scheduled', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                              ],
                            ),
                          )
                        : ListView(
                            padding: EdgeInsets.all(16),
                            children: _getEventsForDay(_selectedDay ?? _focusedDay)
                                .map((e) => Padding(
                                      padding: EdgeInsets.only(bottom: 12),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.3),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(Icons.fitness_center, color: Colors.white, size: 22),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                e,
                                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                              ),
                                            ),
                                            Icon(Icons.check_circle, color: Colors.white, size: 24),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}
