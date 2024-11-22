import 'package:flutter/widgets.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants.dart';
import 'package:flutter_login_api/models/chitietkpikhoaphong.dart';
import 'package:flutter_login_api/models/kpikhoaphong.dart';
import 'package:flutter_login_api/models/thongbao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlapi = url;

class Usuario_provider3 with ChangeNotifier {
  List<ThongBao> thongbao = [];


  Usuario_provider3() {
    getThongBao();
  }
  String usuarioToJson(ThongBao thongbao) {
    Map<String, dynamic> data() => {
          "maThongBao": thongbao.maThongBao,
          "maNhanVien": thongbao.maNhanVien,
          "tieuDe": thongbao.tieuDe,
          "noiDung": thongbao.noiDung, // Sẽ là null nếu không có giá trị
          "thoiGian": thongbao.thoiGian,
          "trangThai": thongbao.trangThai,
          "maPhieu":thongbao.maPhieu,
        };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  getThongBao() async {
    final url1 = Uri.http(urlapi, 'api/Thongbaos');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonThongbao(resp.body);
    thongbao = response;
    notifyListeners();
  }

  Future<void> addThongbao(ThongBao thongbao) async {
    final url1 = Uri.http(urlapi, 'api/Thongbaos');
    print("hamaddkpikp:$url1");
    try {
      final resp = await http.post(
        url1,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
            thongbao.toJson()), // Chuyển đổi đối tượng thành JSON
      );

      // In thử ra mã trạng thái và nội dung phản hồi từ API
      print('Response status: ${resp.statusCode}');
     // print('Response body: ${resp.body}');

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
        await getThongBao(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
        notifyListeners();
      } else {
        // In thêm thông tin lỗi khi status code không thành công
        print('Failed to add KPI: ${resp.statusCode} - ${resp.body}');
        //throw Exception('Failed to add KPI: ${resp.body}');
      }
    } catch (e) {
      // In ra lỗi bắt được khi xảy ra ngoại lệ
      print('Error during API call: $e');
      // throw Exception('Error during API call: $e');
    }
  }

  Future<void> updateThongbao(ThongBao thongbao) async {
  // Tạo URL cho PUT request
  final url1 = Uri.http(
      urlapi, 'api/Thongbaos/${thongbao.maThongBao}');
  
  // In ra URL để kiểm tra
  print('Updating KPI at URL: $url1');

  // Gửi PUT request
  final resp = await http.put(
    url1,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    },
    body: json.encode(thongbao.toJson()), // Chuyển đổi đối tượng thành JSON
  );

  // In ra mã trạng thái của phản hồi
  print('Response status code: ${resp.statusCode}');

  // Kiểm tra mã trạng thái
  if (resp.statusCode == 204) {
    // Cập nhật thành công
    print('KPI updated successfully.');
    
    // Gọi hàm để lấy lại dữ liệu
    getThongBao(); // Hoặc bạn có thể cập nhật thủ công danh sách usuarios
    notifyListeners();
  } else {
    // Xử lý lỗi nếu cần
    print('Failed to update KPI. Response: ${resp.body}');
    // throw Exception('Thất bại cập nhật KPI cá nhân');
  }
}


  Future<void> deleteThongbao(String maphieukpikhoaphong) async {
    final url1 = Uri.http(urlapi, 'api/KPIBenhViens/$maphieukpikhoaphong');
    try {
      final resp = await http.delete(
        url1,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
      );

      if (resp.statusCode == 204) {
        // Xóa thành công, cập nhật lại danh sách
        thongbao.removeWhere(
            (usuario) => usuario.maThongBao == maphieukpikhoaphong);
        notifyListeners();
      } else {
        // Xử lý lỗi nếu cần
        // throw Exception(
        //     'Failed to delete usuario. Status code: ${resp.statusCode}');
      }
    } catch (error) {
      print('Error deleting usuario: $error');
      // Có thể thêm thông báo lỗi cho người dùng ở đây
      // throw Exception('An error occurred while deleting usuario.');
    }
  }
Future<List<ThongBao>?> getThongBaoByMaNV(String manhanvien) async {
  try {
    final url1 = Uri.http(urlapi, 'api/Thongbaos/getThongBaoByMaNV/', {
      'manhanvien': manhanvien,
    });
    print("Đường dẫn: $url1");

    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    if (resp.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(resp.body);
      print("Dữ liệu từ API: $jsonData");

      // Kiểm tra nếu dữ liệu không rỗng thì chuyển đổi thành danh sách các đối tượng ThongBao
      if (jsonData.isNotEmpty) {
        return jsonData.map<ThongBao>((json) => ThongBao.fromJson(json)).toList();
      } else {
        return []; // Trả về danh sách rỗng nếu không có thông báo nào
      }
    } else {
      print('Lỗi từ API: ${resp.statusCode} - ${resp.body}');
      throw Exception('Không thể lấy thông tin nhân viên');
    }
  } catch (error) {
    print('Lỗi khi lấy thông tin nhân viên: $error');
    return null;
  }
  
}

Future<List<ThongBao>?> getThongBaoByMaPhieu(String maphieu) async {
  try {
    final url1 = Uri.http(urlapi, 'api/Thongbaos/getThongBaoByMaPhieu/', {
      'maphieu': maphieu,
    });
    print("Đường dẫn: $url1");

    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    if (resp.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(resp.body);
      print("Dữ liệu từ API: $jsonData");

      // Kiểm tra nếu dữ liệu không rỗng thì chuyển đổi thành danh sách các đối tượng ThongBao
      if (jsonData.isNotEmpty) {
        return jsonData.map<ThongBao>((json) => ThongBao.fromJson(json)).toList();
      } else {
        return []; // Trả về danh sách rỗng nếu không có thông báo nào
      }
    } else {
      print('Lỗi từ API: ${resp.statusCode} - ${resp.body}');
      throw Exception('Không thể lấy thông tin nhân viên');
    }
  } catch (error) {
    print('Lỗi khi lấy thông tin nhân viên: $error');
    return null;
  }

}

Future<void> updateThongBaoTrangThai(int id, bool trangthai) async {
  try {
    // Tạo URL cho PUT request
    final url1 = Uri.http(urlapi, 'api/Thongbaos/updateThongBaoTrangThai/', {
      'id': id.toString(),
       'trangthai': trangthai.toString(),
    });

   print('Gửi request đến URL: $url');

    final resp = await http.patch(
      url1,
      headers: {
        'Accept': 'application/json',
      },
    );

    print('Response status code: ${resp.statusCode}');
    print('Response body: ${resp.body}');

    if (resp.statusCode == 200) {
      print('Cập nhật trạng thái thành công.');
    } else {
      print('Lỗi khi cập nhật trạng thái: ${resp.body}');
    }
  } catch (e) {
    print('Lỗi khi gọi API: $e');
  }
}

}
