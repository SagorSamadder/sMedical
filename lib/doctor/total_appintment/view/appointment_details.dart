import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../general/consts/consts.dart';
import '../controller/appointment_details_controller.dart';

class AppointmentDetails extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final String appointmentId;

  const AppointmentDetails(
      {Key? key, required this.appointment, required this.appointmentId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentDetailsController(
      appointment['status'] ?? 'pending',
      appointmentId,
    ));

    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'updated');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Text(
            "Appointment Details",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        icon: Icons.account_circle,
                        label: "Patient name",
                        value: appointment['appName'] ?? 'Unknown',
                      ),
                      _buildDetailRow(
                        icon: Icons.phone,
                        label: "Patient Contact",
                        value: appointment['appMobile'] ?? 'Unknown',
                      ),
                      _buildDetailRow(
                        icon: Icons.message,
                        label: "Message",
                        value: appointment['appMsg'] ?? 'No message',
                      ),
                      _buildDetailRow(
                        icon: Icons.calendar_today,
                        label: "Day",
                        value: appointment['appDay'] ?? 'Unknown day',
                      ),
                      _buildDetailRow(
                        icon: Icons.access_time,
                        label: "Time",
                        value: appointment['appTime'] ?? 'Unknown time',
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Icon(Icons.info,
                              color: AppColors.greenColor, size: 24.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Obx(() => DropdownButton<String>(
                                            value:
                                                controller.selectedStatus.value,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 24.w,
                                            elevation: 16,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                color: Colors.black),
                                            onChanged: controller
                                                    .isDropdownDisabled.value
                                                ? null // Disable dropdown if 'complete' is selected
                                                : (String? newValue) {
                                                    if (newValue != null) {
                                                      controller.updateStatus(
                                                          newValue);
                                                    }
                                                  },
                                            items: <String>[
                                              'accept',
                                              'reject',
                                              'pending',
                                              'complete'
                                            ].map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          )),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      flex: 1,
                                      child: Obx(() => Container(
                                            height: 25.h,
                                            decoration: BoxDecoration(
                                              color: controller.getStatusColor(
                                                  controller
                                                      .selectedStatus.value),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Center(
                                              child: Text(
                                                controller.selectedStatus.value
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
                SizedBox(height: 70.h),
                Center(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 100.w, vertical: 12.h),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text(
                      "Contact with patient",
                      style: TextStyle(fontSize: 13.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenColor, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
