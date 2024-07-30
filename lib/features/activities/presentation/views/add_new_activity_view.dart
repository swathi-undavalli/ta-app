
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/models/counter_model.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/util/utils.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/continue_dialog.dart';
import '../../../bookings/models/activity_model.dart';
import '../../../bookings/presentation/widgets/app_text_fields.dart';
import '../../../logs/models/log_model.dart';
import '../../../logs/presentation/views/log_view.dart';
import '../../model/colors_data.dart';

class AddNewActivityView extends StatefulWidget {
  const AddNewActivityView({super.key, required this.activity});

  static Route route(Activity? activity) => MaterialPageRoute(
        builder: (context) => AddNewActivityView(activity: activity),
      );

  final Activity? activity;

  @override
  State<AddNewActivityView> createState() => _AddNewActivityViewState();
}

class _AddNewActivityViewState extends State<AddNewActivityView> {
  late TextEditingController nameTED;
  late TextEditingController shortNameTED;
  late TextEditingController priceTED;
  late TextEditingController priorityTED;
  late TextEditingController colorTED;

  bool showLoading = false;

  List<String> priority = ['0', '1'];

  List<String> colorCode = ['Blue', 'Green', 'Purple', 'Red', 'White'];

  bool get isEditMode => widget.activity != null;

  @override
  void initState() {
    super.initState();

    nameTED = TextEditingController(text: widget.activity?.name);
    shortNameTED = TextEditingController(text: widget.activity?.shortName);
    priceTED = TextEditingController(text: widget.activity?.price.toString());
    colorTED = TextEditingController(text: widget.activity?.color);
    priorityTED = TextEditingController(text: widget.activity?.priority.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      appBar: AppBarWidget(
        heading: (isEditMode) ? 'Edit Activity' : 'Add Activity',
        actions: [
          if (isEditMode) buildDeleteButton(),
        ],
      ),
      body: PopScope(
        onPopInvoked: (_) {
          reset();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: (showLoading)
                ? SizedBox(
                    height: Screen.height,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: Colors.grey,
                      color: Colors.black,
                    ).center,
                  )
                : Column(
                    children: [
                      buildTextFields(
                        name: 'Name',
                        textEditingController: nameTED,
                      ),
                      buildTextFields(
                        name: 'Short name',
                        textEditingController: shortNameTED,
                      ),
                      buildTextFields(
                        name: 'Price',
                        textEditingController: priceTED,
                        keyBoardType: TextInputType.number,
                      ),
                      Spacing.h30,
                      buildPriority(),
                      Spacing.h30,
                      buildColorCode(),
                      Spacing.h100,
                      buildButtons(),
                    ],
                  ).paddingSymmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }

  ///===========UI============///

  Widget buildDeleteButton() {
    return IconButton(
      onPressed: () async {
        bool delete = await ContinueDialog.show(
          context,
          title: 'Are You Sure ? ',
          content: 'Activity will Be Deleted Permanently.',
        );
        if (delete) {
          FirebaseFirestore.instance.collection('catalogue').doc(widget.activity!.id).delete();
          if (mounted) Navigator.pop(context);
        }
      },
      icon: const Icon(
        Icons.delete,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  reset() {
    nameTED.text = '';
    shortNameTED.text = '';
    priceTED.text = '';
    priorityTED.text = '';
    colorTED.text = '';
  }

  Widget buildSubtitle(String name) {
    return SizedBox(
      width: Screen.width,
      child: Text(
        name,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: AppFonts.nunito,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  Widget buildPriority() {
    return Column(
      children: [
        buildSubtitle('Priority'),
        DropdownButton(
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: priorityTED.text.isNotEmpty ? priorityTED.text : null,
          onChanged: (dynamic priority) {
            priorityTED.text = priority;
            setState(() {});
          },
          items: priority.map((priority) {
            return DropdownMenuItem(
              value: priority,
              child: Text(priority),
            );
          }).toList(),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildColorCode() {
    return Column(
      children: [
        buildSubtitle('Color code'),
        DropdownButton(
          underline: Container(height: 1, color: Colors.grey),
          isExpanded: true,
          value: colorTED.text.isNotEmpty ? colorTED.text : null,
          onChanged: (dynamic newColor) {
            colorTED.text = newColor;
            setState(() {});
          },
          items: colorCode.map((color) {
            return DropdownMenuItem(
              value: color,
              child: Text(color),
            );
          }).toList(),
        ),
      ],
    ).paddingSymmetric(horizontal: 10);
  }

  Widget buildButtons() {
    return Row(
      children: [
        AppButton.flat(
          text: 'Cancel',
          textColor: AppColors.text.black,
          color: AppColors.background.grey,
          onTap: () {
            reset();
            Navigator.pop(context);
          },
        ),
        const Spacer(),
        AppButton.flat(
          text: (isEditMode) ? 'Update' : 'Submit',
          textColor: AppColors.text.white,
          color: AppColors.background.black,
          onTap: () {
            onSubmit();
          },
        ),
      ],
    );
  }

  onSubmit() async {
    if (nameTED.text.trim().isNotEmpty &&
        priceTED.text.trim().isNotEmpty &&
        priorityTED.text.trim().isNotEmpty &&
        colorTED.text.trim().isNotEmpty) {
      setState(() {
        showLoading = true;
      });

      String activityId;
      if (isEditMode) {
        activityId = widget.activity!.id!;
      } else {
        var data = await FirebaseFirestore.instance.collection('counter').doc('count').get();
        CounterModel counterModel = CounterModel.fromMap(data.data() ?? {});
        activityId = (counterModel.activity + 1).toString();
        counterModel = counterModel.copyWith(activity: int.tryParse(activityId) ?? 0);
        await FirebaseFirestore.instance.collection('counter').doc('count').set(counterModel.toMap());
      }

      Activity activity = Activity(
        name: nameTED.text,
        shortName: shortNameTED.text,
        price: int.parse(priceTED.text),
        priority: int.parse(priorityTED.text),
        color: colorTED.text,
        id: activityId,
      );

      await FirebaseFirestore.instance.collection('catalogue').doc(activityId).set(activity.toMap());

      if (isEditMode) {
        await updateColorsDocument();
      }

      LogModel logModel =
          LogModel(type: (isEditMode) ? LogType.editActivity : LogType.addActivity, activityName: activity.name);
      await FirebaseFirestore.instance.collection('logs').doc().set(logModel.toMap());

      Fluttertoast.showToast(msg: (isEditMode) ? 'Updated' : 'Saved');
      disposeKeyboard();
      reset();

      setState(() {
        showLoading = false;
      });
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> updateColorsDocument() async {
    var data = await FirebaseFirestore.instance.collection('catalogue').get();
    var map = {
      'Blue': [],
      'Purple': [],
      'White': [],
      'Red': [],
      'Green': [],
    };

    for (var d in data.docs) {
      if (d.id == 'colors') continue;
      var color = d.data()['color'];
      var name = d.data()['name'];
      map[color]!.add(name);
    }

    await FirebaseFirestore.instance.collection('catalogue').doc('colors').set(map);

    colorsData = ColorsDataModel.fromMap(map);
  }

  Widget buildTextFields({
    String? name,
    TextEditingController? textEditingController,
    TextInputType? keyBoardType = TextInputType.text,
  }) {
    return AppTextField(
      hintText: name,
      controller: textEditingController,
      required: false,
      keyboardType: keyBoardType,
      onChangedCallBack: (_) {},
      errorValidator: () {
        return null;
      },
      validator: (_) {
        return null;
      },
    );
  }
}
