class Workout {
  final String id;
  final String title;
  final List<dynamic> exercises;
  final DateTime date;

  Workout({required this.id, required this.title, required this.exercises, required this.date});

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['_id'],
      title: json['title'],
      exercises: json['exercises'],
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'exercises': exercises,
    'date': date.toIso8601String(),
  };
}
