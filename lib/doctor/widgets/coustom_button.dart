import '../../general/consts/consts.dart';

class CoustomButton extends StatelessWidget {
  final Function()? onTap;
  final String title;
  const CoustomButton({super.key, required this.onTap, required this.title});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primeryColor,
        shape: const StadiumBorder(),
      ),
      onPressed: onTap,
      child: title.text.white.make(),
    );
  }
}
