import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s_medi/general/service/notification_service.dart';

class AppointmentDetailsController extends GetxController {
  var selectedStatus = ''.obs;
  final String documentId;
  var isDropdownDisabled = false.obs;
  final TextEditingController noteController = TextEditingController();

  AppointmentDetailsController(String initialStatus, this.documentId,
      {String initialNote = ''}) {
    selectedStatus.value = initialStatus;
    noteController.text = initialNote;

    if (initialStatus == 'complete' || initialStatus == 'reject') {
      isDropdownDisabled.value = true;
    }
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }

  void _showMessage(String title, String message) {
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      Get.log('$title: $message');
    }
  }

  Future<void> updateStatus(String newStatus) async {
    selectedStatus.value = newStatus;

    try {
      // Get the document reference
      DocumentReference appointmentDoc =
          FirebaseFirestore.instance.collection('appointments').doc(documentId);

      // Update the status
      await appointmentDoc.update({'status': newStatus});

      // Fetch the appBy field
      final appointmentSnapshot = await appointmentDoc.get();
      final appointmentData =
          appointmentSnapshot.data() as Map<String, dynamic>? ?? {};
      final appBy = (appointmentData['appBy'] ?? '').toString();

      if (appBy.isEmpty) {
        _showMessage('Success', 'Appointment status updated successfully!');
        return;
      }

      // Fetch the user's deviceToken from the users collection
      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(appBy).get();

      final userData = userSnapshot.data() ?? <String, dynamic>{};
      final deviceToken = (userData['deviceToken'] ?? '').toString();

      if (deviceToken.isNotEmpty) {
        switch (newStatus) {
          case 'accept':
            await _setAccept(deviceToken);
            break;
          case 'reject':
            await _setReject(deviceToken);
            break;
          case 'pending':
            await _setPending(deviceToken);
            break;
          case 'complete':
            await _setComplete(deviceToken);
            break;
        }
      }

      _showMessage('Success', 'Appointment status updated successfully!');
    } catch (e) {
      // Handle errors, e.g., failed to update
      _showMessage('Error', 'Failed to update status: $e');
    }
  }

  Future<void> saveNote() async {
    final note = noteController.text.trim();

    if (selectedStatus.value.toLowerCase() != 'complete') {
      _showMessage('Info', 'Add a note only when the appointment is complete.');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(documentId)
          .set({'note': note}, SetOptions(merge: true));
      _showMessage('Success', 'Note saved successfully!');
    } catch (e) {
      _showMessage('Error', 'Failed to save note: $e');
    }
  }

  Future<void> _setAccept(String deviceToken) async {
    if (kDebugMode) {
      print("set accept");
      print("Device Token: $deviceToken");
    }
    await sendNotification(deviceToken, "Appointment Accepted",
        "Your appointment has been successfully accepted. Please check your appointment details for further information.");
  }

  Future<void> _setReject(String deviceToken) async {
    if (kDebugMode) {
      print("set reject");
    }
    await sendNotification(deviceToken, "Appointment Rejected",
        "We're sorry, but your appointment request has been rejected. Please check for alternative time slots or contact us for assistance.");
    isDropdownDisabled.value = true;
  }

  Future<void> _setPending(String deviceToken) async {
    if (kDebugMode) {
      print("set pending");
    }
    await sendNotification(deviceToken, "Appointment Pending",
        "Your appointment request is currently pending. We will notify you once it has been reviewed and confirmed.");
  }

  Future<void> _setComplete(String deviceToken) async {
    if (kDebugMode) {
      print("set complete");
    }
    await sendNotification(deviceToken, "Appointment Completed",
        "Your appointment has been completed successfully. Thank you for visiting us! We hope to see you again soon.");
    isDropdownDisabled.value = true;
  }

  Future<void> sendNotification(
      String userToken, String title, String body) async {
    try {
      final service = NotificationService();
      final canSend = await service.canSendNotifications();
      if (!canSend) {
        if (kDebugMode) {
          print(
              'Notification skipped: service account file/key is unavailable');
        }
        return;
      }

      final accessToken = await service.getAccessToken();
      await service.sendNotification(accessToken, userToken, title, body);
      if (kDebugMode) {
        print("notification send");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending notifications (non-fatal): $e');
      }
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
