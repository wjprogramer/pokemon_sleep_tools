import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

class NotFoundRoutePage extends StatelessWidget {
  const NotFoundRoutePage({
    super.key,
    this.settings,
  });

  static MyPageRoute<void> route = ('/NotFoundRoutePage', (_) {
    return const NotFoundRoutePage();
  });

  final RouteSettings? settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Center(
        child: Text('Not Found Page'),
      ),
    );
  }
}
