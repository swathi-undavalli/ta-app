
CounterModel counterModel;

class CounterModel {
  CounterModel({
    this.activity,
    this.booking,
    this.employee,
    this.boat
  });

  int activity;
  int booking;
  int employee;
  int boat;

  factory CounterModel.fromMap(Map<String, dynamic> json) => CounterModel(
    activity: json["activity"],
    booking: json["booking"],
    employee: json["employee"],
    boat: json["boat"],
  );

  Map<String, dynamic> toMap() => {
    "activity": activity,
    "booking": booking,
    "employee": employee,
    "boat": boat,
  };
}
