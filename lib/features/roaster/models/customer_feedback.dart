import 'dart:convert';

class CustomerFeedback {
  final bool? knowsSwimming;
  final bool? interestedOwc;
  final int? instructorFeedback;
  final int? equipmentFeedback;
  final int? experienceFeedback;
  final String? feedback;

  CustomerFeedback({
    required this.knowsSwimming,
    required this.interestedOwc,
    required this.instructorFeedback,
    required this.equipmentFeedback,
    required this.experienceFeedback,
    required this.feedback,
  });

  CustomerFeedback copyWith({
    bool? knowsSwimming,
    bool? interestedOwc,
    int? instructorFeedback,
    int? equipmentFeedback,
    int? experienceFeedback,
    String? feedback,
  }) =>
      CustomerFeedback(
        knowsSwimming: knowsSwimming ?? this.knowsSwimming,
        interestedOwc: interestedOwc ?? this.interestedOwc,
        instructorFeedback: instructorFeedback ?? this.instructorFeedback,
        equipmentFeedback: equipmentFeedback ?? this.equipmentFeedback,
        experienceFeedback: experienceFeedback ?? this.experienceFeedback,
        feedback: feedback ?? this.feedback,
      );

  factory CustomerFeedback.fromRawJson(String str) => CustomerFeedback.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CustomerFeedback.fromJson(Map<String, dynamic> json) => CustomerFeedback(
        knowsSwimming: json['knows_swimming'],
        interestedOwc: json['interested_owc'],
        instructorFeedback: json['instructor_feedback'],
        equipmentFeedback: json['equipment_feedback'],
        experienceFeedback: json['experience_feedback'],
        feedback: json['feedback'],
      );

  Map<String, dynamic> toJson() => {
        'knows_swimming': knowsSwimming,
        'interested_owc': interestedOwc,
        'instructor_feedback': instructorFeedback,
        'equipment_feedback': equipmentFeedback,
        'experience_feedback': experienceFeedback,
        'feedback': feedback,
      };
}
