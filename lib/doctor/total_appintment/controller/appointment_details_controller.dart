import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_medi/general/service/notification_service.dart';

class AppointmentDetailsController extends GetxController {
  var selectedStatus = ''.obs;
  final String documentId;
  var isDropdownDisabled = false.obs;

  AppointmentDetailsController(String initialStatus, this.documentId) {
    selectedStatus.value = initialStatus;

    if (initialStatus == 'complete' || initialStatus == 'reject') {
      isDropdownDisabled.value = true;
    }
  }

  void updateStatus(String newStatus) async {
    selectedStatus.value = newStatus;

    try {
      // Get the document reference
      DocumentReference appointmentDoc =
          FirebaseFirestore.instance.collection('appointments').doc(documentId);

      // Update the status
      await appointmentDoc.update({'status': newStatus});

      // Fetch the appBy field
      DocumentSnapshot appointmentSnapshot = await appointmentDoc.get();
      String appBy = appointmentSnapshot['appBy'];

      // Fetch the user's deviceToken from the users collection
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(appBy).get();

      String deviceToken = userSnapshot['deviceToken'];

      switch (newStatus) {
        case 'accept':
          _setAccept(deviceToken);
          break;
        case 'reject':
          _setReject(deviceToken);
          break;
        case 'pending':
          _setPending(deviceToken);
          break;
        case 'complete':
          _setComplete(deviceToken);
          break;
      }

      Get.snackbar('Success', 'Appointment status updated successfully!');
    } catch (e) {
      // Handle errors, e.g., failed to update
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }

  void _setAccept(String deviceToken) {
    if (kDebugMode) {
      print("set accept");
      print("Device Token: $deviceToken");
      sendNotification(deviceToken, "Appoinment Acceped",
          "Your appointment has been successfully accepted. Please check your appointment details for further information.");
    }
  }

  void _setReject(String deviceToken) {
    if (kDebugMode) {
      print("set reject");
    }
    sendNotification(deviceToken, "ppointment Rejected",
        "We're sorry, but your appointment request has been rejected. Please check for alternative time slots or contact us for assistance.");
    isDropdownDisabled.value = true;
  }

  void _setPending(String deviceToken) {
    if (kDebugMode) {
      print("set pending");
    }
    sendNotification(deviceToken, "Appointment Pending",
        "Your appointment request is currently pending. We will notify you once it has been reviewed and confirmed.");
  }

  void _setComplete(String deviceToken) {
    if (kDebugMode) {
      print("set complete");
    }
    sendNotification(deviceToken, "Appointment Completed",
        "Your appointment has been completed successfully. Thank you for visiting us! We hope to see you again soon.");
    isDropdownDisabled.value = true;
  }

  Future<void> sendNotification(
      String userToken, String title, String body) async {
    try {
      final accessToken = await NotificationService().getAccessToken();
      await NotificationService()
          .sendNotification(accessToken, userToken, title, body);
      print("notification send");
    } catch (e) {
      print('Error sending notifications: $e');
      //_showDialog('Error', 'Error sending notification.');
    }
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
