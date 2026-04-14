import '../../../general/consts/consts.dart';
import '../../appointment_details/view/appointment_details.dart';
import '../controller/total_appointment.dart';

class TotalAppointment extends StatelessWidget {
  const TotalAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TotalAppointmentcontroller());
    // Future<void> addImageFieldToUsers() async {
    //   FirebaseFirestore firestore = FirebaseFirestore.instance;

    //   try {
    //     // Get all documents in the 'users' collection
    //     QuerySnapshot snapshot = await firestore.collection('users').get();

    //     // Iterate over each document and add the 'image' field
    //     for (var doc in snapshot.docs) {
    //       await doc.reference.update({
    //         'role': 'user',
    //       });
    //     }

    //     print('Image field added to all doctors!');
    //   } catch (e) {
    //     print('Error adding image field: $e');
    //   }
    // }

    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   addImageFieldToUsers();
      // }),
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        title: "All Appointments".text.make(),
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
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: ListView.builder(
                    itemCount: data?.length ?? 0,
                    itemBuilder: (BuildContext context, index) {
                      var appointment =
                          data![index].data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColors.primeryColor.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Doctor : ${appointment['appDocName']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.whiteColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Appointment Date : ${appointment['appDay']}",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Appointment time : ${appointment['appTime']}",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Status: ${appointment.containsKey('status') ? appointment['status'] : "No status"}",
                                      style: TextStyle(
                                          color: AppColors.whiteColor),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => Appointmentdetails(
                                        doc: data[index],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 30,
                                    width: 100,
                                    child: const Center(
                                      child: Text("Show Details"),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
