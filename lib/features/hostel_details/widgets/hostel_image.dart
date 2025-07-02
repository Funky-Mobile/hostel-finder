import 'package:flutter/cupertino.dart';

class HostelImage extends StatelessWidget {

  final String imageUrl;

  const HostelImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10)
      ),
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: 298,
      ),
    );
  }
}
