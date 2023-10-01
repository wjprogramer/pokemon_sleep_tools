import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.titleText,
  });
  
  final String? titleText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: titleText,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
