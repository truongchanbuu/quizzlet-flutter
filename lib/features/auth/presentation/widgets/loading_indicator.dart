import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingIndicator extends StatelessWidget {
  final Color color;
  final double? size;
  const LoadingIndicator({super.key, this.color = Colors.indigo, this.size});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var flexibleSize = MediaQuery.of(context).size.width / 5;

        if (constraints.maxWidth > 900) {
          flexibleSize = MediaQuery.of(context).size.width / 10;
        }

        return Center(
          child: LoadingAnimationWidget.inkDrop(
              color: color, size: size ?? flexibleSize),
        );
      },
    );
  }
}
