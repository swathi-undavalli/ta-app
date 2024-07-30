import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/firebase/api.dart';
import '../../../../core/util/alignment_extensions.dart';
import '../../../../core/util/spacing_widgets.dart';
import '../../../../core/widgets/app_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/ta_image.dart';
import '../../../employees/model/employee.dart';
import '../../models/category.dart';
import '../../models/offer.dart';

class AddOffersView extends StatefulWidget {
  const AddOffersView({super.key, required this.offer, required this.categories});
  final Offer? offer;
  final List<Categories> categories;

  static Route route(Offer? offer, List<Categories> newCategories) => MaterialPageRoute(
        builder: (context) => AddOffersView(
          offer: offer,
          categories: newCategories,
        ),
      );

  @override
  State<AddOffersView> createState() => _AddOffersViewState();
}

class _AddOffersViewState extends State<AddOffersView> {
  Categories? selectedCategory;
  TextEditingController nameTED = TextEditingController();
  TextEditingController descriptionTED = TextEditingController();
  DateTimeRange? dateRange;
  DateTime? startDate;
  DateTime? endDate;
  List<Timestamp> validDates = [];
  List<File> pickedMediaFiles = [];
  Map<File, String> uploadedFiles = {};
  File? pickedImage;
  int selectedImageIndex = 0;
  bool showLoading = false;
  Offer? offer;
  List<Categories> newCategories = [];
  @override
  void initState() {
    super.initState();
    clear();

    offer = widget.offer;

    newCategories = widget.categories;

    if (offer != null) {
      init(offer);
    }
  }

  Future<void> init(Offer? offer) async {
    showLoading = true;
    setState(() {});
    log(newCategories.toString());

    for (Categories cat in newCategories) {
      if (cat.id == offer?.categoryId) {
        selectedCategory = cat;
        setState(() {});
      }
    }

    nameTED.text = offer?.name ?? '';
    descriptionTED.text = offer?.description ?? '';
    if (offer?.validDates != [] && offer?.validDates?.length == 2) {
      startDate = offer?.validDates?.first.toDate();
      endDate = offer?.validDates?.last.toDate();
      validDates = offer?.validDates ?? [];
    }
    for (String link in offer?.photos ?? []) {
      var image = await getImageFileFromURL(link);
      pickedMediaFiles.add(image);
      uploadedFiles[image] = link;
      setState(() {});
    }
    showLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: () async {
            clear();
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColors.background.lightBlue,
            appBar: AppBarWidget(
              heading: (offer != null) ? 'Edit Offer' : 'Add Offer',
            ),
            body: SafeArea(
              child: Column(
                children: [
                  buildCategoryDropdown(),
                  Spacing.h15,
                  buildName(),
                  Spacing.h30,
                  buildValidDates(),
                  Spacing.h30,
                  buildDescription(),
                  Spacing.h30,
                  buildUploadPhotos(),
                  Spacing.h50,
                  buildAddButton(),
                  Spacing.h30,
                ],
              ).paddingAll(20).scrollable,
            ),
          ),
        ),
        buildShowLoading(),
      ],
    );
  }

  Widget buildAddButton() {
    return AppButton.flat(
      text: (offer != null) ? 'Update' : 'Add',
      onTap: () async {
        await onAddPressed();
        if (mounted) {
          Navigator.pop(context);
        }
      },
      color: Colors.black,
      textColor: Colors.white,
    );
  }

  Widget buildUploadPhotos() {
    return GestureDetector(
      onTap: () {
        if (pickedMediaFiles.isEmpty) {
          _showImageSourceBottomSheet();
        }
      },
      child: (pickedMediaFiles.isEmpty) ? _buildNoImageBox() : buildPhotos(),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              ListTile(
                leading: TAImage(
                  AppImages.icons.camera,
                ),
                title: const Text(
                  'Camera',
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: TAImage(
                  AppImages.icons.gallery,
                ),
                title: const Text(
                  'Gallery',
                ),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoImageBox() {
    return Container(
      height: 183,
      width: Screen.width,
      decoration: BoxDecoration(
        // color: const Color(0xffC4C4C4),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TAImage(AppImages.icons.add, color: Colors.black, height: 30, width: 30),
          Spacing.h33,
          const Text('Add Photos'),
        ],
      ),
    ).center;
  }

  Widget buildPhotos() {
    return Container(
      height: 183,
      width: Screen.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xffc4c4c4),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.black.withOpacity(0.6),
            const Color(0x00000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: pickedMediaFiles.isNotEmpty
                ? Image.file(
                    pickedMediaFiles[selectedImageIndex],
                    height: Screen.width * 4 / 3,
                    width: Screen.width,
                    fit: BoxFit.cover,
                  )
                : _buildNoImageBox(),
          ),
          if (pickedMediaFiles.isNotEmpty)
            Positioned(
              bottom: 16,
              child: SizedBox(
                height: 40,
                width: Screen.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...List.generate(pickedMediaFiles.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            onImageHolderTap(index);
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: index == selectedImageIndex ? 1.5 : 0,
                              ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.file(
                                pickedMediaFiles[index],
                                height: 45,
                                width: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ).paddingOnly(right: 5);
                      }),
                      GestureDetector(
                        onTap: () {
                          if (!showLoading) {
                            _showImageSourceBottomSheet();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: AppColors.text.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: TAImage(
                            AppImages.icons.add,
                            color: Colors.black,
                            height: 14,
                            width: 14,
                          ).center,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 100),
                ),
              ),
            ),
          Positioned(
            right: 10,
            top: 10,
            child: GestureDetector(
              onTap: () {
                if (!showLoading) onImageDeleteTap();
              },
              child: Container(
                height: 24,
                width: 24,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: TAImage(
                  AppImages.icons.cancel,
                  height: 24,
                  width: 24,
                  color: Colors.black,
                ).paddingAll(5),
              ),
            ),
          ),
        ],
      ),
    ).center;
  }

  Widget buildName() {
    return TextField(
      controller: nameTED,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        labelText: 'Name',
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildDescription() {
    return TextField(
      controller: descriptionTED,
      maxLines: 3,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: 'Description',
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButton<Categories>(
        hint: const Text('Select Category'),
        underline: Container(height: 0, color: Colors.transparent),
        isExpanded: true,
        value: selectedCategory,
        onChanged: (Categories? newValue) {
          selectedCategory = newValue;
          setState(() {});
        },
        items: newCategories.map((value) {
          return DropdownMenuItem<Categories>(
            value: value,
            child: Text(
              value.name,
            ),
          );
        }).toList(),
      ).paddingSymmetric(horizontal: 15, vertical: 5),
    );
  }

  Widget buildValidDates() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: Screen.width,
                child: Text(
                  'Valid Dates',
                  style: TextStyle(color: AppColors.text.black, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            (startDate == null && endDate == null)
                ? AppButton.miniFlat(
                    onTap: () {
                      showDateRangePickerBottomSheet(context);
                    },
                    text: 'Apply',
                  ).center
                : GestureDetector(
                    onTap: () {
                      showDateRangePickerBottomSheet(context);
                    },
                    child: const Text(
                      'Change',
                      style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                    ),
                  ),
          ],
        ),
        Spacing.h10,
        if (startDate != null && endDate != null)
          Text(
            "${DateFormat("dd-MM-yyyy").format(startDate!)} - ${DateFormat("dd-MM-yyyy").format(endDate!)}",
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
      ],
    );
  }

  Future showDateRangePickerBottomSheet(BuildContext context) {
    return showDateRangePicker(
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData.from(
            colorScheme: const ColorScheme.light(
              primary: Color(0xff376aed),
            ),
          ),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400.0,
                ),
                child: child,
              ),
            ],
          ),
        );
      },
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      currentDate: DateTime.now(),
    ).then((pickedDateRange) async {
      if (pickedDateRange != null) {
        dateRange = pickedDateRange;
        startDate = dateRange!.start;
        endDate = dateRange!.end;
      }
      setState(() {});
      validDates = [];

      showLoading = true;

      if (startDate != null) {
        Timestamp startTimestamp = Timestamp.fromDate(startDate!);
        validDates.add(startTimestamp);
      }
      if (endDate != null) {
        Timestamp endTimestamp = Timestamp.fromDate(endDate!);
        validDates.add(endTimestamp);
      }
      showLoading = false;
    });
  }

  Future<File> getImageFileFromURL(String image) async {
    final response = await http.get(Uri.parse(image));

    final documentDirectory = await getTemporaryDirectory();

    final file = File(
      path.join(documentDirectory.path, '${DateTime.now().microsecondsSinceEpoch}.png'),
    );

    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  Future<void> pickImage(ImageSource source) async {
    if (PermissionStatus.granted.isGranted) {
      final result = await ImagePicker().pickImage(source: source);

      if (result != null) {
        pickedImage = File(result.path);
        pickedMediaFiles.add(pickedImage!);
        setState(() {});
      }
    }
  }

  Future<void> onImageHolderTap(selectedIndex) async {
    selectedImageIndex = selectedIndex;
    setState(() {});
  }

  Future<void> onImageDeleteTap() async {
    log(selectedImageIndex.toString());
    log(pickedMediaFiles.length.toString());
    log(pickedMediaFiles.toString());

    if (pickedMediaFiles.length == 1) {
      selectedImageIndex = 0;
      pickedMediaFiles = [];
      setState(() {});

      return;
    }
    if (selectedImageIndex + 1 == pickedMediaFiles.length) {
      selectedImageIndex = selectedImageIndex - 1;
      pickedMediaFiles.removeLast();
      log(selectedImageIndex.toString());
    } else {
      pickedMediaFiles.removeAt(selectedImageIndex);
      log(selectedImageIndex.toString());
    }
    setState(() {});
  }

  Future<List<String>> uploadImages() async {
    List<String> downloadURLs = [];

    for (int i = 0; i < pickedMediaFiles.length; i++) {
      File imageFile = pickedMediaFiles[i];

      if (uploadedFiles[imageFile] != null) {
        downloadURLs.add(uploadedFiles[imageFile]!);
      } else {
        try {
          String fileName = '${DateTime.now().millisecondsSinceEpoch}_$i';

          Reference storageReference = FirebaseStorage.instance.ref().child('offers/$fileName.jpg');

          await storageReference.putFile(imageFile);

          String downloadURL = await storageReference.getDownloadURL();
          downloadURLs.add(downloadURL);

          log('Image $i uploaded. Download URL: $downloadURL');
        } catch (error) {
          log('Error uploading image $i: $error');
        }
      }
    }

    return downloadURLs;
  }

  Future<void> onAddPressed() async {
    showLoading = true;
    setState(() {});
    List<String> downloadURLs = await uploadImages();

    Offer newOffer = Offer(
      id: offer?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      categoryId: selectedCategory?.id,
      name: nameTED.text,
      validDates: validDates,
      description: descriptionTED.text,
      photos: downloadURLs,
      createdBy: currentEmployee?.name ?? '',
    );

    await firebaseApi.updateOffer(newOffer);

    showLoading = false;
    setState(() {});

    clear();
  }

  Widget buildShowLoading() {
    if (showLoading) {
      return Material(
        color: Colors.transparent,
        child: Container(
          color: Colors.black54,
          height: Screen.height,
          width: Screen.width,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  clear() {
    nameTED.text = '';
    descriptionTED.text = '';
    validDates = [];
    pickedMediaFiles = [];
    selectedCategory = null;
    startDate = null;
    endDate = null;
    selectedImageIndex = 0;
    pickedImage = null;
    uploadedFiles = {};
    newCategories = [];
  }
}
