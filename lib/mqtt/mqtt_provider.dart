import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:ape/common/constants.dart';

/// MQTT provider
class MQTTProvider extends ChangeNotifier {

  static const commandMakeFriend = 'makeFriend';     // 申请加好友

  // 向后台发送消息的 topic
  static const topicOfCatEars = 'cat/ears';

  // 本地监听 topic 的前缀,完整 topic = topicPrefixToListen + uid
  static const topicPrefixToListen = 'cat/msg/';

  // note : tcp://192.168.1.101 or 192.168.1.101:1883 all are error!!!
  static const mqttServer = '47.94.248.253';
  //static const mqttServer = '192.168.1.101';

  static const int keepAlivePeriod = 30;

  static MqttServerClient client;

  // 是否需要进行连接,当用户处于登录状态时需要进行连接
  static bool isNeedToConnect = false;

  // 当前连接状态
  static bool isConnected = false;

  // 重连任务 定时器
  static Timer timer;

  /// create client
  static void _createClient() {
    client = MqttServerClient(mqttServer,'');

    // Set logging on if needed, defaults to off
    client.logging(on: false);

    // default(60s)
    client.keepAlivePeriod = keepAlivePeriod;

    // Add the unsolicited disconnection callback
    client.onDisconnected = _onDisconnected;

    // Add the successful connection callback
    client.onConnected = _onConnected;

    // Add a subscribed callback
    client.onSubscribed = _onSubscribed;

    // Add a ping received callback
    // client.pongCallback = _pong;
    
    // Create a connection message to use
    final connMess = MqttConnectMessage()
        .withClientIdentifier(UserInfo.user.uid.toString())
        .keepAliveFor(keepAlivePeriod) // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic')    // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean()                  // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

  }

  /// connect server
  static void connect({String clientId : 'testClient'}) async {

    isNeedToConnect = true;

    _createClient();

    // Connect the server
    try {
      await client.connect();

      // 注意 : 只能在 connect 后才能 updates.listen
      // listen to to get notifications of published updates to each subscribed topic
//      client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
//        final MqttPublishMessage recMess = c[0].payload;
//        final pt =
//        MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//
//        print(
//            'MQTT::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//        print('');
//      });

      // 注意 : 只能在 connect 后才能 published.listen
      // listen for published messages that have completed the publishing handshake which is Qos dependant
      client.published.listen((MqttPublishMessage message) {
        //var pt = MqttPublishPayload.bytesToStringAsString(message.payload.message);
        // 必须如下处理,不然会存在中文乱码  2020-07-11 Lvvv
        var pt = Utf8Decoder().convert(message.payload.message);
        print(
            'MQTT -------> topic = ${message.variableHeader.topicName}, Qos = ${message.header.qos}, payload = $pt');
      });
    } on Exception catch (e) {
      print('MQTT::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      isConnected = true;
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'MQTT::ERROR broker connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      isConnected = false;

      // 启动重连机制
      _reconnect();
    }

    // 订阅 cat/msg/{uid} 主题, cat 将向该主题发送消息
    subscribe('$topicPrefixToListen${UserInfo.user.uid}');
  }

  /// reconnect
  static void _reconnect() {
    if (!isNeedToConnect) {
      return;
    }

    if (isConnected) {
      return;
    }

    if (timer == null || !timer.isActive) {
      timer = Timer(Duration(milliseconds: 1000), () {
        if (isConnected || !isNeedToConnect) {
          timer.cancel();
        }
        print('------------------------> MQTT reconnect timer is running!!!');
        connect();
      },);
    }
  }

  /// 外部调用,关闭连接并设置为不必重连
  static void disconnect() {
    isNeedToConnect = false;
    isConnected = false;

    client?.disconnect();
  }

  /// publish message
  static bool publish({String topic : topicOfCatEars, @required String message, MqttQos qos : MqttQos.atLeastOnce}) {
    if (!isConnected || topic.isEmpty ||  message.isEmpty) {
      return false;
    }

    final builder = MqttClientPayloadBuilder();
    //builder.addString(message);
    // 必须如下处理,不然存在后台无法正常解析Json中中文的问题 2020-07-11 Lvvv
    builder.addUTF8String(message);
    client.publishMessage(topic, qos, builder.payload);

    return true;
  }

  /// subscribe topic
  static void subscribe(String topic,{MqttQos qos : MqttQos.atLeastOnce}) {
    if (!isConnected) {
      return;
    }

    client.subscribe(topic,qos);

  }

  /// unsubscribe topic
  static void unsubscribe(String topic) {
    if (!isConnected) {
      return;
    }
    client.unsubscribe(topic);
  }

  /// The subscribed callback
  static void _onSubscribed(String topic) {
    print('MQTT topic $topic is subscripted!');
  }

  /// The unsolicited disconnect callback
  static void _onDisconnected() {
    print('MQTT broker is disconnected!');
    if (client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('MQTT::OnDisconnected callback is solicited, this is correct');
    }
    isConnected = false;

    // 启动重连机制
    _reconnect();
  }

  /// The successful connect callback
  static void _onConnected() {
    print(
        'MQTT Client connect to broker sucessful!');
  }

  /// Pong callback
  static void _pong() {
    print('MQTT::Ping response client callback invoked');
  }
}
