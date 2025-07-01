import 'package:flutter/material.dart';

class LikeHostelButton extends StatefulWidget {

  final Color? iconColor;

  const LikeHostelButton({super.key, this.iconColor});

  @override
  State<LikeHostelButton> createState() => _LikeHostelButtonState();
}

class _LikeHostelButtonState extends State<LikeHostelButton> {


  bool _hasLiked = false;


  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          //Todo: implement the favorites functionality
          setState(() {
            _hasLiked = !_hasLiked;
          });
        },

        icon: _hasLiked
          ? CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: .025),
              child: Icon(
                Icons.favorite,
                color: Colors.red
              )
          )
          : Icon(
            Icons.favorite_border_outlined,
            color: widget.iconColor ?? Colors.black54,
        )
    );
  }
}
