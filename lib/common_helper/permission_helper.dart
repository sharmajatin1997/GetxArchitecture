import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:getx_code_architecture/constants/utils.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {

  Future<bool> hasCameraPermission() async {
    var status = await Permission.camera.status;
    if(status == PermissionStatus.denied){
      status = await Permission.camera.request();
    }
    debugPrint("Camera Permission status: $status");
    if (status == PermissionStatus.permanentlyDenied) {
      Utils.error("Camera permission is permanently denied, so we are redirecting to app settings to enable camera permission.");
      Future.delayed(const Duration(seconds: 4), () => openAppSettings());
    } else if (status == PermissionStatus.denied) {
      Utils.error("Camera permission is denied, so we are not able to complete the task. Please try again.");
    }
    return status == PermissionStatus.granted;
  }

  Future<bool> hasMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if(status == PermissionStatus.denied){
      status = await Permission.microphone.request();
    }
    debugPrint("Microphone Permission status: $status");
    if (status == PermissionStatus.permanentlyDenied) {
      Utils.error("Microphone permission is permanently denied, so we are redirecting to app settings to enable microphone permission.");
      Future.delayed(const Duration(seconds: 4), () => openAppSettings());
    } else if (status == PermissionStatus.denied) {
      Utils.error("Microphone permission is denied, so we are not able to complete the task. Please try again.");
    }
    return status == PermissionStatus.granted;
  }

  Future<bool> getStoragePermission() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else if (status.isPermanentlyDenied) {
      Utils.error("Storage permission is permanently denied, so we are redirecting to app settings to enable Storage permission.");
      Future.delayed(const Duration(seconds: 4), () => openAppSettings());
      return false;
    } else if (status.isDenied) {
      Utils.error("Storage permission is denied, so we are not able to complete the task. Please try again.");
      if (kDebugMode) {
        print('Permission Denied');
      }
      return false;
    }
    return false;
  }


  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if(status == PermissionStatus.denied){
        status = await Permission.storage.request();
      }
      debugPrint("Storage Permission status: $status");
      if (status == PermissionStatus.permanentlyDenied) {
        Utils.error("Storage permission is permanently denied, so we are redirecting to app settings to enable storage permission.");
        Future.delayed(const Duration(seconds: 4), () => openAppSettings());
      } else if (status == PermissionStatus.denied) {
        Utils.error("Storage permission is denied, so we are not able to complete the task. Please try again.");
      }
      return status == PermissionStatus.granted;

    } else {
      var status = await Permission.photos.status;

      if(status == PermissionStatus.denied){
        status = await Permission.photos.request();
      }
      debugPrint("Photos Permission status: $status");
      if (status == PermissionStatus.permanentlyDenied) {
        Utils.error("Photos permission is permanently denied, so we are redirecting to app settings to enable photos permission.");
        Future.delayed(const Duration(seconds: 4), () => openAppSettings());
      } else if (status == PermissionStatus.denied) {
        Utils.error("Photos permission is denied, so we are not able to complete the task. Please try again.");
      }
      return status == PermissionStatus.granted || status == PermissionStatus.limited;
    }
  }

  Future<bool> hasCameraMicrophonePermission() async {
    bool cameraPermission = await hasCameraPermission();
    bool microphonePermission = await hasMicrophonePermission();
    return cameraPermission && microphonePermission;
  }

  Future<bool> hasCameraStoragePermission() async {
    bool cameraPermission = await hasCameraPermission();
    bool storagePermission = await hasStoragePermission();
    return cameraPermission && storagePermission;
  }

}
