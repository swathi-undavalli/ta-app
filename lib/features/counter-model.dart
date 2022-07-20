
CounterModel counterModel;

class CounterModel {
  CounterModel({
    this.activity,
    this.booking,
    this.employee,
    this.boat,
    this.freelance,
    this.files,
  });

  int activity;
  int booking;
  int employee;
  int boat;
  int freelance;
  int files;

  factory CounterModel.fromMap(Map<String, dynamic> json) => CounterModel(
    activity: json["activity"],
    booking: json["booking"],
    employee: json["employee"],
    boat: json["boat"],
    freelance: json["freelance"],
    files: json["files"],
  );

  Map<String, dynamic> toMap() => {
    "activity": activity,
    "booking": booking,
    "employee": employee,
    "boat": boat,
    "freelance": freelance,
    "files": files,
  };
}
