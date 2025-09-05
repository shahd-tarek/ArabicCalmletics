// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:calmleticsarab/constant.dart';

void showSuccessDialog(BuildContext context, String sessionDetails) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SizedBox(
          width: 600,
          height: 500,
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
                  "تهانينا!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: textcolor,
                  ),
                ),
                const SizedBox(height: 40),
                Image.asset(
                  "assets/images/Group 5.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 40),
                Text(
                  "لقد حجزت جلستك في الواقع الافتراضي:\n$sessionDetails",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    },
  );
}
