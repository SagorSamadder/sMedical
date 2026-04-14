import '../../../general/consts/consts.dart';
import '../../widgets/coustom_button.dart';
import '../../widgets/coustom_textfield.dart';
import '../controller/book_appointment_controller.dart';
import 'package:intl/intl.dart';

class BookAppointmentView extends StatefulWidget {
  final String docId;
  final String docNum;
  final String docName;
  const BookAppointmentView({
    super.key,
    required this.docId,
    required this.docName,
    required this.docNum,
  });

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final controller = Get.put(AppointmentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Book Appointment'),
      ),
      body: Form(
        key: controller.formkey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primeryColor, const Color(0xff281B64)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doctor',
                      style: TextStyle(color: Color(0xCCFFFFFF), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.docName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x1FFFFFFF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Contact: ${_maskedContact(widget.docNum)}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _sectionTitle('Select Appointment Date'),
              const SizedBox(height: 6),
              SizedBox(
                height: 98,
                child: Obx(() {
                  final selectedDate = controller.selectedDate.value;
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.dates.length,
                    itemBuilder: (context, index) {
                      final date = controller.dates[index];
                      final isSelected = date.isAtSameMomentAs(selectedDate);
                      return GestureDetector(
                        onTap: () {
                          controller.selectedDate.value = date;
                          controller.finalDate.value =
                              DateFormat('yyyy-MM-dd').format(date);
                          final filtered =
                              controller.getFilteredTimeIntervals();
                          controller.selectedTime.value =
                              filtered.isNotEmpty ? filtered.first : '';
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 84,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primeryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primeryColor
                                  : Colors.grey.shade300,
                            ),
                            boxShadow: isSelected
                                ? const [
                                    BoxShadow(
                                      color: Color(0x404B2EAD),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat('E').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                DateFormat('MMM').format(date),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 10),
              _sectionTitle('Select Appointment Time'),
              const SizedBox(height: 6),
              SizedBox(
                height: 68,
                child: Obx(() {
                  final filteredIntervals =
                      controller.getFilteredTimeIntervals();
                  if (filteredIntervals.isEmpty) {
                    return Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF0F0),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xffFFCCCC)),
                      ),
                      child: const Center(
                        child: Text(
                          'No time slots available',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredIntervals.length,
                    itemBuilder: (context, index) {
                      final interval = filteredIntervals[index];
                      final isSelected =
                          controller.selectedTime.value == interval;
                      return GestureDetector(
                        onTap: () {
                          controller.selectedTime.value = interval;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 8,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primeryColor
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primeryColor
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              interval,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 8),
              _sectionTitle('Mobile Number'),
              const SizedBox(height: 6),
              CoustomTextField(
                validator: controller.validdata,
                textcontroller: controller.appMobileController,
                hint: 'Enter patient mobile number',
                icon: const Icon(Icons.call),
              ),
              const SizedBox(height: 10),
              _sectionTitle('Your Problem'),
              const SizedBox(height: 6),
              TextFormField(
                controller: controller.appMessageController,
                maxLines: 4,
                decoration: InputDecoration(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 55),
                    child: Icon(Icons.note_alt_outlined),
                  ),
                  hintText: 'Write your problem in short',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: AppColors.primeryColor, width: 1.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          color: const Color(0xffF4F6FB),
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : CoustomButton(
                  onTap: () async {
                    await controller.bookAppointment(
                      widget.docId,
                      widget.docName,
                      widget.docNum,
                      context,
                    );
                  },
                  title: 'Confirm Appointment',
                ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primeryColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  String _maskedContact(String value) {
    final clean = value.trim();
    if (clean.length <= 6) {
      return clean;
    }
    return '${clean.substring(0, 6)}******';
  }
}
