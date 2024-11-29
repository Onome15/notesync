import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    // Access colors from the current theme
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.secondary; // Background color
    final spinnerColor = theme.colorScheme.primary; // Spinner color

    return Container(
      color: backgroundColor,
      child: Center(
        child: SpinKitDoubleBounce(
          color: spinnerColor,
          size: 50.0,
        ),
      ),
    );
  }
}
