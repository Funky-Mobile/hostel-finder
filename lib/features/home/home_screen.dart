import 'package:flutter/material.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/features/home/widgets/custom_app_search_bar.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostels.dart';
import 'package:hostel_finder/features/home/widgets/salutation.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScaffoldBody(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Salutation(),

              VerticalItemSpacer(
                space: MediaQuery.of(context).size.height * .025,
                child: CustomAppSearchBar()
              ),

              PopularHostels()

            ],
          ),
        )
      ),
    );
  }
}
