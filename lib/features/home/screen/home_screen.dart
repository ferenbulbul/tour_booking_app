import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/home/widgets/about_section.dart';
import 'package:tour_booking/features/home/widgets/categories_section.dart';
import 'package:tour_booking/features/home/widgets/featured_section.dart';
import 'package:tour_booking/features/home/widgets/search_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'home'.tr()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SearchSection(),
              SizedBox(height: 24),
              FeaturedSection(),
              SizedBox(height: 24),
              CategoriesSection(),
              SizedBox(height: 24),
              AboutSection(),
            ],
          ),
        ),
      ),
    );
  }
}
