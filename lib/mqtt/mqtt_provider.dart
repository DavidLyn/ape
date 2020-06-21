import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

///
/// MQTT provider
///
class MQTTProvider extends ChangeNotifier {

  static const mqttServer = '192.168.1.103:1883';
  //static const mqttServer = '172.16.40.36:1883';

  static const int keepAlivePeriod = 30;

  static MqttServerClient client;

  static bool isConnected = false;

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
    client.pongCallback = _pong;

    // Create a connection message to use
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(keepAlivePeriod) // Must agree with the keep alive set above or not set
        .withWillTopic('willtopic')    // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean()                  // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMess;

    // listen to to get notifications of published updates to each subscribed topic
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      final pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print(
          'MQTT::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
      print('');
    });

    // listen for published messages that have completed the publishing handshake which is Qos dependant
    client.published.listen((MqttPublishMessage message) {
      print(
          'MQTT::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });

  }

  /// connect server
  static void connect() async {
    if (client == null) {
      _createClient();
    }

    // Connect the server
    try {
      await client.connect();
    } on Exception catch (e) {
      print('MQTT::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('MQTT::broker is connected');
      isConnected = true;
    } else {
      /// Use status here rather than state if you also want the broker return code.
      print(
          'MQTT::ERROR broker connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      isConnected = false;
    }
  }

  /// publish message
  static void publish({@required String topic, @required String message, MqttQos qos : MqttQos.atLeastOnce}) {
    if (!isConnected || topic.isEmpty ||  message.isEmpty) {
      return;
    }

    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, qos, builder.payload);
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
    print('MQTT::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  static void _onDisconnected() {
    print('MQTT::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('MQTT::OnDisconnected callback is solicited, this is correct');
    }
    isConnected = false;
  }

  /// The successful connect callback
  static void _onConnected() {
    print(
        'MQTT::OnConnected client callback - Client connection was sucessful');
  }

  /// Pong callback
  static void _pong() {
    print('MQTT::Ping response client callback invoked');
  }
}