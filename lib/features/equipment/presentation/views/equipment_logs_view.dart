import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../employees/model/employee.dart';
import '../../models/equipment_log_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import 'equipment_log_details_view.dart';

class EquipmentLogsView extends StatefulWidget {
  const EquipmentLogsView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const EquipmentLogsView(),
      );

  @override
  State<EquipmentLogsView> createState() => _EquipmentLogsViewState();
}

class _EquipmentLogsViewState extends State<EquipmentLogsView> {
  late final TextEditingController _searchController;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      context.read<EquipmentProvider>().fetchEmployees();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: const EquipmentAppBar(
        title: 'Equipment Logs',
        description: 'All equipment rental logs done by our team',
      ),
      body: EquipmentBody(
        child: Column(
          children: [
            Spacing.h24,
            Container(
              width: 328,
              height: 47,
              decoration: BoxDecoration(
                color: const Color(0xffEFFDFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff7D7D7D)),
              ),
              child: Container(
                margin: const EdgeInsets.only(left: 15, right: 15),
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                          disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                          hintText: 'Search',
                          hintStyle: TextStyle(fontSize: FontSize.textSize, height: 1, color: Color(0xff7D7D7D)),
                        ),
                        controller: _searchController,
                        onChanged: (_) {
                          timer = Timer(const Duration(microseconds: 250), () {
                            setState(() {});
                          });
                        },
                      ),
                    ),
                    const Icon(Icons.search, color: Color(0xff7D7D7D)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Selector<EquipmentProvider, List<Employee>>(
                selector: (context, provider) => provider.employees,
                builder: (context, value, child) {
                  var query = FirebaseFirestore.instance.collection('equipmentLogs').orderBy('collectorID');

                  if (_searchController.text.isNotEmpty) {
                    query = query.where('id', isGreaterThanOrEqualTo: _searchController.text);
                  }

                  return StreamBuilder<QuerySnapshot>(
                    stream: query.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Something went wrong! : ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data?.docs;

                      if (data == null || data.isEmpty) {
                        return const Center(child: Text('No data found.'));
                      }

                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final item = data[index].data() as Map<String, dynamic>;
                          EquipmentLog log = EquipmentLogMapper.fromMap(item);

                          if (index != 0) return _EquipmentLog(log: log);

                          return Column(
                            children: [
                              Spacing.h8,
                              _EquipmentLog(log: log),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EquipmentLog extends StatelessWidget {
  final EquipmentLog log;

  const _EquipmentLog({required this.log});

  @override
  Widget build(BuildContext context) {
    Employee? renter = context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.renterID);
    Employee? collector =
        context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.collectorID);
    Employee? approver =
        context.read<EquipmentProvider>().employees.firstWhereOrNull((emp) => emp.id == log.approverID);

    bool delayedReturn = false;
    int dueDays = 0;

    if (log.collectorID == null) {
      DateTime takeTime = log.time.toDate();
      DateTime now = DateTime.now();
      Duration diff = now.difference(takeTime);
      if (diff.inDays > 1) {
        delayedReturn = true;
        dueDays = diff.inDays;
      }
    }

    return InkWell(
      onTap: () {
        Navigator.push(context, EquipmentLogDetailsView.route(log));
      },
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 61,
                decoration: BoxDecoration(
                  color: log.collectorID != null
                      ? Colors.green.withOpacity(0.34)
                      : const Color(0xffD1F8FF).withOpacity(0.34),
                  borderRadius: BorderRadius.circular(16),
                  border: delayedReturn
                      ? Border.all(
                          color: Colors.red.shade700,
                          width: 3,
                        )
                      : null,
                ),
                child: Text(
                  log.id,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ).center,
              ),
              Spacing.w16,
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: _getName(renter) ?? 'Employee ${log.renterID}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        children: <TextSpan>[
                          const TextSpan(
                            text: ' rented ',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: log.pieces.length.toString(),
                          ),
                          TextSpan(
                            text: ' item${log.pieces.length == 1 ? '' : 's'}',
                            style: const TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                    Spacing.h4,
                    RichText(
                      text: TextSpan(
                        text: _getName(approver) ?? 'Employee ${log.approverID}',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                          color: Color(0xff7D7D7D),
                          fontSize: 12,
                        ),
                        children: <TextSpan>[
                          const TextSpan(text: ' approved on ', style: TextStyle(fontWeight: FontWeight.normal)),
                          TextSpan(text: DateFormat('MMM dd, yyyy hh:mm a').format(log.time.toDate())),
                        ],
                      ),
                    ),
                    if (delayedReturn)
                      RichText(
                        text: TextSpan(
                          text: 'Not returned for ',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.red.shade700,
                            fontSize: 14,
                            // fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$dueDays ',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: 'days'),
                          ],
                        ),
                      ),
                    if (log.collectorID != null) ...[
                      Spacing.h4,
                      RichText(
                        text: TextSpan(
                          text: _getName(collector) ?? 'Employee ${log.collectorID}',
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7D7D7D),
                            fontSize: 12,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: ' verified return on ', style: TextStyle(fontWeight: FontWeight.normal)),
                            TextSpan(text: DateFormat('MMM dd, yyyy hh:mm a').format(log.collectedTime.toDate())),
                          ],
                        ),
                      ),
                    ]
                  ],
                ).width(Screen.width),
              ),
            ],
          ).paddingSymmetric(horizontal: 26, vertical: 8),
          const Divider().paddingHorizontal(30),
        ],
      ),
    );
  }

  String? _getName(Employee? employee) {
    if (employee?.id == currentEmployee?.id) return 'You';
    if (employee?.nickName?.trim().isNotEmpty ?? false) {
      return employee?.nickName;
    }

    if (employee == null) return null;
    if (employee.name.length < 10) {
      return employee.name;
    }

    return employee.firstName;
  }
}
