import 'package:flutter/material.dart';

import '../../maps/repository/maps_repo.dart';
import '../models/dive_site.model.dart';

class AddEditDiveSitesProvider extends ChangeNotifier {
  final MapsRepository mapsRepository;
  bool showLoading = false;

  AddEditDiveSitesProvider({required this.mapsRepository});

  Future<void> addDiveSite(DiveSiteModel site) async {
    showLoading = true;
    notifyListeners();
    await mapsRepository.addDiveSite(site);
    showLoading = false;
    notifyListeners();
  }

  Future<void> editDiveSite(DiveSiteModel site) async {
    showLoading = true;
    notifyListeners();
    await mapsRepository.editDiveSite(site);
    showLoading = false;
    notifyListeners();
  }

  Future<void> deleteDiveSite(DiveSiteModel site) async {
    showLoading = true;
    notifyListeners();
    await mapsRepository.deleteDiveSite(site.id!);
    showLoading = false;
    notifyListeners();
  }
}
