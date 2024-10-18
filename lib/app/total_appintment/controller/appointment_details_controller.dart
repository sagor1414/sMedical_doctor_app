import 'package:get/get.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetailsController extends GetxController {
  var selectedStatus = ''.obs;
  final String documentId; // To identify the specific appointment document
  var isDropdownDisabled = false.obs; // To track if the dropdown should be disabled

  // Constructor to initialize the controller and document ID
  AppointmentDetailsController(String initialStatus, this.documentId) {
    selectedStatus.value = initialStatus;

    // Disable dropdown if the initial status is 'complete'
    if (initialStatus == 'complete') {
      isDropdownDisabled.value = true;
    }
  }

  // Method to update the status dynamically
  void updateStatus(String newStatus) async {
    selectedStatus.value = newStatus;

    try {
      // Update the status in Firestore
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .update({'status': newStatus});

      // Call the function based on the new status
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

      // Show success message or feedback
      Get.snackbar('Success', 'Appointment status updated successfully!');
    } catch (e) {
      // Handle errors, e.g., failed to update
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }

  // Functions for handling specific status updates
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

    // Disable the dropdown when 'complete' is selected
    isDropdownDisabled.value = true;
  }

  // Method to get the color based on the status
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
