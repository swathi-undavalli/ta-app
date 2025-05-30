import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:temple_ui_tools/styling/padding_extensions.dart';
import 'package:temple_ui_tools/styling/spacing_widgets.dart';

import '../../../core/constants/constants.dart';
import '../../../core/widgets/app_bar.dart';
import '../models/dive_site.model.dart';
import '../widgets/dive_site_card.dart';
import 'add_edit_dive_site_view.dart';

class AllDiveSitesView extends StatefulWidget {
  const AllDiveSitesView({super.key});

  static Route<DiveSiteModel?> route() {
    return MaterialPageRoute(
      builder: (BuildContext context) {
        return const AllDiveSitesView();
      },
    );
  }

  @override
  State<AllDiveSitesView> createState() => _AllDiveSitesViewState();
}

class _AllDiveSitesViewState extends State<AllDiveSitesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background.lightBlue,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(context, AddEditDiveSiteView.route(null));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: const AppBarWidget(heading: 'Dive Sites'),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream:
              FirebaseFirestore.instance.collection('dive_sites').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Dive Sites Found'));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Spacing.h20,
                      ...snapshot.data!.docs.map((DocumentSnapshot document) {
                        try {
                          DiveSiteModel? diveSite = DiveSiteModel.fromMap(
                            document.data() as Map<String, dynamic>,
                          );
                          return DiveSiteCard(
                            onTap: () {
                              Navigator.pop(context, diveSite);
                            },
                            diveSite: diveSite,
                            editOnTap: () {
                              Navigator.push(
                                context,
                                AddEditDiveSiteView.route(diveSite),
                              );
                            },
                          ).paddingSymmetric(vertical: 10);
                        } catch (e) {
                          return const SizedBox();
                        }
                      }),
                      Spacing.h100,
                    ],
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: 20);
          },
        ),
      ),
    );
  }
}
