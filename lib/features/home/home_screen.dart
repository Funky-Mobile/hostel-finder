
import 'package:flutter/material.dart';
import 'package:hostel_finder/core/custom_scaffold_body.dart';
import 'package:hostel_finder/shared/text_fields/custom_app_search_bar.dart';
import 'package:hostel_finder/features/home/widgets/popular_hostels.dart';
import 'package:hostel_finder/features/home/widgets/salutation.dart';
import 'package:hostel_finder/utils/vertical_item_spacer.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../shared/app_strings/custom_app_strings.dart';
import '../all_hostels/all_hostels.dart';

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

              StickyHeader(
                header: VerticalItemSpacer(
                    space: MediaQuery.of(context).size.height * .025,
                    child: CustomAppSearchBar(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => AllHostels(headerString: CustomAppStrings.recentSearchString))),
                    )
                ),

                content: PopularHostels()
              )
            ],
          ),
        )
      ),
    );
  }
}
