import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/temple_ui_tools.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../../core/constants/constants.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background.black,
      appBar: EquipmentAppBar(
        title: 'All Equipment',
        description: 'All the available equipment for renting',
        action: IconButton(
          onPressed: () {
            Navigator.push(context, AddEquipmentView.route(null));
          },
          icon: const Icon(Icons.add_circle_outline_rounded),
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

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      const _GenerateOTPBanner(),
                      const _ManageEquipmentBanner(),
                      ...provider.items.map((EquipmentItem item) {
                        return _EquipmentItemTile(item: item);
                      }),
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
    );
  }
}

class _EquipmentItemTile extends StatelessWidget {
  final EquipmentItem item;

  const _EquipmentItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    double size = (Screen.width / 3) - 15 * 2;

    return InkWell(
      onTap: () {},
      onLongPress: () {
        // TODO : Enable editing feature in next version
      },
      child: Selector<EquipmentProvider, List<EquipmentItem>>(
        selector: (context, provider) => provider.selectedItems,
        builder: (context, selectedItems, child) {
          bool isSelected = selectedItems.contains(item);

          return GestureDetector(
            onTap: () {
              context.read<EquipmentProvider>().toggleItemSelection(item);
            },
            child: Column(
              children: [
                Container(
                  height: size,
                  width: size,
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
                Spacing.h4,
                Text(
                  item.name,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ManageEquipmentBanner extends StatelessWidget {
  const _ManageEquipmentBanner();

  @override
  Widget build(BuildContext context) {
    return BannerContainer(
      child: Row(
        children: [
          RichText(
            text: const TextSpan(
              text: 'You have already rented ',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
              ),
              children: <TextSpan>[
                TextSpan(text: '3 ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'items'),
              ],
            ),
          ),
          const Spacer(),
          _MiniButton(
            text: 'Manage',
            onTap: () => Navigator.push(context, EquipmentSummaryView.route()),
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
  }
}

class _GenerateOTPBanner extends StatelessWidget {
  const _GenerateOTPBanner();

  @override
  Widget build(BuildContext context) {
    return BannerContainer(
      child: Row(
        children: [
          RichText(
            text: const TextSpan(
              text: 'Share ',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
              ),
              children: <TextSpan>[
                TextSpan(text: 'OTP', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' for verification', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          _MiniButton(
            text: 'Generate',
            onTap: () => Navigator.push(context, GenerateOTPView.route()),
          ),
        ],
      ).paddingSymmetric(horizontal: 16),
    );
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