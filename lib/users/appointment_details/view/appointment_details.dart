import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/users/review/view/review_screen.dart';

class Appointmentdetails extends StatelessWidget {
  final DocumentSnapshot doc;
  const Appointmentdetails({super.key, required this.doc});

  String _readString(String key, [String fallback = '']) {
    try {
      final value = doc.data() as Map<String, dynamic>?;
      return (value?[key] ?? fallback).toString();
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _readString('status', 'unknown');
    final isCompleted = status.toLowerCase() == "complete";
    final reviewPending = _readString('review', 'false') == "false";
    final doctorNote = _readString('note', '').trim();

    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: "Appointment Details"
            .text
            .color(AppColors.primeryColor)
            .semiBold
            .make(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              width: context.screenWidth,
              padding: const EdgeInsets.all(15),
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
              child: Row(
                children: [
                  Container(
                    height: 76,
                    width: 76,
                    decoration: BoxDecoration(
                      color: AppColors.bgDarkColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppAssets.imgLogin,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "Doctor"
                            .text
                            .size(AppFontSize.size12)
                            .color(Colors.black54)
                            .make(),
                        Text(
                          doc['appDocName'].toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: AppFontSize.size18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        2.heightBox,
                        doc['appDocNum']
                            .toString()
                            .text
                            .size(AppFontSize.size12)
                            .color(Colors.black54)
                            .make(),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.primeryColor,
                    ),
                    child: const Icon(
                      Icons.phone,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            12.heightBox,
            Container(
              width: context.screenWidth,
              padding: const EdgeInsets.all(15),
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
                  _labelValue('Appointment Day', doc['appDay'].toString()),
                  10.heightBox,
                  _labelValue('Appointment Time', doc['appTime'].toString()),
                  10.heightBox,
                  _labelValue("Patient's Name", doc['appName'].toString()),
                  10.heightBox,
                  _labelValue("Patient's Phone", doc['appMobile'].toString()),
                  10.heightBox,
                  _labelValue('Problems', doc['appMsg'].toString()),
                  if (isCompleted && doctorNote.isNotEmpty) ...[
                    10.heightBox,
                    _labelValue('Doctor Note', doctorNote),
                  ],
                  18.heightBox,
                  Row(
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(status).withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: _statusColor(status),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  24.heightBox,
                  if (isCompleted)
                    Align(
                      alignment: Alignment.center,
                      child: reviewPending
                          ? InkWell(
                              onTap: () {
                                Get.to(
                                  () => ReviewPage(
                                    docId: doc['appWith'],
                                    documetId: doc.id,
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primeryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Give a Review",
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primeryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Thanks for Review",
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _labelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(color: Colors.black54),
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
