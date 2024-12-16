import 'package:flutter/material.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';

class KiemDuyetButtons extends StatelessWidget {
  final Function onThongQua; // Hàm callback khi thông qua
  final Function onTuChoi; // Hàm callback khi từ chối

  const KiemDuyetButtons({
    Key? key,
    required this.onThongQua,
    required this.onTuChoi,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => onTuChoi(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(60, 40), // Kích thước nút
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.red, // Màu nền nút "Từ chối"
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
            children: [
              Icon(Icons.close, size: 18), // Biểu tượng close (dấu X)
              SizedBox(width: 5), // Khoảng cách giữa icon và text
              Text('Từ chối'), // Văn bản nút
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => onThongQua(),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(60, 40), // Kích thước nút
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Colors.green, // Màu nền nút "Thông qua"
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa nội dung
            children: [
              Icon(Icons.check, size: 18), // Biểu tượng check nhỏ
              SizedBox(width: 5), // Khoảng cách giữa icon và text
              Text('Thông qua'), // Văn bản nút
            ],
          ),
        ),
      ],
    );
  }
}
