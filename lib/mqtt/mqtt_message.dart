import 'package:intl/intl.dart';

/// MQTT 消息对象
class MQTTMessage {
  int type;           // 0 - request  1 - response   2 - relay
  String command;     // 命令字
  String msgId;       // uuid
  int senderId;       // 0 - cat   其他 - uid
  int receiverId;     // 0 - cat   其他 - uid
  DateTime sendTime;  // 发送时间
  String payload;     // 负载

  MQTTMessage({
    this.type: 0,
    this.command,
    this.msgId,
    this.senderId,
    this.receiverId: 0,
    this.sendTime,
    this.payload,
  });

  MQTTMessage.fromJson(json) :
        type = json['type'],
        command = json['command'],
        msgId = json['msgId'],
        senderId = json['senderId'],
        receiverId = json['receiverId'],
        sendTime = json['sendTime'],     //DateTime.parse(json['sendTime']),
        payload = json['payload'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['type'] = type;
    data['command'] = command;
    data['msgId'] = msgId;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['sendTime'] = DateFormat("yyyy-MM-dd HH:mm:ss").format(sendTime);
    data['payload'] = payload;

    return data;
  }

}
