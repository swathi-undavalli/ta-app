import 'dart:convert';
import 'boat_details.dart';

class BoatsModel {
  final List<Boat>? boats;
  final Dsd? dsd;

  BoatsModel({
    required this.boats,
    required this.dsd,
  });

  BoatsModel copyWith({
    List<Boat>? boats,
    Dsd? dsd,
  }) =>
      BoatsModel(
        boats: boats ?? this.boats,
        dsd: dsd ?? this.dsd,
      );

  factory BoatsModel.fromRawJson(String str) =>
      BoatsModel.fromMap(json.decode(str));

  String toRawJson() => json.encode(toMap());

  factory BoatsModel.fromMap(Map<String, dynamic>? json) => BoatsModel(
        boats: List<Boat>.from(
          (json?['boats'] ?? ([])).map((x) => Boat.fromJson(x)),
        ),
        dsd: Dsd.fromJson(json?['dsd'] ?? {}),
      );

  Map<String, dynamic> toMap() => {
        'boats': List<dynamic>.from((boats ?? []).map((x) => x.toJson())),
        'dsd': dsd?.toJson(),
      };
}

class Dsd {
  Bcd? bcd;
  int? fins;
  int? mask;
  int? regulator;
  Weights? weights;
  int? powerMask;
  List<Instructor>? dayOffs;
  List<Instructor>? leaves;
  String? generalNotes;
  List<Instructor>? dsdPool;
  List<Instructor>? dsdOceanHead;
  List<Instructor>? courseCenter;
  List<Instructor>? centerStaff;
  List<Instructor>? harboursStaff;
  String? powerNotes;
  String? highTides;
  String? waves;
  String? lowTides;
  String? winds;

  Dsd({
    required this.bcd,
    required this.fins,
    required this.mask,
    required this.powerNotes,
    required this.regulator,
    required this.leaves,
    required this.powerMask,
    required this.weights,
    required this.dayOffs,
    required this.generalNotes,
    required this.dsdPool,
    required this.dsdOceanHead,
    required this.courseCenter,
    required this.centerStaff,
    required this.harboursStaff,
    required this.highTides,
    required this.lowTides,
    required this.waves,
    required this.winds,
  });

  Dsd copyWith({
    Bcd? bcd,
    int? fins,
    int? mask,
    int? regulator,
    int? powerMask,
    Weights? weights,
    List<Instructor>? dayOffs,
    List<Instructor>? leaves,
    List<Instructor>? centerStaff,
    List<Instructor>? dsdOceanHead,
    List<Instructor>? dsdPool,
    List<Instructor>? courseCenter,
    List<Instructor>? harboursStaff,
    String? generalNotes,
    String? powerNotes,
    String? highTides,
    String? lowTides,
    String? waves,
    String? winds,
  }) =>
      Dsd(
        bcd: bcd ?? this.bcd,
        fins: fins ?? this.fins,
        powerNotes: powerNotes ?? this.powerNotes,
        regulator: regulator ?? this.regulator,
        mask: mask ?? this.mask,
        powerMask: powerMask ?? this.powerMask,
        weights: weights ?? this.weights,
        dayOffs: dayOffs ?? this.dayOffs,
        leaves: leaves ?? this.leaves,
        generalNotes: generalNotes ?? this.generalNotes,
        highTides: highTides ?? this.highTides,
        lowTides: lowTides ?? this.lowTides,
        waves: waves ?? this.waves,
        winds: winds ?? this.winds,
        dsdPool: dsdPool ?? this.dsdPool,
        centerStaff: centerStaff ?? this.centerStaff,
        courseCenter: courseCenter ?? this.courseCenter,
        dsdOceanHead: dsdOceanHead ?? this.dsdOceanHead,
        harboursStaff: harboursStaff ?? this.harboursStaff,
      );

  factory Dsd.fromRawJson(String str) => Dsd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Dsd.fromJson(Map<String, dynamic> json) => Dsd(
        bcd: Bcd.fromJson((json['bcd']) ?? {}),
        fins: json['fins'],
        regulator: json['regulator'],
        powerNotes: json['powerNotes'],
        mask: json['mask'],
        powerMask: json['powerMask'],
        weights: Weights.fromJson((json['weights']) ?? {}),
        dayOffs: List<Instructor>.from(
          ((json['dayOffs']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        leaves: List<Instructor>.from(
          ((json['leaves']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        dsdPool: List<Instructor>.from(
          ((json['dsdPool']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        centerStaff: List<Instructor>.from(
          ((json['centerStaff']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        courseCenter: List<Instructor>.from(
          ((json['courseCenter']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        dsdOceanHead: List<Instructor>.from(
          ((json['dsdOceanHead']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        harboursStaff: List<Instructor>.from(
          ((json['harboursStaff']) ?? []).map((x) => Instructor.fromJson(x)),
        ),
        generalNotes: json['generalNotes'],
        highTides: json['highTides'],
        lowTides: json['lowTides'],
        waves: json['waves'],
        winds: json['winds'],
      );

  Map<String, dynamic> toJson() => {
        'bcd': bcd?.toJson(),
        'fins': fins,
        'regulator': regulator,
        'powerNotes': powerNotes,
        'mask': mask,
        'powerMask': powerMask,
        'weights': weights?.toJson(),
        'dayOffs': List<dynamic>.from((dayOffs ?? []).map((x) => x.toJson())),
        'leaves': List<dynamic>.from((leaves ?? []).map((x) => x.toJson())),
        'dsdOceanHead':
            List<dynamic>.from((dsdOceanHead ?? []).map((x) => x.toJson())),
        'courseCenter':
            List<dynamic>.from((courseCenter ?? []).map((x) => x.toJson())),
        'centerStaff':
            List<dynamic>.from((centerStaff ?? []).map((x) => x.toJson())),
        'dsdPool': List<dynamic>.from((dsdPool ?? []).map((x) => x.toJson())),
        'harboursStaff':
            List<dynamic>.from((harboursStaff ?? []).map((x) => x.toJson())),
        'generalNotes': generalNotes,
        'highTides': highTides,
        'lowTides': lowTides,
        'waves': waves,
        'winds': winds,
      };
}

class Bcd {
  int? kids;
  int? xxs;
  int? xs;
  int? s;
  int? m;
  int? l;
  int? xl;
  int? xxl;

  Bcd({
    required this.kids,
    required this.xxs,
    required this.xs,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
    required this.xxl,
  });

  Bcd copyWith({
    int? kids,
    int? xxs,
    int? xs,
    int? s,
    int? m,
    int? l,
    int? xl,
    int? xxl,
  }) =>
      Bcd(
        kids: kids ?? this.kids,
        xxs: xxs ?? this.xxs,
        xs: xs ?? this.xs,
        s: s ?? this.s,
        m: m ?? this.m,
        l: l ?? this.l,
        xl: xl ?? this.xl,
        xxl: xxl ?? this.xxl,
      );

  factory Bcd.fromRawJson(String str) => Bcd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bcd.fromJson(Map<String, dynamic> json) => Bcd(
        kids: json['kids'],
        xxs: json['XXS'],
        xs: json['XS'],
        s: json['S'],
        m: json['M'],
        l: json['L'],
        xl: json['XL'],
        xxl: json['XXL'],
      );

  Map<String, dynamic> toJson() => {
        'kids': kids,
        'XXS': xxs,
        'XS': xs,
        'S': s,
        'M': m,
        'L': l,
        'XL': xl,
        'XXL': xxl,
      };
}

class Weights {
  int? w3;
  int? w4;
  int? w5;
  int? w6;
  int? w7;

  Weights({
    required this.w3,
    required this.w4,
    required this.w5,
    required this.w6,
    required this.w7,
  });

  Weights copyWith({
    int? w3,
    int? w4,
    int? w5,
    int? w6,
    int? w7,
  }) =>
      Weights(
        w3: w3 ?? this.w3,
        w4: w4 ?? this.w4,
        w5: w5 ?? this.w5,
        w6: w6 ?? this.w6,
        w7: w7 ?? this.w7,
      );

  factory Weights.fromRawJson(String str) => Weights.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Weights.fromJson(Map<String, dynamic> json) => Weights(
        w3: json['w3'],
        w4: json['w4'],
        w5: json['w5'],
        w6: json['w6'],
        w7: json['w7'],
      );

  Map<String, dynamic> toJson() => {
        'w3': w3,
        'w4': w4,
        'w5': w5,
        'w6': w6,
        'w7': w7,
      };
}

class Boat {
  final List<Instructor>? captains;
  final List<Instructor>? dsdInstructors;
  final List<Instructor>? photographer;
  final String id;
  final String time;
  final List<Instructor>? surfaceSupport;
  final List<Instructor>? internPhotoVideo;
  final String? notes;
  final int? nitrox;
  final int? air;
  final bool? hideBoat;
  final String name;
  final String? diveSite;
  int? boatStatus;

  Boat({
    required this.captains,
    required this.dsdInstructors,
    required this.photographer,
    required this.time,
    required this.hideBoat,
    required this.id,
    required this.nitrox,
    required this.air,
    required this.surfaceSupport,
    required this.internPhotoVideo,
    required this.notes,
    required this.name,
    required this.diveSite,
    required this.boatStatus,
  });

  Boat copyWith({
    List<Instructor>? captains,
    List<Instructor>? dsdInstructors,
    List<Instructor>? photographer,
    String? id,
    String? time,
    int? nitrox,
    int? air,
    bool? hideBoat,
    int? boatStatus,
    String? notes,
    List<Instructor>? surfaceSupport,
    List<Instructor>? internPhotoVideo,
    String? name,
    String? diveSite,
  }) =>
      Boat(
        captains: captains ?? this.captains,
        dsdInstructors: dsdInstructors ?? this.dsdInstructors,
        photographer: photographer ?? this.photographer,
        id: id ?? this.id,
        time: time ?? this.time,
        air: air ?? this.air,
        nitrox: nitrox ?? this.nitrox,
        hideBoat: hideBoat ?? this.hideBoat,
        surfaceSupport: surfaceSupport ?? this.surfaceSupport,
        internPhotoVideo: internPhotoVideo ?? this.internPhotoVideo,
        notes: notes ?? this.notes,
        name: name ?? this.name,
        diveSite: diveSite ?? this.diveSite,
        boatStatus: boatStatus ?? this.boatStatus,
      );

  factory Boat.fromRawJson(String str) => Boat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Boat.fromJson(Map<String, dynamic> json) => Boat(
        captains: List<Instructor>.from(
          (json['captains'] ?? []).map((x) => Instructor.fromJson(x)),
        ),
        dsdInstructors: List<Instructor>.from(
          (json['dsdInstructors'] ?? []).map((x) => Instructor.fromJson(x)),
        ),
        photographer: List<Instructor>.from(
          (json['photographer'] ?? []).map((x) => Instructor.fromJson(x)),
        ),
        id: json['id'],
        time: json['time'],
        notes: json['notes'],
        nitrox: json['nitrox'],
        air: json['air'],
        hideBoat: json['hideBoat'],
        surfaceSupport: List<Instructor>.from(
          (json['surfaceSupport'] ?? []).map((x) => Instructor.fromJson(x)),
        ),
        internPhotoVideo: List<Instructor>.from(
          (json['internPhotoVideo'] ?? []).map((x) => Instructor.fromJson(x)),
        ),
        diveSite: json['diveSite'],
        name: json['name'],
        boatStatus: json['boatStatus'],
      );

  Map<String, dynamic> toJson() => {
        'captains': List<dynamic>.from((captains ?? []).map((x) => x.toJson())),
        'dsdInstructors':
            List<dynamic>.from((dsdInstructors ?? []).map((x) => x.toJson())),
        'photographer':
            List<dynamic>.from((photographer ?? []).map((x) => x.toJson())),
        'id': id,
        'time': time,
        'surfaceSupport':
            List<dynamic>.from((surfaceSupport ?? []).map((x) => x.toJson())),
        'internPhotoVideo':
            List<dynamic>.from((internPhotoVideo ?? []).map((x) => x.toJson())),
        'notes': notes,
        'air': air,
        'hideBoat': hideBoat,
        'diveSite': diveSite,
        'nitrox': nitrox,
        'name': name,
        'boatStatus': boatStatus,
      };
}
