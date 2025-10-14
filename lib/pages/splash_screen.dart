import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:stacked/stacked.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashController>.reactive(
      viewModelBuilder: () => SplashController(context),
      onViewModelReady: (viewModel) => viewModel.initialise(),
      builder: (context, viewModel, child) {
        return LayoutBuilder(
          builder: (ctx, constraints) {
            viewModel.init(ctx, constraints);
            return const Scaffold(
              body: Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: [
                    Colors.black,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}