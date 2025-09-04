import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/helper/token_helper.dart';
import 'package:calmleticsarab/http/api.dart';
import 'package:calmleticsarab/plan/plan_page.dart';

void showRecommendationDialog(BuildContext context) {
  bool isLoading = false;
  bool isPlanReady = false;
  int? recommendedPlanId;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            // ✅ جلب أبعاد الشاشة هنا داخل الـ dialog
            final double screenWidth = MediaQuery.of(context).size.width;
            final double screenHeight = MediaQuery.of(context).size.height;

            // تحديد أقصى حجم للـ Dialog مع نسبة من الشاشة
            final double dialogWidth = screenWidth * 0.9; // 90% من العرض
            final double dialogHeight = screenHeight * 0.6; // 60% من الارتفاع

            // أحجام نسبية
            final double closeButtonSize = screenWidth * 0.08;
            final double imageHeight = screenHeight * 0.15;
            final double titleFontSize = screenWidth * 0.05;
            final double subtitleFontSize = screenWidth * 0.04;
            final double buttonHorizontalPadding = screenWidth * 0.03;
            final double buttonVerticalPadding = screenHeight * 0.01;
            final double buttonFontSize = screenWidth * 0.045;

            return Container(
              width: dialogWidth,
              height: dialogHeight,
              padding: EdgeInsets.all(screenWidth * 0.05), // نسبي
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(
                          closeButtonSize / 2,
                        ),
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
                  SizedBox(
                    height: imageHeight,
                    child: Image.asset('assets/images/Loading 1.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "جارٍ إعداد خطتك المخصصة",
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'اضغط على «خطتك المقترَحة» وشوف خطتك الخاصة',
                    style: TextStyle(
                      fontSize: subtitleFontSize,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLoading ? Colors.grey : kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              setState(() {
                                isLoading = true;
                              });

                              final prefs =
                                  await SharedPreferences.getInstance();

                              if (!isPlanReady) {
                                // First click: call API and get plan
                                recommendedPlanId =
                                    await Api()
                                        .forwardRecommendationAnswersToLocalAPI();

                                if (recommendedPlanId != null) {
                                  await prefs.setInt(
                                    "recommended_plan_id",
                                    recommendedPlanId!,
                                  );
                                  setState(() {
                                    isPlanReady = true;
                                    isLoading = false;
                                  });
                                } else {
                                  setState(() {
                                    isLoading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '❌ Failed to get recommendation.',
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                // Second click: submit to external API and go to plan page
                                String? token = await TokenHelper.getToken();

                                final response = await http.post(
                                  Uri.parse(
                                    'https://calmletics-production.up.railway.app/api/player/recommended ',
                                  ),
                                  headers: {
                                    'Authorization': 'Bearer $token',
                                    'Content-Type': 'application/json',
                                  },
                                  body:
                                      '{"recommended_plan_id": $recommendedPlanId}',
                                );

                                if (response.statusCode == 200) {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PlanPage(),
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '❌ Failed to submit plan: ${response.statusCode}',
                                      ),
                                    ),
                                  );
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: buttonHorizontalPadding,
                        vertical: buttonVerticalPadding,
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                isPlanReady ? 'اظهر الخطة' : 'خطتك المقترَحة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: buttonFontSize,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
