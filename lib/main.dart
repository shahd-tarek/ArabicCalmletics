import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:calmleticsarab/views/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calmletics',

      // دعم العربي
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // عربي
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // اتجاه الكتابة (من اليمين لليسار)
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },

      home: const MainScreen(),
    );
  }
}
