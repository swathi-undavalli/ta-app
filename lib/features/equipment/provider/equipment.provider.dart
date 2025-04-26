import 'dart:developer';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../employees/model/employee.dart';
import '../Repository/equipment.repository.dart';
import '../models/equipment_log_model.dart';
import '../models/equipment_model.dart';
import '../models/otp_validation_model.dart';

enum EquipmentStatus { loaded, loading, error }

class EquipmentProvider extends ChangeNotifier {
  final EquipmentRepository repository;
  EquipmentProvider(this.repository);

  List<EquipmentItem> items = [];
  List<EquipmentLog> logs = [];
  List<EquipmentItem> selectedItems = [];
  List<EquipmentPiece> selectedPieces = [];
  List<EquipmentCategory> categories = [];
  List<Employee> employees = [];

  // State variables
  String? error;
  String? firebaseTrackingId;
  String? otp;
  EquipmentStatus _status = EquipmentStatus.loading;

  // Getter & Setters
  EquipmentStatus get status => _status;

  set status(EquipmentStatus value) {
    _status = value;
    notifyListeners();
  }

  // Fetching Equipment Items
  void fetchEquipmentItems([bool force = false]) async {
    if (force == false && items.isNotEmpty) return;

    try {
      status = EquipmentStatus.loading;
      items = await repository.getEquipmentItems();
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  // Fetching Equipment Logs
  void fetchEquipmentLogs() async {
    try {
      status = EquipmentStatus.loading;
      logs = await repository.getEquipmentLogs();
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  // Fetching Categories
  void fetchCategories() async {
    if (categories.isNotEmpty) return;

    try {
      status = EquipmentStatus.loading;
      categories = await repository.getCategories();
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  // Fetching Employees
  void fetchEmployees() async {
    if (employees.isNotEmpty) return;

    try {
      status = EquipmentStatus.loading;
      employees = await repository.getEmployees();
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  void toggleItemSelection(EquipmentItem item) {
    selectedItems.contains(item) ? selectedItems.remove(item) : selectedItems.add(item);
    notifyListeners();
  }

  void togglePieceSelection(EquipmentPiece piece) {
    selectedPieces.contains(piece) ? selectedPieces.remove(piece) : selectedPieces.add(piece);
    notifyListeners();
  }

  // Adding New Equipment
  Future<void> addEquipment(
    EquipmentCategory category,
    String name,
    List<Tag> assignedTags,
    String photoURL,
  ) async {
    try {
      status = EquipmentStatus.loading;
      final equipmentItem = await repository.addNewEquipment(
        category: category,
        name: name,
        photoURL: photoURL,
        assignedTags: assignedTags,
      );
      items.add(equipmentItem);
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  // OTP Verification
  Future<void> onOTPChange(String pin) async {
    otp = pin;
    error = null;
    notifyListeners();
  }

  // OTP Verification
  Future<void> verifyOTP(String otp) async {
    // look for all docs with OTP.
    // if employee found show details of employee,
    status = EquipmentStatus.loading;
    try {
      final query = await FirebaseFirestore.instance
          .collection('otpValidation')
          .where('otp', isEqualTo: otp)
          .where('approve', isEqualTo: false)
          .limit(1)
          .get();

      if (query.docs.isEmpty) throw Exception('OTP not found');

      final validation = OtpValidationMapper.fromMap(query.docs.first.data()).copyWith(
        pieces: selectedPieces,
        renterID: currentEmployee?.id,
      );
      firebaseTrackingId = query.docs.first.id;
      notifyListeners();
      await _updateFirebaseValidation(validation);
      status = EquipmentStatus.loaded;
    } catch (e) {
      firebaseTrackingId = null;
      _handleError(e);
    }
  }

  // OTP Generation
  Future<void> generateOTP() async {
    try {
      firebaseTrackingId = null;
      notifyListeners();
      var query = await FirebaseFirestore.instance.collection('otpValidation').where('approve', isEqualTo: false).get();
      final existingCodes = query.docs.map((doc) => doc.data()['otp'] as String).toList();

      final code = _generateUniqueOTP(existingCodes);
      final validation = OtpValidation(
        approverID: currentEmployee!.id,
        renterID: null,
        otp: code,
        approve: false,
        pieces: const [],
      );
      var doc = await FirebaseFirestore.instance.collection('otpValidation').add(validation.toMap());
      firebaseTrackingId = doc.id;
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  // Approving Rental and Adding Log
  Future<void> approveRentalAndAddLog(OtpValidation validation) async {
    if (firebaseTrackingId == null) throw Exception('firebaseTrackingId is null');

    try {
      final approvedValidation = validation.copyWith(approve: true);
      await _updateFirebaseValidation(approvedValidation);

      // Update renter and lastRented information in pieces
      repository.updateEquipmentPieces(validation.pieces, validation.renterID, Timestamp.now());

      //TODO: implement notes for each log.
      await repository.addEquipmentLog(validation, 'implement this');
      notifyListeners();
    } catch (e) {
      _handleError(e);
    }
  }

  // Reset Selections
  void resetSelections() {
    selectedPieces.clear();
    selectedItems.clear();
    firebaseTrackingId = null;
    otp = null;
    notifyListeners();
  }

  // Remove Item and Assigned Pieces
  void removeItemAndPieces(EquipmentItem item) {
    selectedItems.remove(item);
    selectedPieces.removeWhere((piece) => piece.equipmentItemID == item.id);
    notifyListeners();
  }

  String _generateUniqueOTP(List<String> existingCodes) {
    final random = math.Random();
    String code;
    do {
      code = (random.nextInt(9000) + 1000).toString();
    } while (existingCodes.contains(code));
    return code;
  }

  Future<void> _updateFirebaseValidation(OtpValidation validation) async {
    await FirebaseFirestore.instance.collection('otpValidation').doc(firebaseTrackingId).set(validation.toMap());
  }

  void _handleError(Object error) {
    log('Error: $error');
    this.error = error.toString();
    status = EquipmentStatus.error;
  }

  Future<void> completeSubmission(EquipmentLog ulog) async {
    try {
      status = EquipmentStatus.loading;
      await repository.completeSubmission(ulog);
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> updateEquipmentItemAndPieces(
    EquipmentItem updatedItem,
    List<Tag> updatedTags,
    List<EquipmentPiece> oldPieces,
  ) async {
    try {
      status = EquipmentStatus.loading;
      await repository.updateEquipmentItem(updatedItem);
      var oldAssignedTags = oldPieces.map((piece) => piece.tag);
      for (final piece in oldPieces) {
        await repository.updateEquipmentPiece(
          piece.copyWith(
            equipmentItemName: updatedItem.name,
          ),
        );
      }

      for (final tag in updatedTags) {
        if (oldAssignedTags.contains(tag) == false) {
          EquipmentPiece piece = EquipmentPiece(
            id: '',
            tag: tag,
            equipmentItemID: updatedItem.id,
            equipmentItemName: updatedItem.name,
            currentRental: null,
            lastRented: null,
          );
          repository.addEquipmentPiece(piece);
        }
      }

      for (final piece in oldPieces) {
        if (updatedTags.contains(piece.tag) == false) {
          repository.deleteEquipmentPiece(piece.id);
        }
      }
      status = EquipmentStatus.loaded;
    } catch (e) {
      _handleError(e);
    }
  }

  Future<void> deleteEquipmentItem(EquipmentItem equipmentItem) async {
    status = EquipmentStatus.loading;
    selectedPieces.clear();
    selectedItems.clear();
    items.remove(equipmentItem);
    await repository.deleteEquipmentItem(equipmentItem);
    status = EquipmentStatus.loaded;
  }
}
