import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class TransparentButton extends StatelessWidget {
  final String value;
  final VoidCallback? onPressed;
  final IconData icon;
  final bool hideDivider;

  const TransparentButton({
    Key? key,
    required this.value,
    required this.icon,
    this.onPressed,
    this.hideDivider = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed ?? () {},
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: CustomColor.DARK_GREY,
                  size: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: CustomColor.DARK_GREY)
              ],
            ),
          ),
        ),
        if(!hideDivider)
        const Divider()
      ],
    );
  }
}
