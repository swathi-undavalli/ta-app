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

  factory CustomerFeedback.fromRawJson(String str) => CustomerFeedback.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory CustomerFeedback.fromMap(Map<String, dynamic> json) => CustomerFeedback(
        knowsSwimming: json['knowsSwimming'],
        interestedOwc: json['interestedOwc'],
        instructorFeedback: json['instructorFeedback'],
        equipmentFeedback: json['equipmentFeedback'],
        experienceFeedback: json['experienceFeedback'],
        feedback: json['feedback'],
      );

  Map<String, dynamic> toMap() => {
        'knowsSwimming': knowsSwimming,
        'interestedOwc': interestedOwc,
        'instructorFeedback': instructorFeedback,
        'equipmentFeedback': equipmentFeedback,
        'experienceFeedback': experienceFeedback,
        'feedback': feedback,
      };
}
