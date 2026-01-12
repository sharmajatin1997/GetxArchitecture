import 'package:flutter/foundation.dart';
import 'package:getx_code_architecture/api/network/api_constants.dart';
import 'package:getx_code_architecture/common_helper/shared_prefence_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketHelper {
  static final SocketHelper _singleton = SocketHelper._internal();

  SocketHelper._internal();

  factory SocketHelper() => _singleton;

  late IO.Socket _socketIO;

  bool isConnected = false, isUserConnected = false;

  String tag = "socket";

  Future<void> init() async {
    _socketIO = IO.io(
        ApiConstants.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew().build());
    _initListener();
  }

  _initListener() {
    _socketIO.onConnect((data) {
      isConnected = true;
      if (SharedPreferenceHelper().getUserId() != null) {
        connectUser();
      }
      if (kDebugMode) {
        print('$tag connected');
      }
    });
    _socketIO.onConnectError((data) {
      isConnected = false;
      if (kDebugMode) {
        print(data.toString());
      }
    });
    _socketIO.onError((data) {
      if (kDebugMode) {
        print(data.toString());
      }
    });
    _socketIO.onDisconnect((data) {
      isConnected = false;
      if (SharedPreferenceHelper().getUserId() != null) {
        disconnectUser();
      }
      if (kDebugMode) {
        print('$tag connected');
      }
    });
    _socketIO.on("connect_user", (data) {
      isUserConnected = true;
      if (kDebugMode) {
        print("$tag user connected : $data");
      }
    });

  }

  IO.Socket getSocket() => _socketIO;

  connectUser() {
    Map<String, dynamic> body = {
      "user_id": SharedPreferenceHelper().getUserId()
    };
    _socketIO.emit("connect_user", body, );
  }

  disconnectUser() {
    _socketIO.on("disconnect_user", (data) {
      isUserConnected = false;
      if (kDebugMode) {
        print("$tag disconnected user: $data");
      }
    });
    Map<String, dynamic> map = {
      "user_id": SharedPreferenceHelper().getUserId()
    };
    _socketIO.emit("disconnect_user", map);
    if (kDebugMode) {
      print("$tag disConnectUser called $map");
    }
    isUserConnected = false;
  }
}
