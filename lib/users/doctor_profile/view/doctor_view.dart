import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/users/all%20reviews/all_reviews.dart';
import 'package:s_medi/users/doctor_profile/widgets/review_card.dart';

import '../../book_appointment/view/appointment_view.dart';

class DoctorProfile extends StatelessWidget {
  final DocumentSnapshot doc;
  const DoctorProfile({super.key, required this.doc});

  @override
  Widget build(BuildContext context) {
    final docData = doc.data() as Map<String, dynamic>?;
    final imageUrl = (docData?['image'] ?? '').toString();
    final normalizedImageUrl = imageUrl.trim();
    final docName = (docData?['docName'] ?? 'Unknown').toString();
    final docCategory = (docData?['docCategory'] ?? 'Unknown').toString();
    final docRating =
        double.tryParse((docData?['docRating'] ?? '0').toString()) ?? 0;
    final docId = (docData?['docId'] ?? '').toString();
    final docPhone = (docData?['docPhone'] ?? '').toString();
    final docAbout = (docData?['docAbout'] ?? 'No information').toString();
    final docAddress = (docData?['docAddress'] ?? 'No address').toString();
    final docTimeing = (docData?['docTimeing'] ?? 'Not available').toString();
    final docService = (docData?['docService'] ?? 'Not available').toString();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.whiteColor,
        title: "Doctor details".text.semiBold.size(AppFontSize.size18).make(),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 340,
                      width: double.infinity,
                      child: normalizedImageUrl.isEmpty
                          ? Image.asset(
                              'assets/images/doctor.png',
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              normalizedImageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return Image.asset(
                                  'assets/images/doctor.png',
                                  fit: BoxFit.cover,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/doctor.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Positioned(
                      left: 16,
                      top: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.22),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Text(
                          docCategory,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0),
                              Colors.black26,
                              Colors.black45,
                              Colors.black54,
                              Colors.black87,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      docName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Icon(
                                      Icons.verified,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: docRating,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 18,
                                    direction: Axis.horizontal,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    docRating.toStringAsFixed(1),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoBlock(
                    icon: Icons.person_outline,
                    title: "About",
                    value: docAbout,
                  ),
                  14.heightBox,
                  _buildInfoBlock(
                    icon: Icons.location_on_outlined,
                    title: "Address",
                    value: docAddress,
                  ),
                  14.heightBox,
                  _buildInfoBlock(
                    icon: Icons.schedule,
                    title: "Working Time",
                    value: docTimeing,
                  ),
                  14.heightBox,
                  _buildInfoBlock(
                    icon: Icons.medical_services_outlined,
                    title: "Services",
                    value: docService,
                  ),
                  18.heightBox,
                  InkWell(
                    onTap: () {
                      Get.to(
                        () => BookAppointmentView(
                          docId: docId,
                          docName: docName,
                          docNum: docPhone,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.primeryColor,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          "Book an Appointment",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  12.heightBox,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: "Contact Details"
                        .text
                        .semiBold
                        .size(AppFontSize.size16)
                        .make(),
                    subtitle: "First book an Appointment for contact details"
                        .text
                        .size(AppFontSize.size12)
                        .make(),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: _buildReviewSection(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBlock({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.bgDarkColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: AppColors.primeryColor,
          ),
        ),
        10.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .doc(doc.id)
          .collection('reviews')
          .orderBy('rating', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return "No reviews available".text.makeCentered();
        }

        var reviews = snapshot.data!.docs;

        final hasMoreThanThree = reviews.length > 3;
        final reviewCount = hasMoreThanThree ? 3 : reviews.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                "Patient Reviews".text.semiBold.size(AppFontSize.size16).make(),
                const Spacer(),
                if (hasMoreThanThree)
                  TextButton(
                    onPressed: () {
                      Get.to(
                        () => AllReviewsPage(
                          doctorId: doc.id,
                        ),
                      );
                    },
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: AppColors.primeryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: reviewCount,
                itemBuilder: (context, index) {
                  var review = reviews[index];
                  return buildReviewCard(review);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
