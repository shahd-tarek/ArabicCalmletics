import 'package:flutter/material.dart';
import 'package:calmleticsarab/coach/screens/coach_home.dart';
import 'package:calmleticsarab/constant.dart';
import 'package:calmleticsarab/http/api.dart';

import 'package:calmleticsarab/widgets/custom_button.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  bool isLoading = false;

  Future<void> saveCard() async {
    setState(() {
      isLoading = true;
    });

    bool success = await Api().saveCard(
      nameController.text,
      numberController.text,
      dateController.text,
      cvvController.text,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Card saved successfully!")));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CoachHome()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to save card. Please try again.")),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgrouq chat.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 50),
              Center(child: Image.asset('assets/images/visa.png', width: 600)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Cardholder Name',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        TextField(
                          controller: numberController,
                          decoration: const InputDecoration(
                            labelText: 'Card number',
                            labelStyle: TextStyle(color: Colors.grey),
                            border: UnderlineInputBorder(),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kPrimaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: dateController,
                                decoration: const InputDecoration(
                                  labelText: 'Expire Date',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.datetime,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                controller: cvvController,
                                decoration: const InputDecoration(
                                  labelText: 'CVV',
                                  labelStyle: TextStyle(color: Colors.grey),
                                  border: UnderlineInputBorder(),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: kPrimaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 50),
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : CustomButton(text: "Pay", ontap: saveCard),
                        const SizedBox(height: 220),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/images/visaicon.png',
                                width: 110,
                              ),
                              Image.asset(
                                'assets/images/PayPal.png',
                                width: 110,
                              ),
                              Image.asset(
                                'assets/images/MasterCard.png',
                                width: 110,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
