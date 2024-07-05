CounterModel? counterModel;

class CounterModel {
  CounterModel({
    required this.activity,
    this.booking,
    this.employee,
    this.boat,
    this.freelance,
    this.files,
  });

  final int activity;
  final int? booking;
  int? employee;
  final int? boat;
  final int? freelance;
  final int? files;

  factory CounterModel.fromMap(Map<String, dynamic> json) => CounterModel(
        activity: json['activity'],
        booking: json['booking'],
        employee: json['employee'],
        boat: json['boat'],
        freelance: json['freelance'],
        files: json['files'],
      );

  Map<String, dynamic> toMap() => {
        'activity': activity,
        'booking': booking,
        'employee': employee,
        'boat': boat,
        'freelance': freelance,
        'files': files,
      };

  CounterModel copyWith({
    int? activity,
    int? booking,
    int? employee,
    int? boat,
    int? freelance,
    int? files,
  }) {
    return CounterModel(
      activity: activity ?? this.activity,
      files: files ?? this.files,
      booking: booking ?? this.booking,
      employee: employee ?? this.employee,
      boat: boat ?? this.boat,
      freelance: freelance ?? this.freelance,
    );
  }
}
