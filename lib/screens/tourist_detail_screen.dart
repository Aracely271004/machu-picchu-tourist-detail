import 'package:flutter/material.dart';

import '../widgets/destination_header.dart';
import '../widgets/practical_info_section.dart';
import '../widgets/about_section.dart';
import '../widgets/how_to_get_there_section.dart';
import '../widgets/circuits_section.dart';
import '../widgets/itinerary_section.dart';
import '../widgets/included_section.dart';

class TouristDetailScreen extends StatelessWidget {
  const TouristDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DestinationHeader(),
            PracticalInfoSection(),
            AboutSection(),
            HowToGetThereSection(),
            CircuitsSection(),
            ItinerarySection(),
            IncludedSection(),
          ],
        ),
      ),
    );
  }
}