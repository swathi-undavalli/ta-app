import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import 'package:temple_ui_tools/utils/utils.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/widgets/access_levels.dart';
import '../../../../core/widgets/app_button.dart';
import '../../models/equipment_model.dart';
import '../../provider/equipment.provider.dart';
import '../widgets/banner_container.dart';
import '../widgets/equipment_app_bar.dart';
import '../widgets/equipment_body.dart';
import 'add_equipment_view.dart';
import 'equipment_summary_view.dart';
import 'generate_otp_view.dart';

class AllEquipmentView extends StatefulWidget {
  const AllEquipmentView({super.key});

  static Route route() => MaterialPageRoute(
        builder: (context) => const AllEquipmentView(),
      );

  @override
  State<AllEquipmentView> createState() => _AllEquipmentViewState();
}

class _AllEquipmentViewState extends State<AllEquipmentView> {
  late final EquipmentProvider provider;

  @override
  void initState() {
    super.initState();

    provider = context.read<EquipmentProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchEquipmentItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        provider.selectedItems.clear();
        provider.selectedPieces.clear();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.background.black,
        appBar: EquipmentAppBar(
          title: 'All Equipment',
          description: 'All the available equipment for renting',
          action: EmployeeAccess(
            access: AccessRights.addEquipment,
            child: IconButton(
              onPressed: () {
                Navigator.push(context, AddEquipmentView.route(null));
              },
              icon: const Icon(Icons.add_circle_outline_rounded),
            ),
          ),
        ),
        body: Stack(
          children: [
            EquipmentBody(
              child: Consumer<EquipmentProvider>(
                builder: (context, provider, child) {
                  if (provider.status == EquipmentStatus.loading) {
                    return const CircularProgressIndicator(
                      color: Colors.black,
                    ).center;
                  }

                  if (provider.status == EquipmentStatus.error) {
                    return Text('Error: ${provider.error}');
                  }

                  if (provider.status == EquipmentStatus.loaded) {
                    if (provider.items.isEmpty) {
                      return const Text(
                        'No equipments found please add few',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ).center;
                    }

                    Iterable<EquipmentCategory> categories = provider.items.map((item) => item.category).toSet();

                    return Column(
                      spacing: 16,
                      children: [
                        const _GenerateOTPBanner().paddingOnly(bottom: 8),
                        ...categories.map(
                          (EquipmentCategory category) {
                            return _ExpansionPanel(
                                    category: category,
                                    items: provider.items.where((item) => item.category.id == category.id).toList())
                                .paddingHorizontal(16);
                          },
                        ),
                        Spacing.h100,
                      ],
                    ).paddingOnly(top: 16).center.scrollable;
                  }

                  return const SizedBox();
                },
              ),
            ),
            const _RentNowBanner(),
          ],
        ),
      ),
    );
  }
}

class _EquipmentItemTile extends StatelessWidget {
  final EquipmentItem item;

  const _EquipmentItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Selector<EquipmentProvider, List<EquipmentItem>>(
      selector: (context, provider) => provider.selectedItems,
      builder: (context, selectedItems, child) {
        bool isSelected = selectedItems.contains(item);

        return InkWell(
          onTap: () {
            context.read<EquipmentProvider>().toggleItemSelection(item);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.background.skyBlue : const Color(0xffB3B3B3),
                    width: isSelected ? 2 : 0.5,
                  ),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(item.photo ?? placeHolderImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Spacing.w20,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name.capitalized,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  if (AccessRights.addEquipment)
                    InkWell(
                      onTap: () {
                        Navigator.push(context, AddEquipmentView.route(item));
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: AppColors.text.skyBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ).paddingOnly(top: 20),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GenerateOTPBanner extends StatelessWidget {
  const _GenerateOTPBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Screen.width,
      decoration: BoxDecoration(
        color: appBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Spacing.w8,
          Flexible(
            child: Column(
              children: [
                Spacing.h8,
                Spacing.h8,
                const Text(
                  'Generate OTP',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ).left,
                Spacing.h8,
                RichText(
                  text: const TextSpan(
                    text: 'Share',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 12,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: ' OTP ', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: 'with your dive buddy for equipment '),
                      TextSpan(text: 'verification.', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Spacing.h8,
                Spacing.h8,
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
          _MiniButton(
            text: 'Generate',
            onTap: () => Navigator.push(context, GenerateOTPView.route()),
          ),
          Spacing.w8,
        ],
      ),
    ).paddingHorizontal(16);
  }
}

class _RentNowBanner extends StatelessWidget {
  const _RentNowBanner();

  @override
  Widget build(BuildContext context) {
    return Selector<EquipmentProvider, List<EquipmentItem>>(
      selector: (context, provider) => provider.selectedItems,
      shouldRebuild: (old, newEq) => true, // TODO: Update condition as needed
      builder: (context, selectedItems, child) {
        if (selectedItems.isEmpty) return const SizedBox();

        return Positioned(
          bottom: 40,
          child: BannerContainer(
            height: 45,
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '${selectedItems.length} ',
                    style: bannerTextStyle,
                    children: const <TextSpan>[
                      TextSpan(text: 'Items selected', style: TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, EquipmentSummaryView.route());
                  },
                  child: Text(
                    'Rent now',
                    style: bannerButtonStyle.copyWith(color: Colors.blue), // Replace with AppColors.text.skyBlue
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ).center.width(Screen.width),
        );
      },
    );
  }
}

class _MiniButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const _MiniButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.skyBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(text, style: bannerButtonStyle),
      ),
    );
  }
}

class _ExpansionPanel extends StatefulWidget {
  final EquipmentCategory category;
  final List<EquipmentItem> items;
  const _ExpansionPanel({required this.category, required this.items});

  @override
  State<_ExpansionPanel> createState() => _ExpansionPanelState();
}

class _ExpansionPanelState extends State<_ExpansionPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // color: appBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: appBlue.withOpacity(0.1),
                  ),
                  child: Text(
                    '${widget.items.length}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ).center.paddingAll(8),
                ).paddingOnly(left: 8),
                Expanded(
                  child: CustomTitle(
                    title: widget.category.name.capitalized,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ).paddingOnly(left: 15, right: 15),
                ),
                Selector<EquipmentProvider, List<EquipmentItem>>(
                  selector: (context, provider) => provider.selectedItems,
                  shouldRebuild: (old, newEq) => true, // TODO: Update condition as needed
                  builder: (context, selectedItems, child) {
                    final currentItems = selectedItems.where((item) => item.category == widget.category);

                    if (currentItems.isEmpty) return const SizedBox();
                    return Container(
                      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '${currentItems.length} Selected',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ).paddingSymmetric(horizontal: 8, vertical: 4),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: _expanded
                ? Column(
                    children: [
                      ...widget.items.map((EquipmentItem item) {
                        return _EquipmentItemTile(item: item).paddingAll(10);
                      }),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    super.key,
    required this.title,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
  });
  final String title;
  final double fontSize;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: fontWeight),
    );
  }
}

extension StringCasingExtension on String {
  String get capitalized {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
