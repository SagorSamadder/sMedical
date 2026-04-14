import 'package:s_medi/general/consts/consts.dart';

class TermsCondition extends StatelessWidget {
  const TermsCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Terms & Conditions',
          style: TextStyle(
            color: AppColors.primeryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _section(
              title: '1. General Use',
              body:
                  'sMedical provides healthcare-related features for appointment booking, profile management and communication support. Use the app responsibly and for lawful purposes only.',
            ),
            _section(
              title: '2. Account Responsibility',
              body:
                  'You are responsible for keeping your account credentials secure. Any activity under your account is considered your responsibility.',
            ),
            _section(
              title: '3. Medical Disclaimer',
              body:
                  'This platform helps connect users and doctors. It does not replace emergency services, direct diagnosis, or clinical judgment from licensed professionals.',
            ),
            _section(
              title: '4. Appointments',
              body:
                  'Appointment slots depend on doctor availability and may change. Booking confirmation, completion, or cancellation status is managed through the app workflow.',
            ),
            _section(
              title: '5. Privacy & Data',
              body:
                  'Basic profile details, appointment details, and uploaded images are used to provide core app features. Do not upload sensitive information unless required.',
            ),
            _section(
              title: '6. User Content',
              body:
                  'You are responsible for the information you submit, including profile data, messages, and reviews. Abusive, illegal, or misleading content is prohibited.',
            ),
            _section(
              title: '7. Service Changes',
              body:
                  'Features, UI, and backend services may be updated, modified, or removed over time to improve reliability and user experience.',
            ),
            _section(
              title: '8. Contact',
              body:
                  'For support or policy-related questions, contact: sagorsamadder.official@gmail.com',
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({required String title, required String body}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.primeryColor,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
