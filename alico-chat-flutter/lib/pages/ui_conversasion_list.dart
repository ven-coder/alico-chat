import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_rongclond.dart';
import 'package:alico_chat/pages/ui_conversation.dart';
import 'package:alico_chat/pages/ui_user_details.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';

class UiConversasionList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiConversasionList> with WidgetsBindingObserver {
  List<_Item> _list = [];

  @override
  void initState() {
    super.initState();
    HelperRongclond.onMessageReceivedListeners.add(_onMessageReceived);
    HelperRongclond.onConnectListeners.add(_onConnect);
  }

  void _onMessageReceived(RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
    getData();
  }

  @override
  void dispose() {
    HelperRongclond.onMessageReceivedListeners.remove(_onMessageReceived);
    HelperRongclond.onConnectListeners.remove(_onConnect);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant UiConversasionList oldWidget) {
    getData();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).padding.top,
            child: _list.isEmpty
                ? Center(
                    child: Text(
                      "还没有消息",
                      style: TextStyle(color: Color(0xff80000000), fontSize: 18),
                    ),
                  )
                : RefreshIndicator(
                    child: ListView.builder(
                        itemCount: _list.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Container(
                              margin: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                              child: Row(
                                children: [
                                  InkWell(
                                    child: Stack(
                                      children: [
                                        WidgetImage(
                                          _list[index].user?.avatar ?? "",
                                          width: 52,
                                          height: 52,
                                          isCenterCrop: true,
                                          borderRadius: 30,
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: Visibility(
                                            visible: (_list[index].conversation.unreadCount ?? 0) > 0,
                                            child: Container(
                                              padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 1),
                                              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                              child: Text(
                                                _list[index].conversation.unreadCount.toString(),
                                                style: const TextStyle(color: Colors.white, fontSize: 10),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    onTap: () async {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return UiUserDetails(userId: _list[index].user?.userId.toString() ?? "");
                                      }));
                                      getData();
                                    },
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                              fit: FlexFit.tight,
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                _list[index].user?.nickname ?? "",
                                                maxLines: 1,
                                                softWrap: false,
                                                style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
                                              )),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            getTime(index),
                                            style: TextStyle(color: Color(0xff80000000)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Flexible(
                                          child: Text(
                                        getContent(index),
                                        style: TextStyle(color: Color(0xff80000000)),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        softWrap: false,
                                      )),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            onTap: () async {
                              await Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return UiConversation(_list[index].user?.userId.toString() ?? "");
                              }));
                              getData();
                            },
                          );
                        }),
                    onRefresh: () async {
                      await getData();
                    }),
          ),
        ],
      ),
    );
  }

  Future<void> getData() async {
    IRCIMIWGetConversationsCallback? callback = IRCIMIWGetConversationsCallback(onSuccess: (List<RCIMIWConversation>? t) async {
      _list.clear();
      setState(() {
        t?.forEach((element) {
          _list.add(_Item(element));
        });
      });

      for (var element in _list) {
        var user = await EntityUser.get(element.conversation.targetId ?? "");
        element.user = user;
      }
      setState(() {
        _list;
      });
    }, onError: (int? code) {
//...
    });

    var engine = await HelperRongclond.getEngine();
    await engine?.getConversations([RCIMIWConversationType.private], null, 0, 50, callback: callback);
  }

  String getContent(int index) {
    var conversation = _list[index].conversation;
    var lastMessage = conversation.lastMessage;
    if (lastMessage?.messageType == RCIMIWMessageType.text) {
      var textMessage = lastMessage as RCIMIWTextMessage;
      return textMessage.text ?? "";
    }
    return "[unknown]";
  }

  String getTime(int index) {
    var receivedTime = _list[index].conversation.lastMessage?.receivedTime;
    // 将时间戳转换为DateTime对象
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(receivedTime ?? 0);

    // 获取今天的日期和昨天的日期
    DateTime today = DateTime.now();
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));

    // 如果时间是今天
    if (dateTime.year == today.year && dateTime.month == today.month && dateTime.day == today.day) {
      return ('${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}');
    }
    // 如果时间是昨天
    else if (dateTime.year == yesterday.year && dateTime.month == yesterday.month && dateTime.day == yesterday.day) {
      return ('yesterday ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}');
    }
    // 其他情况
    else {
      return ('${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}');
    }
  }

  _onConnect() {
    getData();
  }
}

class _Item {
  RCIMIWConversation conversation;
  EntityUser? user;

  _Item(this.conversation, {this.user});
}
