import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetailsController extends GetxController {
  var selectedStatus = ''.obs;
  final String documentId;
  var isDropdownDisabled = false.obs;

  AppointmentDetailsController(String initialStatus, this.documentId) {
    selectedStatus.value = initialStatus;

    if (initialStatus == 'complete') {
      isDropdownDisabled.value = true;
    }
  }

  void updateStatus(String newStatus) async {
    selectedStatus.value = newStatus;

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .update({'status': newStatus});

      switch (newStatus) {
        case 'accept':
          _setAccept();
          break;
        case 'reject':
          _setReject();
          break;
        case 'pending':
          _setPending();
          break;
        case 'complete':
          _setComplete();
          break;
      }

      Get.snackbar('Success', 'Appointment status updated successfully!');
    } catch (e) {
      // Handle errors, e.g., failed to update
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }

  void _setAccept() {
    print("set accept");
  }

  void _setReject() {
    print("set reject");
  }

  void _setPending() {
    print("set pending");
  }

  void _setComplete() {
    print("set complete");

    isDropdownDisabled.value = true;
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accept':
        return Colors.green;
      case 'reject':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      case 'complete':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
