import 'package:PiliPalaX/common/widgets/refresh_indicator.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:PiliPalaX/utils/utils.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:PiliPalaX/common/widgets/http_error.dart';

import '../../common/constants.dart';
import '../../utils/grid.dart';
import 'controller.dart';
import 'widgets/fan_item.dart';

class FansPage extends StatefulWidget {
  const FansPage({super.key});

  @override
  State<FansPage> createState() => _FansPageState();
}

class _FansPageState extends State<FansPage> {
  late String mid;
  late FansController _fansController;

  @override
  void initState() {
    super.initState();
    mid = Get.parameters['mid']!;
    _fansController = Get.put(FansController(), tag: Utils.makeHeroTag(mid));
    _fansController.scrollController.addListener(
      () async {
        if (_fansController.scrollController.position.pixels >=
            _fansController.scrollController.position.maxScrollExtent - 200) {
          EasyThrottle.throttle('follow', const Duration(seconds: 1), () {
            _fansController.onLoadMore();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _fansController.scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _fansController.isOwner.value ? '我的粉丝' : '${_fansController.name}的粉丝',
        ),
      ),
      body: refreshIndicator(
        onRefresh: () async => await _fansController.onRefresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _fansController.scrollController,
          slivers: [
            Obx(() => _buildBody(_fansController.loadingState.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(LoadingState loadingState) {
    return switch (loadingState) {
      Loading() => HttpError(
          callback: _fansController.onReload,
        ),
      Success() => (loadingState.response as List?)?.isNotEmpty == true
          ? SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: StyleString.cardSpace,
                  crossAxisSpacing: StyleString.safeSpace,
                  maxCrossAxisExtent: Grid.maxRowWidth * 2,
                  mainAxisExtent: 56),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return fanItem(item: loadingState.response[index]);
                },
                childCount: loadingState.response.length,
              ),
            )
          : HttpError(
              callback: _fansController.onReload,
            ),
      Error() => HttpError(
          errMsg: loadingState.errMsg,
          callback: _fansController.onReload,
        ),
      LoadingState() => throw UnimplementedError(),
    };
  }
}
