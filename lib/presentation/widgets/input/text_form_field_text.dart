import 'package:flutter/material.dart';

import '../../../data/common/constant/color.dart';

class TextFormFieldText extends StatelessWidget {
  const TextFormFieldText({
    Key? key,
    required this.title,
    required this.hint,
    required this.textController,
    required this.mandatory,
    required this.enabled,
    this.onChanged,
  }) : super(key: key);

  final String title;
  final String hint;
  final TextEditingController textController;
  final bool mandatory;
  final bool enabled;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      mandatory
          ? RichText(
              text: TextSpan(children: [
              TextSpan(
                  text: title,
                  style: const TextStyle(
                      color: FTColor.grey,
                      fontFamily: "Sen",
                      fontWeight: FontWeight.bold)),
              const TextSpan(text: " *", style: TextStyle(color: Colors.red))
            ]))
          : Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
      const SizedBox(
        height: 30,
      ),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: enabled ? true : false,
              controller: textController,
              keyboardType: TextInputType.text,
              cursorColor: FTColor.red,
              autofocus: false,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                fillColor: enabled ? Colors.white : FTColor.grey,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: FTColor.grey),
                    borderRadius: BorderRadius.circular(10)),
                disabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: FTColor.grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: FTColor.red),
                ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }
}
