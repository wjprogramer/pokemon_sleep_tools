import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    this.titleText,
    this.isView = false,
  });
  
  final String? titleText;
  final bool isView;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isView ? null : buildAppBar(
        titleText: titleText,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
