import 'package:flutter/material.dart';

import '../../../data/common/constant/color.dart';
import '../../../data/common/constant/styles.dart';

class PickerButton extends StatelessWidget {
  const PickerButton({
    Key? key,
    required this.title,
    required this.value,
    required this.icon, required this.function,
  }) : super(key: key);

  final String title;
  final String value;
  final Widget icon;
  final Function() function;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Text(
          title,
          style: TextStyles.text12Bold,
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: function,
                child: Container(
                  decoration: FTStyle.coloredBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(Insets.lg),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value,
                          style:
                              TextStyles.text14.copyWith(color: FTColor.grey),
                        ),
                        icon,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
