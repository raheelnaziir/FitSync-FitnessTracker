import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';

class TimerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Timer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        elevation: 0,
        backgroundColor: Color(0xFF6C5CE7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      ),
      body: Consumer<TimerProvider>(
        builder: (context, timerProvider, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFF5F5F5)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFF00B4D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [BoxShadow(color: Color(0xFF6C5CE7).withOpacity(0.4), blurRadius: 20, spreadRadius: 5)],
                    ),
                    child: Center(
                      child: Text(
                        timerProvider.formatTime(),
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: timerProvider.isRunning ? Colors.grey[300] : Color(0xFF00B4D8),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: timerProvider.isRunning ? null : timerProvider.startTimer,
                            customBorder: CircleBorder(),
                            child: Icon(Icons.play_arrow, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: timerProvider.isRunning ? Color(0xFFE53935) : Colors.grey[300],
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: timerProvider.isRunning ? timerProvider.stopTimer : null,
                            customBorder: CircleBorder(),
                            child: Icon(Icons.pause, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Color(0xFF6C5CE7),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: timerProvider.resetTimer,
                            customBorder: CircleBorder(),
                            child: Icon(Icons.refresh, size: 50, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFF6C5CE7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      timerProvider.isRunning ? '⏱️ Timer is running' : '⏸️ Timer is paused',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
