import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class VxTextBuilder {
  final String _value;
  final TextStyle _style;

  const VxTextBuilder(this._value, [this._style = const TextStyle()]);

  VxTextBuilder size(double? value) {
    if (value == null) return this;
    return VxTextBuilder(_value, _style.copyWith(fontSize: value));
  }

  VxTextBuilder color(Color value) {
    return VxTextBuilder(_value, _style.copyWith(color: value));
  }

  VxTextBuilder get white => color(Colors.white);

  VxTextBuilder get semiBold {
    return VxTextBuilder(_value, _style.copyWith(fontWeight: FontWeight.w600));
  }

  VxTextBuilder get bold {
    return VxTextBuilder(_value, _style.copyWith(fontWeight: FontWeight.bold));
  }

  Text make() => Text(_value, style: _style);

  Widget makeCentered() => Center(child: make());
}

extension VxStringCompat on String {
  VxTextBuilder get text => VxTextBuilder(this);
}

extension VxSpacingCompat on num {
  SizedBox get heightBox => SizedBox(height: toDouble());

  SizedBox get widthBox => SizedBox(width: toDouble());
}

extension VxTapCompat on Widget {
  Widget onTap(VoidCallback action) {
    return GestureDetector(onTap: action, child: this);
  }
}

extension VxContextCompat on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;
}

class VxRating extends StatelessWidget {
  final ValueChanged<double>? onRatingUpdate;
  final double maxRating;
  final int count;
  final double value;
  final bool stepInt;

  const VxRating({
    super.key,
    this.onRatingUpdate,
    this.maxRating = 5,
    this.count = 5,
    this.value = 0,
    this.stepInt = false,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: value.clamp(0, maxRating),
      minRating: 0,
      maxRating: maxRating,
      allowHalfRating: !stepInt,
      itemCount: count,
      itemSize: 18,
      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
      itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
      onRatingUpdate: onRatingUpdate ?? (_) {},
      ignoreGestures: onRatingUpdate == null,
    );
  }
}

class VxToast {
  static void show(
    BuildContext context, {
    required String msg,
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          duration: duration,
        ),
      );
  }
}
