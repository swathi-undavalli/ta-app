import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';

import '../../../core/util/utils.dart';
import '../../../core/widgets/app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../../bookings/presentation/widgets/app_text_fields.dart';
import '../../maps/repository/maps_repo.dart';
import '../models/dive_site.model.dart';
import '../providers/add_edit_dive_sites_provider.dart';

class AddEditDiveSiteView extends StatefulWidget {
  const AddEditDiveSiteView({super.key, this.diveSiteModel});

  final DiveSiteModel? diveSiteModel;

  static Route route(DiveSiteModel? diveSiteModel) {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return AddEditDiveSiteView(diveSiteModel: diveSiteModel);
      },
    );
  }

  @override
  State<AddEditDiveSiteView> createState() => _AddEditDiveSiteViewState();
}

class _AddEditDiveSiteViewState extends State<AddEditDiveSiteView> {
  late TextEditingController diveSiteTED;
  late TextEditingController latitudeTED;
  late TextEditingController longitudeTED;
  late final AddEditDiveSitesProvider provider;
  DiveSiteModel? diveSiteModel;

  @override
  void initState() {
    super.initState();
    diveSiteModel = widget.diveSiteModel;

    diveSiteTED = TextEditingController(text: diveSiteModel?.name);
    latitudeTED =
        TextEditingController(text: diveSiteModel?.latLang.latitude.toString());
    longitudeTED = TextEditingController(
      text: diveSiteModel?.latLang.longitude.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddEditDiveSitesProvider(
        mapsRepository: MapsRepository(),
      ),
      child: Consumer<AddEditDiveSitesProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBarWidget(
              heading: 'Add Dive Site',
              actions: [
                if (widget.diveSiteModel != null)
                  IconButton(
                    onPressed: () {
                      provider.deleteDiveSite(widget.diveSiteModel!);
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.black,
                    ),
                  ).paddingOnly(right: 20),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  AppTextField(
                    controller: diveSiteTED,
                    hintText: 'Dive site name',
                    required: true,
                  ),
                  AppTextField(
                    controller: latitudeTED,
                    hintText: 'Latitude',
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                  AppTextField(
                    controller: longitudeTED,
                    hintText: 'Longitude',
                    keyboardType: TextInputType.number,
                    required: true,
                  ),
                  const Spacer(),
                  AppButton.flat(
                    onTap: () async {
                      if (diveSiteTED.text.isEmpty &&
                          latitudeTED.text.isEmpty &&
                          longitudeTED.text.isEmpty) {
                        showToast('Please fill required fields');
                        return;
                      }

                      final lat = double.tryParse(latitudeTED.text);
                      final lng = double.tryParse(longitudeTED.text);

                      final diveSite = DiveSiteModel(
                        id: widget.diveSiteModel?.id,
                        name: diveSiteTED.text,
                        latLang: GeoPoint(lat!, lng!),
                      );

                      if (widget.diveSiteModel != null) {
                        await provider.editDiveSite(diveSite);
                      } else {
                        await provider.addDiveSite(diveSite);
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    text: (widget.diveSiteModel == null) ? 'Submit' : 'Update',
                    showLoading: provider.showLoading,
                  ),
                  const Spacer(),
                ],
              ).paddingAll(20),
            ),
          );
        },
      ),
    );
  }
}
