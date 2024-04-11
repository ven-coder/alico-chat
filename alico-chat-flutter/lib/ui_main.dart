import 'package:alico_chat/helper/helper_rongclond.dart';
import 'package:alico_chat/pages/ui_conversasion_list.dart';
import 'package:alico_chat/pages/ui_mine.dart';
import 'package:alico_chat/pages/ui_share_list.dart';
import 'package:alico_chat/pages/ui_user_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';

class UiMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiMain> {
  int _index = 0;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    HelperRongclond.onMessageReceivedListeners.add(_onMessageReceived);
    HelperRongclond.onConnectListeners.add(_onConnect);
    HelperRongclond.addCommonListeners(_onCommonListener);
    HelperRongclond.connect();
  }

  void _onMessageReceived(RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
    _getData();
  }

  _onConnect() {
    _getData();
  }

  @override
  void dispose() {
    HelperRongclond.onMessageReceivedListeners.remove(_onMessageReceived);
    HelperRongclond.onConnectListeners.remove(_onConnect);
    HelperRongclond.removeCommonListeners(_onCommonListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: [
          UiUserList(),
          UiShareList(),
          UiConversasionList(),
          UiMine(),
        ],
        index: _index,
      ),
      bottomNavigationBar: Container(
        child: Row(
          children: [
            Expanded(
                child: InkWell(
              child: Container(
                color: _index == 0 ? Colors.blue : Colors.white,
                alignment: AlignmentDirectional.center,
                height: 50,
                child: Icon(
                  Icons.supervisor_account_rounded,
                  color: _index == 0 ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  _index = 0;
                });
              },
            )),
            Expanded(
                child: InkWell(
              child: Container(
                color: _index == 1 ? Colors.blue : Colors.white,
                alignment: AlignmentDirectional.center,
                height: 50,
                child: Icon(
                  Icons.featured_play_list_rounded,
                  color: _index == 1 ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  _index = 1;
                });
              },
            )),
            Expanded(
                child: InkWell(
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Container(
                    color: _index == 2 ? Colors.blue : Colors.white,
                    alignment: AlignmentDirectional.center,
                    height: 50,
                    child: Icon(
                      Icons.email_rounded,
                      color: _index == 2 ? Colors.white : Colors.black,
                    ),
                  ),
                  Visibility(
                    visible: _unreadCount > 0,
                    child: Container(
                      margin: EdgeInsets.only(left: 25, top: 5),
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 1),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        _unreadCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _index = 2;
                });
              },
            )),
            Expanded(
                child: InkWell(
              child: Container(
                color: _index == 3 ? Colors.blue : Colors.white,
                alignment: AlignmentDirectional.center,
                height: 50,
                child: Icon(
                  Icons.person,
                  color: _index == 3 ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  _index = 3;
                });
              },
            )),
          ],
        ),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, -5), // changes position of shadow
          ),
        ]),
      ),
    );
  }

  Future<void> _getData() async {
    IRCIMIWGetUnreadCountByConversationTypesCallback? callback = IRCIMIWGetUnreadCountByConversationTypesCallback(
        onSuccess: (int? t) {
          setState(() {
            _unreadCount = t ?? 0;
          });
        },
        onError: (int? code) {});

    var engine = await HelperRongclond.getEngine();
    engine?.getUnreadCountByConversationTypes([RCIMIWConversationType.private], null, false, callback: callback);
  }

  _onCommonListener() {
    _getData();
  }
}
