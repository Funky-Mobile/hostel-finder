import 'package:flutter/material.dart';

import '../../../utils/vertical_item_spacer.dart';
import '../../home/widgets/nearby_hostels.dart';
import '../../hostel_details/hostel_detail.dart';

class AllNearbyHostels extends StatefulWidget {

  final List<String> assets;

  const AllNearbyHostels({super.key, required this.assets});

  @override
  State<AllNearbyHostels> createState() => _AllNearbyHostelsState();
}

class _AllNearbyHostelsState extends State<AllNearbyHostels> {
  @override
  Widget build(BuildContext context) {
    return VerticalItemSpacer(
      space: MediaQuery.of(context).size.height * .025,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            ...widget.assets.map((asset) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (builder) => HostelDetail(
                    hostelPhotosUrls: widget.assets,
                  ))),

                  borderRadius: BorderRadius.circular(10),
                  child: NearbyHostels(
                      asset,
                      "Gracious Queens Hotel", //Todo: this comes from the api response
                      "Adenta Municipality", //Todo: this comes from the api response
                      3.4, //Todo: this comes from the api response
                      '${231}' //Todo: this comes from the api response
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
