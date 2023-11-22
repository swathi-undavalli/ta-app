import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/checklist_model.dart';
import '../../../dive_checklist/views/screens/new_checklist_view.dart';

class TemplateBottomSheet extends StatefulWidget {
  const TemplateBottomSheet({
    Key? key,
  }) : super(key: key);

  static Future<Checklist?> show(BuildContext context) async {
    var data = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return const TemplateBottomSheet();
      },
    );

    return data as Checklist?;
  }

  @override
  State<TemplateBottomSheet> createState() => _TemplateBottomSheetState();
}

class _TemplateBottomSheetState extends State<TemplateBottomSheet> {
  bool showLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 10,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          30,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('templates')
                  .doc('template')
                  .snapshots(),
              builder: (
                BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot,
              ) {
                if (snapshot.hasError ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.black,
                    ),
                  );
                }
                final data = snapshot.data?.data();

                if (data == null) {
                  return const SizedBox();
                }

                Checklist? checklist =
                    Checklist.fromMap(data as Map<String, dynamic>);

                if ((checklist.checklistElement ?? []).isEmpty) {
                  return const SizedBox();
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Template',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    ...(checklist.checklistElement ?? []).map(
                      (checklistElement) => buildChecklistTiles(
                        text: checklistElement.title,
                        onTap: () {
                          Get.toNamed(
                            NewChecklistView.id,
                            arguments: [checklistElement, false],
                          );
                        },
                      ).paddingOnly(bottom: 5),
                    ),
                    buildChecklistTiles(
                      text: 'Create custom checklist',
                      onTap: () {
                        Get.toNamed(
                          NewChecklistView.id,
                          arguments: [
                            ChecklistElement(
                              items: [],
                              employeeId: null,
                              id: '',
                              title: '',
                              description: '',
                            ),
                            false,
                          ],
                        );
                      },
                    ).paddingOnly(bottom: 5),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChecklistTiles({
    required String text,
    required Function onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.nunito,
              color: AppColors.text.darkgrey,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            onTap();
          },
          icon: Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.text.skyBlue,
            size: 20,
          ),
        ),
      ],
    );
  }
}
