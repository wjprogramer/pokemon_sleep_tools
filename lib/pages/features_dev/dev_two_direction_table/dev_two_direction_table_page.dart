import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

const int maxNumber = 20;

/// https://medium.com/nerd-for-tech/flutter-creating-a-two-direction-scrolling-table-with-fixed-head-and-column-4a34fc01378f
class DevTwoDirectionTablePage extends StatefulWidget {
  const DevTwoDirectionTablePage._();

  static const MyPageRoute route = ('/DevTwoDirectionTablePage', _builder);
  static Widget _builder(dynamic args) {
    return const DevTwoDirectionTablePage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DevTwoDirectionTablePage> createState() => _DevTwoDirectionTablePageState();
}

class _DevTwoDirectionTablePageState extends State<DevTwoDirectionTablePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: ''.xTr,
      ),
      body: SafeArea(
        child: _MultiplicationTable(),
      ),
    );
  }
}

class _TableBody extends StatefulWidget {
  const _TableBody({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<_TableBody> createState() => _TableBodyState();
}

class _TableBodyState extends State<_TableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      notificationPredicate: (ScrollNotification notification) {
        return notification.depth == 0 || notification.depth == 1;
      },
      onRefresh: () async {
        await Future.delayed(
          const Duration(seconds: 2),
        );
      },
      child: Row(
        children: [
          SizedBox(
            width: cellWidth,
            child: ListView(
              controller: _firstColumnController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              children: List.generate(maxNumber - 1, (index) {
                return _MultiplicationTableCell(
                  color: Colors.yellow.withOpacity(0.3),
                  value: index + 2,
                );
              }),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                width: (maxNumber - 1) * cellWidth,
                child: ListView(
                  controller: _restColumnsController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  children: List.generate(maxNumber - 1, (y) {
                    return Row(
                      children: List.generate(maxNumber - 1, (x) {
                        return _MultiplicationTableCell(
                          value: (x + 2) * (y + 2),
                        );
                      }),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const double cellWidth = 50;

class _MultiplicationTableCell extends StatelessWidget {
  const _MultiplicationTableCell({
    super.key,
    this.value,
    this.color,
  });

  final int? value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      height: cellWidth,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black12,
          width: 1.0,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        '${value ?? ''}',
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}

class _TableHead extends StatelessWidget {
  const _TableHead({
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cellWidth,
      child: Row(
        children: [
          _MultiplicationTableCell(
            color: Colors.yellow.withOpacity(0.3),
            value: 1,
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(maxNumber - 1, (index) {
                return _MultiplicationTableCell(
                  color: Colors.yellow.withOpacity(0.3),
                  value: index + 2,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _MultiplicationTable extends StatefulWidget {
  @override
  State<_MultiplicationTable> createState() => _MultiplicationTableState();
}

class _MultiplicationTableState extends State<_MultiplicationTable> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TableHead(
          scrollController: _headController,
        ),
        Expanded(
          child: _TableBody(
            scrollController: _bodyController,
          ),
        ),
      ],
    );
  }
}
