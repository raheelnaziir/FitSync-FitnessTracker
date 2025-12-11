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
          content: Text('Error fetching workouts'),
          backgroundColor: Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
                        Text(
                          'Your Workout Progress',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 300,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                          ),
                          child: LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: true,
                                horizontalInterval: 1,
                                verticalInterval: 1,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(color: Colors.grey[300], strokeWidth: 0.5);
                                },
                                getDrawingVerticalLine: (value) {
                                  return FlLine(color: Colors.grey[300], strokeWidth: 0.5);
                                },
                              ),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text('W${value.toInt()}', style: TextStyle(color: Colors.grey[600], fontSize: 12));
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(value.toInt().toString(), style: TextStyle(color: Colors.grey[600], fontSize: 12));
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: workouts.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.exercises.length.toDouble())).toList(),
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
                                      colors: [Color(0xFF6C5CE7).withOpacity(0.3), Color(0xFF00B4D8).withOpacity(0.1)],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Statistics',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7)),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${workouts.length}',
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Workouts', style: TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF00B4D8), Color(0xFF00D4FF)]),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      '${workouts.fold(0, (sum, w) => sum + w.exercises.length)}',
                                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(height: 8),
                                    Text('Exercises', style: TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
