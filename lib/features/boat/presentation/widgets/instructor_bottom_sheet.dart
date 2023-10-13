import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import '../../models/boat_details.dart';
import 'tank_counter.dart';

class InstructorTanksBottomSheet extends StatefulWidget {
  final List<Instructor> instructors;
  final List<int> air;
  final List<int> nitrox;

  const InstructorTanksBottomSheet({
    Key? key,
    required this.instructors,
    required this.air,
    required this.nitrox,
  }) : super(key: key);

  static Future<List<List<int>>?> show(
    BuildContext context, {
    required List<Instructor> initialSelectedEmployees,
    required List<int> air,
    required List<int> nitrox,
  }) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return InstructorTanksBottomSheet(
          instructors: initialSelectedEmployees,
          air: air,
          nitrox: nitrox,
        );
      },
    );

    return data as List<List<int>>?;
  }

  @override
  State<InstructorTanksBottomSheet> createState() =>
      _InstructorTanksBottomSheetState();
}

class _InstructorTanksBottomSheetState
    extends State<InstructorTanksBottomSheet> {
  late Map<Instructor, List<int>> instructorTanks;

  @override
  void initState() {
    super.initState();
    instructorTanks = {};
    if (widget.nitrox.length != widget.instructors.length ||
        widget.air.length != widget.instructors.length) {
      widget.nitrox.clear();
      widget.air.clear();
      for (int i = 0; i < widget.instructors.length; i++) {
        widget.nitrox.add(0);
        widget.air.add(0);
      }
    }
    for (int i = 0; i < widget.instructors.length; i++) {
      instructorTanks[widget.instructors[i]] = [
        widget.nitrox[i],
        widget.air[i]
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Manage Divers',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ).paddingOnly(top: 8),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...widget.instructors.map(
              (instructor) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${instructor.name} : ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 15),
                  TankCounter(
                      onChanged: (n, a) {
                        instructorTanks[instructor]![0] = n;
                        instructorTanks[instructor]![1] = a;
                      },
                      nitrox: instructorTanks[instructor]![0],
                      air: instructorTanks[instructor]![1],)
                ],
              ).paddingOnly(bottom: 30),
            )
          ],
        ).paddingSymmetric(horizontal: 25),
      ),
    );
  }

  void onClose() async {
    List<int> air = [];
    List<int> nitrox = [];
    for (Instructor instructor in widget.instructors) {
      nitrox.add(instructorTanks[instructor]![0]);
      air.add(instructorTanks[instructor]![1]);
    }

    Navigator.pop(context, [nitrox, air]);
  }
}
