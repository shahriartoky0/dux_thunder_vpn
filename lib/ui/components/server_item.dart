import 'dart:math';

import 'package:dart_ping/dart_ping.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';

import 'package:provider/provider.dart';

import '../../core/models/connected_server_info.dart';
import '../../core/models/vpn_config.dart';
import '../../core/providers/globals/ads_provider.dart';
import '../../core/providers/globals/connected_server.dart';
import '../../core/providers/globals/vpn_provider.dart';
import '../../core/resources/colors.dart';
import '../../core/resources/environment.dart';
import '../../core/utils/navigations.dart';
import 'custom_image.dart';

class ServerItem extends StatefulWidget {
  final VpnConfig config;

  const ServerItem(this.config, {super.key});

  @override
  State<ServerItem> createState() => _ServerItemState();
}

class _ServerItemState extends State<ServerItem>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      VpnProvider.read(context).initialize(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool selected =
        context.watch<ConnectedServerProvider>().connectedServerId ==
            widget.config.id;
    DateTime now = DateTime.now();
    super.build(context);
    return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: _click,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            // padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              // gradient: selected
              //     ? LinearGradient(
              //         colors: [
              //           Colors.greenAccent.shade400,
              //           Colors.green.shade600
              //         ],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //       )
              //     : LinearGradient(
              //         colors: [Colors.grey.shade800, Colors.grey.shade700],
              //         begin: Alignment.topLeft,
              //         end: Alignment.bottomRight,
              //       ),
              borderRadius: BorderRadius.circular(12),
              // boxShadow: [
              //   BoxShadow(
              //     color: selected
              //         ? Colors.greenAccent.withOpacity(0.5)
              //         : Colors.black38,
              //     blurRadius: 10,
              //     offset: const Offset(2, 4),
              //   ),
              // ],
            ),
            child: Row(children: [
              // SizedBox(
              //   width: 36,
              //   height: 36,
              //   child: CustomImage(
              //     url: widget.config.flagUrl,
              //     fit: BoxFit.cover,
              //     borderRadius: BorderRadius.circular(6),
              //   ),
              // ),
              // const SizedBox(width: 10),
              Expanded(
                  // child: Text(
                  // widget.config.area ?? '',
                  // style: const TextStyle(
                  // color: Colors.white,
                  // fontSize: 18,
                  // fontWeight: FontWeight.w500,
                  // ),
                  // ),
                  // ),
                  // const SizedBox(width: 10),
                  // Icon(
                  // Icons.arrow_forward_ios_outlined,
                  // color: selected ? Colors.white : Colors.grey.shade400,
                  // size: 28,
                  // ),
                  // ],
                  // ),
                  // ),
                  child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade400, width: 2),
                ),
                // tileColor: selected
                //     ? primaryColor.withValues(alpha: 0.6)
                //     : Colors.grey.shade200,
                leading: CircleAvatar(
                  child: CustomImage(
                    url: widget.config.flagUrl,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                title: Text(
                  widget.config.country.toString(),
                ),
                subtitle: Text(
                  widget.config.area.toString(),
                ),
                trailing: Wrap(
                  children: [
                    selected
                        ? const Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                            size: 24,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(
                      width: 8,
                    ),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ))
            ])));
  }

  // void _itemClick([bool force = false]) async {
  //   if (!IAPProvider.read(context).isPro &&
  //       widget.config.status == 1 &&
  //       !force) {
  //     return NAlertDialog(
  //       blur: 10,
  //       title: const Text("not_allowed").tr(),
  //       content: Text(unlockProServerWithRewardAds
  //               ? "also_allowed_with_watch_ad_description"
  //               : "not_allowed_description")
  //           .tr(),
  //       actions: [
  //         if (unlockProServerWithRewardAds)
  //           TextButton(
  //             child: Text("watch_ad".tr()),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               showReward();
  //             },
  //           ),
  //         TextButton(
  //           child: Text("go_premium".tr()),
  //           onPressed: () => replaceScreen(context, const SubscriptionScreen()),
  //         ),
  //       ],
  //     ).show(context);
  //   }
  //   VpnProvider.read(context)
  //       .selectServer(context, widget.config)
  //       .then((value) {
  //     if (value != null) {
  //       VpnProvider.read(context).disconnect();
  //       closeScreen(context);
  //     }
  //   });
  // }
  void _click() {
    // debugPrint('lol');
    // debugPrint(widget.config.flagUrl);
    // return NAlertDialog(
    //   blur: 10,
    //   title: const Text("not_allowed").tr(),
    //   content: Text(unlockProServerWithRewardAds
    //           ? "also_allowed_with_watch_ad_description"
    //           : "not_allowed_description")
    //       .tr(),
    //   actions: [
    //     if (unlockProServerWithRewardAds)
    //       TextButton(
    //         child: Text("watch_ad".tr()),
    //         onPressed: () {
    //           Navigator.pop(context);
    //           // showReward();
    //         },
    //       ),
    //     TextButton(
    //       child: Text("go_premium".tr()),
    //       onPressed: () => replaceScreen(context, const SubscriptionScreen()),
    //     ),
    //   ],
    // ).show(context);
    VpnProvider.read(context)
        .selectServer(context, widget.config)
        .then((value) {
      if (value != null) {
        // debugPrint(value.flagUrl.toString());
        VpnProvider.read(context).connect();

        final newInfo = ConnectedServerInfo(
            id: widget.config.id,
            url: widget.config.flagUrl,
            country: widget.config.country,
            area: widget.config.area);
        Future.delayed(const Duration(seconds: 1)).then((_) async {
          await Provider.of<ConnectedServerProvider>(context, listen: false)
              .saveConnectedServerInfo(newInfo);

          closeScreen(context);
        });
      }
    });
  }

  void showReward() async {
    CustomProgressDialog customProgressDialog =
        CustomProgressDialog(context, dismissable: false, onDismiss: () {});

    customProgressDialog.show();

    AdsProvider.read(context)
        .loadRewardAd(interstitialRewardAdUnitID)
        .then((value) async {
      customProgressDialog.dismiss();
      if (value != null) {
        value.show(onUserEarnedReward: (ad, reward) {
          // _itemClick(true);
        });
      } else {
        if (unlockProServerWithRewardAdsFail) {
          await NAlertDialog(
            blur: 10,
            title: Text("no_reward_title".tr()),
            content: Text("no_reward_but_unlock_description".tr()),
            actions: [
              TextButton(
                  child: Text("understand".tr()),
                  onPressed: () => Navigator.pop(context))
            ],
          ).show(context);
          // _itemClick(true);
        } else {
          NAlertDialog(
            blur: 10,
            title: Text("no_reward_title".tr()),
            content: Text("no_reward_description".tr()),
            actions: [
              TextButton(
                  child: Text("understand".tr()),
                  onPressed: () => Navigator.pop(context))
            ],
          ).show(context);
        }
      }
    });
  }

  @override
  bool get wantKeepAlive => true;
}
