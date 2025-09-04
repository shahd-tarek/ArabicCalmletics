import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calmleticsarab/community/coachCommunity/coach_community.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

void showCommunityDialog(BuildContext context) {
  List<TextEditingController> textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  final Api api = Api();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      final size = MediaQuery.of(context).size;
      final double padding = size.width * 0.04;
      final double fontSizeSmall = size.width * 0.038;
      final double fontSizeMedium = size.width * 0.042;
      final double fontSizeLarge = size.width * 0.05;
      final double dialogWidth = size.width * 0.9;
      final double dialogHeight = size.height * 0.6;
      final double boxWidth = size.width * 0.14; // 14% من العرض لكل مربع
      final double closeButtonSize = size.width * 0.1;

      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
          padding: EdgeInsets.all(padding),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: closeButtonSize,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                SizedBox(height: padding * 2),
                Text(
                  "لنربطك بالمجتمع!",
                  style: TextStyle(
                    fontSize: fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding * 0.5),
                Text(
                  "للانضمام إلى المحادثة والتواصل مع لاعبين ومدربين مميزين،أدخل رمز الدعوة الخاص بك في الأسفل. هيا نبدأ!",
                  style: TextStyle(
                    fontSize: fontSizeMedium,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding * 1.2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    4,
                    (index) => _buildOTPBox(
                      index,
                      textControllers,
                      focusNodes,
                      context,
                      boxWidth,
                      fontSizeLarge,
                    ),
                  ),
                ),
                SizedBox(height: padding * 2),
                Text(
                  "لا تملك رمز دعوة؟ لا بأس! تواصل معنا أو مع مدربك للحصول على الرمز وبدء رحلتك.",
                  style: TextStyle(
                    fontSize: fontSizeSmall,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: padding * 3),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: "انضم الآن",
                    ontap: () async {
                      String code =
                          textControllers.map((c) => c.text.trim()).join();

                      if (code.length < 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter the full 4-digit code"),
                          ),
                        );
                        return;
                      }

                      bool success = await api.joinPreCommunity(code);

                      if (success) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const coachCommunity(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Invalid code or failed to join community",
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildOTPBox(
  int index,
  List<TextEditingController> textControllers,
  List<FocusNode> focusNodes,
  BuildContext context,
  double boxWidth,
  double fontSize,
) {
  return SizedBox(
    width: boxWidth,
    child: TextField(
      controller: textControllers[index],
      focusNode: focusNodes[index],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      maxLength: 1,
      decoration: const InputDecoration(
        counterText: "",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 2),
        ),
      ),
      onChanged: (value) {
        if (value.isNotEmpty) {
          if (index < 3) {
            FocusScope.of(context).requestFocus(focusNodes[index + 1]);
          } else {
            focusNodes[index].unfocus();
          }
        } else if (value.isEmpty && index > 0) {
          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
        }
      },
    ),
  );
}
