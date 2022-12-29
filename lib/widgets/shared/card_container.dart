import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final bool disabled;
  final Color? color;

  CardContainer({required this.child, this.disabled = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: disabled ? Colors.white.withOpacity(.3) : color ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: CustomColor.LIGHT_GREY),
        boxShadow: const [
          BoxShadow(
              color: Color(0xffffeeeeee), blurRadius: 9.0, offset: Offset(0, 4))
        ],
      ),
      child: child,
    );
  }
}
