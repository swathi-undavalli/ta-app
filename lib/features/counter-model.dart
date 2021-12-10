
CounterModel counterModel;

class CounterModel {
  CounterModel({
    this.activity,
    this.booking,
    this.employee,
  });

  int activity;
  int booking;
  int employee;

  factory CounterModel.fromMap(Map<String, dynamic> json) => CounterModel(
    activity: json["activity"],
    booking: json["booking"],
    employee: json["employee"],
  );

  Map<String, dynamic> toMap() => {
    "activity": activity,
    "booking": booking,
    "employee": employee,
  };
}
