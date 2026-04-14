import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  var controller = Get.put(TotalAppointmentController());

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
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc.data() != null) {
      var data = userDoc.data() as Map<String, dynamic>;
      return data['image'];
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
      body: FutureBuilder<QuerySnapshot>(
        future: controller.getAppointments(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error fetching appointments"),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No appointment booked"),
            );
          } else {
            var data = snapshot.data!.docs;

            return RefreshIndicator(
              onRefresh: refreshAppointments,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, index) {
                    var appointment =
                        data[index].data() as Map<String, dynamic>;
                    String appointmentId = data[index].id;
                    String appName = appointment['appName'] ?? 'Unknown Name';
                    String appMobile =
                        appointment['appMobile'] ?? 'Unknown Mobile';
                    String appMsg = appointment['appMsg'] ?? 'No Message';
                    String appDay = appointment['appDay'] ?? 'Unknown Day';
                    String appTime = appointment['appTime'] ?? 'Unknown Time';
                    String status = appointment['status'] ?? 'pending';
                    String appBy = appointment['appBy'];

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
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(13.w),
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
                                                  style: TextStyle(
                                                    fontSize: 13.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                WidgetSpan(
                                                  child: SizedBox(width: 8.w),
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
                                          )
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 6.h),
                                          decoration: BoxDecoration(
                                            color: _getStatusColor(status),
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          child: Text(
                                            status.capitalizeFirst!,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),
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
                                                  BorderRadius.circular(8.r),
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
          }
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
