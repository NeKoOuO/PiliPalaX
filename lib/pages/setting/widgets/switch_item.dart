import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:hive/hive.dart';
import 'package:PiliPalaX/utils/storage.dart';

class SetSwitchItem extends StatefulWidget {
  final String? title;
  final String? subTitle;
  final String? setKey;
  final bool? defaultVal;
  final Function? callFn;
  final bool? needReboot;
  final Widget? leading;
  final GestureTapCallback? onTap;

  const SetSwitchItem({
    this.title,
    this.subTitle,
    this.setKey,
    this.defaultVal,
    this.callFn,
    this.needReboot,
    this.leading,
    this.onTap,
    super.key,
  });

  @override
  State<SetSwitchItem> createState() => _SetSwitchItemState();
}

class _SetSwitchItemState extends State<SetSwitchItem> {
  // ignore: non_constant_identifier_names
  Box Setting = GStorage.setting;
  late bool val;

  @override
  void initState() {
    super.initState();
    val = Setting.get(widget.setKey, defaultValue: widget.defaultVal ?? false);
  }

  void switchChange(value) async {
    val = value ?? !val;
    await Setting.put(widget.setKey, val);
    // if (widget.setKey == SettingBoxKey.autoUpdate && value == true) {
    //   Utils.checkUpdate();
    // }
    if (widget.callFn != null) {
      widget.callFn!.call(val);
    }
    if (widget.needReboot != null && widget.needReboot!) {
      SmartDialog.showToast('重启生效');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
        color: widget.onTap != null && !val
            ? Theme.of(context).colorScheme.outline
            : null);
    TextStyle subTitleStyle = Theme.of(context)
        .textTheme
        .labelMedium!
        .copyWith(color: Theme.of(context).colorScheme.outline);
    return ListTile(
      enabled: widget.onTap != null ? val : true,
      enableFeedback: true,
      onTap: () =>
          widget.onTap != null ? widget.onTap?.call() : switchChange(null),
      title: Text(widget.title!, style: titleStyle),
      subtitle: widget.subTitle != null
          ? Text(widget.subTitle!, style: subTitleStyle)
          : null,
      leading: widget.leading,
      trailing: Transform.scale(
        alignment: Alignment.centerRight, // 缩放Switch的大小后保持右侧对齐, 避免右侧空隙过大
        scale: 0.8,
        child: Switch(
          thumbIcon:
              WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
            if (states.isNotEmpty && states.first == WidgetState.selected) {
              return const Icon(Icons.done);
            }
            return null; // All other states will use the default thumbIcon.
          }),
          value: val,
          onChanged: (val) => switchChange(val),
        ),
      ),
    );
  }
}
