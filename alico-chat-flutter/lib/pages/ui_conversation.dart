import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/helper/helper_rongclond.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:flutter/material.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';

class UiConversation extends StatefulWidget {
  String userId;

  UiConversation(this.userId);

  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiConversation> with WidgetsBindingObserver {
  String _inputValue = "";
  TextEditingController _controller = TextEditingController();
  List<_Item> _dataList = [];
  EntityUser? _user;
  ScrollController _scrollController = ScrollController();
  bool _isLoadData = false;
  bool _showPlugin = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_scrollListener);
    HelperRongclond.onMessageReceivedListeners.add(_onMessageReceived);
    getData(null);
    getUser();
  }

  @override
  void dispose() {
    HelperRongclond.onMessageReceivedListeners.remove(_onMessageReceived);
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _user?.nickname ?? "",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ),
      body: InkWell(
        highlightColor: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: MediaQuery.of(context).padding.top + AppBar().preferredSize.height,
              child: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return RefreshIndicator(
                              child: SingleChildScrollView(
                                reverse: true,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        reverse: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: _dataList.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            child: Column(
                                              children: [
                                                Visibility(
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: ClipRRect(
                                                          child: WidgetImage(
                                                            _dataList[index].user?.avatar ?? "",
                                                            height: 36,
                                                            width: 36,
                                                            isCenterCrop: true,
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        width: 36,
                                                        height: 36,
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Flexible(
                                                          child: Container(
                                                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                                        child: Padding(padding: EdgeInsets.all(15), child: getContent(_dataList[index])),
                                                      )),
                                                    ],
                                                  ),
                                                  visible: _dataList[index].message.direction == RCIMIWMessageDirection.receive,
                                                ),
                                                Visibility(
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                          child: Container(
                                                        decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(16)),
                                                        child: Padding(padding: EdgeInsets.all(15), child: getContent(_dataList[index])),
                                                      )),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Container(
                                                        child: ClipRRect(
                                                          child: WidgetImage(
                                                            _dataList[index].user?.avatar ?? "",
                                                            height: 36,
                                                            width: 36,
                                                            isCenterCrop: true,
                                                          ),
                                                          borderRadius: BorderRadius.circular(20),
                                                        ),
                                                        width: 36,
                                                        height: 36,
                                                      ),
                                                    ],
                                                  ),
                                                  visible: _dataList[index].message.direction == RCIMIWMessageDirection.send,
                                                ),
                                              ],
                                            ),
                                            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onRefresh: () async {
                                if (_dataList.isEmpty) return;
                                await getData(_dataList[_dataList.length - 1].message);
                              });
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(0, -5), // changes position of shadow
                        )
                      ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                  child: Container(
                                alignment: AlignmentDirectional.centerStart,
                                decoration: BoxDecoration(color: Color(0xffe5e5e5), borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: TextField(
                                    focusNode: _focusNode,
                                    controller: _controller,
                                    decoration:
                                        InputDecoration(border: InputBorder.none, hintStyle: TextStyle(color: Color(0xff80ffffff), fontSize: 16)),
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _inputValue = value;
                                      });
                                    },
                                  ),
                                ),
                              )),
                              SizedBox(
                                width: 5,
                              ),
                              TextButton(
                                  onPressed: () {
                                    onSendMessage();
                                  },
                                  child: Icon(Icons.send,size: 30,)),
                              // InkWell(
                              //   child: Icon(
                              //     Icons.add,
                              //     color: Colors.black,
                              //     size: 30,
                              //   ),
                              //   onTap: () {
                              //     if (_focusNode.hasFocus) {
                              //       _showPlugin = true;
                              //     } else {
                              //       _showPlugin = !_showPlugin;
                              //     }
                              //     FocusScope.of(context).unfocus();
                              //     setState(() {
                              //       _showPlugin;
                              //     });
                              //   },
                              // )
                            ],
                          ),
                          Visibility(
                            child: Container(
                              height: HelperMediaQuerys.getScreenWidth(context) / 4 * 2,
                              child: PageView(
                                children: [
                                  Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      InkWell(
                                        child: Container(
                                          width: (HelperMediaQuerys.getScreenWidth(context) - 35) / 4,
                                          height: (HelperMediaQuerys.getScreenWidth(context) - 35) / 4,
                                          color: Colors.grey,
                                          child: Icon(Icons.photo),
                                        ),
                                        onTap: () async {
                                          // var xFile = await HelperImagePicker.selectImage();
                                          // var engine = await HelperRongclond.getEngine();
                                          // var result = await engine?.sendMediaMessage(
                                          //     RCIMIWMediaMessage.fromJson({
                                          //       "local": xFile?.path,
                                          //       "conversationType": RCIMIWConversationType.private.index,
                                          //       "targetId": widget.userId,
                                          //       "messageType": RCIMIWMessageType.image.index,
                                          //     }),
                                          //     listener: RCIMIWSendMediaMessageListener(
                                          //       onMediaMessageSent: (int? code, RCIMIWMediaMessage? message) {
                                          //         print(message);
                                          //       },
                                          //     ));
                                        },
                                      ),
                                      Container(
                                        width: (HelperMediaQuerys.getScreenWidth(context) - 35) / 4,
                                        height: (HelperMediaQuerys.getScreenWidth(context) - 35) / 4,
                                        color: Colors.grey,
                                        child: Icon(Icons.play_circle),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // visible: !_focusNode.hasFocus && _showPlugin,
                            visible: false,
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10,right: 5),
                    )
                  ],
                ),
                color: Color(0xffe5e5e5),
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            _showPlugin = false;
            _focusNode.unfocus();
          });
        },
      ),
    );
  }

  Future<void> getData(RCIMIWMessage? lastMessage) async {
    if (_isLoadData) return;
    _isLoadData = true;
    IRCIMIWGetMessagesCallback? callback = IRCIMIWGetMessagesCallback(onSuccess: (List<RCIMIWMessage>? t) async {
      if (lastMessage == null) _dataList.clear();
      var iterable = t;
      setState(() {
        iterable?.forEach((element) {
          _dataList.add(_Item(element));
        });
      });

      for (var element in _dataList) {
        var messageDirection = element.message.direction;
        if (messageDirection == RCIMIWMessageDirection.send) {
          var user = await EntityUser.getAccountUser();
          element.user = user;
        } else {
          var user = await EntityUser.get(element.message.senderUserId ?? "");
          element.user = user;
        }
      }
      setState(() {
        _dataList;
      });
      // if (lastMessage == null) _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      _isLoadData = false;
    }, onError: (int? code) {
      print("object");
    });

    var engine = await HelperRongclond.getEngine();
    engine?.getMessages(RCIMIWConversationType.private, widget.userId, null, lastMessage?.sentTime ?? 0, RCIMIWTimeOrder.before,
        RCIMIWMessageOperationPolicy.localRemote, 20,
        callback: callback);
    await engine?.clearUnreadCount(
      RCIMIWConversationType.private,
      widget.userId,
      null,
      DateTime.now().microsecondsSinceEpoch,
    );
    HelperRongclond.notifyCommonListeners();
  }

  Widget getContent(_Item item) {
    var messageType = item.message.messageType;
    if (messageType == RCIMIWMessageType.text) {
      var textMessage = item.message as RCIMIWTextMessage;
      return Text(
        textMessage.text ?? "",
        style: TextStyle(color: item.message.direction == RCIMIWMessageDirection.receive ? Colors.black : Colors.white),
      );
    }
    if (messageType == RCIMIWMessageType.image) {
      var imageMessage = item.message as RCIMIWImageMessage;
      return Container(
        width: 150,
        child: AspectRatio(
          aspectRatio: 1 / 1.25,
          child: WidgetImage(imageMessage.remote?.isNotEmpty == true ? imageMessage.remote ?? "" : imageMessage.local ?? ""),
        ),
      );
    }
    return Text(
      "unknown",
      style: TextStyle(color: Colors.white),
    );
  }

  Future<void> onSendMessage() async {
    if (_inputValue.isEmpty) return;

    var engine = await HelperRongclond.getEngine();
    await engine?.sendMessage(
        RCIMIWTextMessage.fromJson({
          "text": _inputValue,
          "conversationType": RCIMIWConversationType.private.index,
          "targetId": widget.userId,
          "messageType": RCIMIWMessageType.text.index
        }),
        callback: RCIMIWSendMessageCallback(onMessageSaved: (RCIMIWMessage? message) {
          print("object");
        }, onMessageSent: (int? code, RCIMIWMessage? message) async {
          print("object");
          _inputValue = "";
          _controller.clear();
          addItem(message);
          // FocusScope.of(context).unfocus();
        }));
  }

  void _onMessageReceived(RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
    if (message?.targetId == widget.userId) {
      addItem(message);
    }
  }

  void _scrollListener() {
    var offset = _scrollController.offset;
    if (offset < 50 && !_isLoadData) {
      // getData(_dataList[0].message);
    }
  }

  Future<void> getUser() async {
    var user = await EntityUser.get(widget.userId);
    setState(() {
      _user = user;
    });
  }

  Future<void> addItem(RCIMIWMessage? message) async {
    if (message != null) {
      var item = _Item(message);
      _dataList.insert(0, item);
      var messageDirection = message.direction;
      if (messageDirection == RCIMIWMessageDirection.send) {
        var user = await EntityUser.getAccountUser();
        item.user = user;
      } else {
        var user = await EntityUser.get(message.senderUserId ?? "");
        item.user = user;
      }
      setState(() {
        _dataList;
      });
    }
  }
}

class _Item {
  RCIMIWMessage message;
  EntityUser? user;

  _Item(this.message);
}
