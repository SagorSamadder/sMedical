import '../../../general/consts/consts.dart';
import '../../appointment_details/view/appointment_details.dart';
import '../controller/total_appointment.dart';

class TotalAppointment extends StatelessWidget {
  const TotalAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TotalAppointmentcontroller());

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "All Appointments"
            .text
            .color(AppColors.primeryColor)
            .semiBold
            .make(),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.refreshAppointments();
          },
          child: FutureBuilder<QuerySnapshot>(
            future: controller.getAppointments(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var data = snapshot.data?.docs;
                if (data == null || data.isEmpty) {
                  return Center(
                    child: "No appointments found"
                        .text
                        .color(Colors.black54)
                        .size(AppFontSize.size16)
                        .make(),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, index) {
                    final appointment =
                        data[index].data() as Map<String, dynamic>;
                    final status = appointment.containsKey('status')
                        ? appointment['status'].toString()
                        : 'No status';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  color: AppColors.primeryColor
                                      .withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.local_hospital_outlined,
                                  color: AppColors.primeryColor,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  appointment['appDocName'].toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: _statusColor(status)
                                      .withValues(alpha: .13),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  status,
                                  style: TextStyle(
                                    color: _statusColor(status),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _rowInfo(
                            icon: Icons.calendar_today_outlined,
                            label: "Date",
                            value: appointment['appDay'].toString(),
                          ),
                          const SizedBox(height: 6),
                          _rowInfo(
                            icon: Icons.access_time,
                            label: "Time",
                            value: appointment['appTime'].toString(),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Get.to(
                                    () => Appointmentdetails(doc: data[index]));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 9,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primeryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Show Details",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.whiteColor,
                                      size: 14,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        );
      }),
    );
  }

  Widget _rowInfo({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Color _statusColor(String status) {
    final lower = status.toLowerCase();
    if (lower == 'complete') return const Color(0xff219653);
    if (lower == 'pending') return const Color(0xffE2A300);
    if (lower == 'cancelled') return const Color(0xffD62828);
    return const Color(0xff4B2EAD);
  }
}
