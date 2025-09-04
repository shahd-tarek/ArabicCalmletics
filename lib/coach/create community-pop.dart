import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/widgets/custom_button.dart';

void createCommunityPopDialog(BuildContext context) {
  List<TextEditingController> textControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxHeight = MediaQuery.of(context).size.height * 0.7;
            double maxWidth = MediaQuery.of(context).size.width * 0.85;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  maxHeight: maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 32,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Successfully",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: textcolor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Image.asset(
                        "assets/images/Group 5.png",
                        width: maxWidth * 0.4,
                        height: maxWidth * 0.4,
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          4,
                          (index) => _buildOTPBox(
                            index,
                            textControllers,
                            focusNodes,
                            context,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Your code",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 97, 93, 93),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(text: "Next", ontap: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
) {
  return SizedBox(
    width: 50,
    child: TextField(
      controller: textControllers[index],
      focusNode: focusNodes[index],
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(
        fontSize: 24,
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
