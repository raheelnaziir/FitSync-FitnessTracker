import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/api_service.dart';
import '../models/workout.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
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
        ),
      );
    }
  }

  int getTotalExercises() {
    return workouts.fold(0, (sum, w) => sum + w.exercises.length);
  }

  int getAverageExercisesPerWorkout() {
    if (workouts.isEmpty) return 0;
    return (getTotalExercises() / workouts.length).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
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
                      Icon(Icons.show_chart, size: 80, color: Colors.grey[300]),
                      SizedBox(height: 16),
                      Text('No progress data yet', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                      SizedBox(height: 8),
                      Text('Complete workouts to track your progress!', style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchWorkouts,
                  color: Color(0xFF6C5CE7),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Card
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Fitness Journey',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildStatItem('Workouts', workouts.length.toString(), Icons.fitness_center),
                                  _buildStatItem('Exercises', getTotalExercises().toString(), Icons.sports_gymnastics),
                                  _buildStatItem('Average', getAverageExercisesPerWorkout().toString(), Icons.trending_up),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 28),

                        // Chart Title
                        Text(
                          'Workout Progression',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Chart
                        Container(
                          height: 280,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: workouts.length < 2
                              ? Center(
                                  child: Text(
                                    'Add more workouts to see your progress chart',
                                    style: TextStyle(color: Colors.grey[500], fontSize: 14),
                                  ),
                                )
                              : LineChart(
                                  LineChartData(
                                    gridData: FlGridData(
                                      show: true,
                                      drawVerticalLine: false,
                                      horizontalInterval: 1,
                                      getDrawingHorizontalLine: (value) {
                                        return FlLine(
                                          color: Colors.grey[200],
                                          strokeWidth: 1,
                                        );
                                      },
                                    ),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 30,
                                          getTitlesWidget: (value, meta) {
                                            return Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text(
                                                '${value.toInt() + 1}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 40,
                                          getTitlesWidget: (value, meta) {
                                            return Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    ),
                                    borderData: FlBorderData(show: false),
                                    lineBarsData: [
                                      LineChartBarData(
                                        spots: workouts
                                            .asMap()
                                            .entries
                                            .map((e) => FlSpot(e.key.toDouble(), e.value.exercises.length.toDouble()))
                                            .toList(),
                                        isCurved: true,
                                        gradient: LinearGradient(
                                          colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                                        ),
                                        barWidth: 3,
                                        isStrokeCapRound: true,
                                        dotData: FlDotData(
                                          show: true,
                                          getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                            radius: 5,
                                            color: Color(0xFF6C5CE7),
                                            strokeWidth: 2,
                                            strokeColor: Colors.white,
                                          ),
                                        ),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF6C5CE7).withOpacity(0.4),
                                              Color(0xFF00B4D8).withOpacity(0.1),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                    ],
                                    minX: 0,
                                    maxX: (workouts.length - 1).toDouble(),
                                    minY: 0,
                                  ),
                                ),
                        ),
                        SizedBox(height: 28),

                        // Recent Workouts
                        Text(
                          'Recent Workouts',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                        SizedBox(height: 12),
                        ...workouts.reversed.take(5).map((workout) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!, width: 1),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        workout.title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF6C5CE7),
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        '${workout.date.day}/${workout.date.month}/${workout.date.year}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${workout.exercises.length} exercises',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
