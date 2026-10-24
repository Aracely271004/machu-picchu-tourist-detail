import 'package:flutter/material.dart';

import 'data/database_helper.dart';
import 'screens/tourist_detail_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseHelper.bd;

  runApp(const MachuPicchuApp());
}

class MachuPicchuApp extends StatelessWidget {
  const MachuPicchuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TouristDetailScreen(),
    );
  }
}
