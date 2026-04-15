import 'package:s_medi/doctor/total_appintment/controller/total_appointment.dart';
import 'package:s_medi/doctor/total_appintment/view/appointment_details.dart';
import 'package:s_medi/general/consts/consts.dart';

class TotalAppointment extends StatefulWidget {
  const TotalAppointment({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TotalAppointmentState createState() => _TotalAppointmentState();
}

class _TotalAppointmentState extends State<TotalAppointment> {
  final controller = Get.put(TotalAppointmentController());

  String _limitCharacters(String text, int maxChars) {
    if (text.length > maxChars) {
      return '${text.substring(0, maxChars)}...';
    }
    return text;
  }

  Future<void> refreshAppointments() async {
    await controller.getAppointments();
    setState(() {});
  }

  Future<String?> getUserImage(String userId) async {
    if (userId.isEmpty) return null;

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      var data = userDoc.data() as Map<String, dynamic>;
      return (data['image'] ?? '').toString();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: const Text("All Appointments"),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: controller.getAppointments(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching appointments"),
            );
          }

          final data = snapshot.data?.docs ??
              <QueryDocumentSnapshot<Map<String, dynamic>>>[];
          if (data.isEmpty) {
            return const Center(
              child: Text("No appointment booked"),
            );
          }

          return RefreshIndicator(
            onRefresh: refreshAppointments,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, index) {
                  final appointment = data[index].data();
                  final appointmentId = data[index].id;
                  final appName =
                      (appointment['appName'] ?? 'Unknown Name').toString();
                  final appMobile =
                      (appointment['appMobile'] ?? 'Unknown Mobile').toString();
                  final appMsg =
                      (appointment['appMsg'] ?? 'No Message').toString();
                  final appDay =
                      (appointment['appDay'] ?? 'Unknown Day').toString();
                  final appTime =
                      (appointment['appTime'] ?? 'Unknown Time').toString();
                  final status =
                      (appointment['status'] ?? 'pending').toString();
                  final appBy = (appointment['appBy'] ?? '').toString();

                  return FutureBuilder<String?>(
                    future: getUserImage(appBy),
                    builder: (context, imageSnapshot) {
                      Widget avatarWidget;
                      if (imageSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        avatarWidget = const CircularProgressIndicator();
                      } else if (imageSnapshot.hasError ||
                          !imageSnapshot.hasData ||
                          imageSnapshot.data == null ||
                          imageSnapshot.data!.isEmpty) {
                        avatarWidget = const CircleAvatar(
                          radius: 25,
                          backgroundImage:
                              AssetImage('assets/images/doctor.png'),
                        );
                      } else {
                        avatarWidget = CircleAvatar(
                          radius: 25,
                          child: ClipOval(
                            child: Image.network(
                              imageSnapshot.data!.trim(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Image.asset(
                                  'assets/images/doctor.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/doctor.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      }

                      return Card(
                        elevation: 1,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(13),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  avatarWidget,
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: _limitCharacters(
                                                    "Patient: $appName", 20),
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const WidgetSpan(
                                                child: SizedBox(width: 8),
                                              ),
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.verified,
                                                  color: Colors.blue,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(_limitCharacters(
                                            "Mobile: $appMobile", 20)),
                                        Text(_limitCharacters(
                                            "Message: $appMsg", 20)),
                                        const SizedBox(height: 5),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(Icons.schedule,
                                                    size: 16,
                                                    color: Colors.grey),
                                              ),
                                              const WidgetSpan(
                                                child: SizedBox(width: 4),
                                              ),
                                              TextSpan(
                                                text: _limitCharacters(
                                                    "$appDay - $appTime", 20),
                                                style: TextStyle(
                                                    color: Colors.grey[600]),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(status),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          status.capitalizeFirst!,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        onPressed: () async {
                                          var result = await Get.to(
                                            () => AppointmentDetails(
                                              appointment: appointment,
                                              appointmentId: appointmentId,
                                            ),
                                          );

                                          if (result == 'updated') {
                                            refreshAppointments();
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          "View Details",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Method to get the color based on status
  Color _getStatusColor(String status) {
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
