import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/alignment_extensions.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';
import 'package:temple_ui_tools/utils/utils.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/key_value_set.dart';
import '../models/dive_site.model.dart';

class DiveSiteCard extends StatelessWidget {
  const DiveSiteCard({
    super.key,
    required this.onTap,
    required this.editOnTap,
    required this.diveSite,
  });

  final Function onTap;
  final Function editOnTap;
  final DiveSiteModel diveSite;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: Screen.width,
        height: 141,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 141,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              child: Icon(
                Icons.navigation_rounded,
                color: AppColors.background.skyBlue,
                size: 70,
              ).center,
            ),
            Spacing.w10,
            const Spacer(),
            SizedBox(
              width: Screen.width - 173,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          diveSite.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.42,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          editOnTap();
                        },
                        icon: const Icon(
                          Icons.edit,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                  Spacing.h5,
                  const Spacer(),
                  KeyValueSets(
                    titleHeight: 20,
                    title: 'Latitude',
                    valueHeight: 20,
                    value: diveSite.latLang.latitude.toStringAsFixed(5),
                  ),
                  KeyValueSets(
                    titleHeight: 20,
                    title: 'Longitude',
                    valueHeight: 20,
                    value: diveSite.latLang.longitude.toStringAsFixed(5),
                  ),
                  const Spacer(),
                  Spacing.h4,
                ],
              ),
            ).paddingOnly(top: 20),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
