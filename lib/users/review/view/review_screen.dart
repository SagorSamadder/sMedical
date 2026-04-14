import 'package:s_medi/general/consts/consts.dart';

import '../controller/review_controller.dart';

class ReviewPage extends StatelessWidget {
  final String docId;
  final String documetId;
  const ReviewPage({super.key, required this.docId, required this.documetId});

  @override
  Widget build(BuildContext context) {
    final ReviewController reviewController =
        Get.put(ReviewController(docId, documetId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Give a Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Behavior Selection
              const Text(
                'How was the behavior?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(
                () => RadioGroup<String>(
                  groupValue: reviewController.selectedBehavior.value,
                  onChanged: (value) {
                    if (value != null) {
                      reviewController.updateBehavior(value);
                    }
                  },
                  child: const Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('Good'),
                        leading: Radio<String>(value: 'Good'),
                      ),
                      ListTile(
                        title: Text('Average'),
                        leading: Radio<String>(value: 'Average'),
                      ),
                      ListTile(
                        title: Text('Bad'),
                        leading: Radio<String>(value: 'Bad'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Comment Section
              const Text(
                'Additional Comments (Optional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: reviewController.commentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Enter your comments here...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              // Rating Section with Stars
              const Text(
                'Give a Rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(
                    5, (index) => reviewController.buildStar(index + 1)),
              ),
              const SizedBox(height: 20),
              // Submit Button
              Center(
                child: SizedBox(
                  width: context.screenWidth * .5,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primeryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () {
                      reviewController.submitReview();
                    },
                    child: Obx(
                      () => reviewController.loading.value
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              'Submit Review',
                              style: TextStyle(color: AppColors.whiteColor),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
