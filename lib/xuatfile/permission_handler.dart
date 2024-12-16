import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    print("Đã được cấp quyền lưu trữ.");
  } else {
    print("Quyền lưu trữ bị từ chối.");
  }
}
