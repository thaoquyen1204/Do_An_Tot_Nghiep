import 'package:flutter/widgets.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants.dart';
import 'package:flutter_login_api/models/chitietkpikhoaphong.dart';
import 'package:flutter_login_api/models/kpikhoaphong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlapi = url;

class Usuario_provider2 with ChangeNotifier {
  List<Kpikhoaphong> kpikhoaphong = [];
  List<ChitietKpiKP> chitietkpikhoaphong = [];
   List<ChitietKpiKP> chitietkpikhoaphongtheoMaChucDanh = [];

  Usuario_provider2() {
    getKpikhoaphong();
    getChitietkpikhoaphong();
  }
  String usuarioToJson(Kpikhoaphong kpikhoaphong) {
    Map<String, dynamic> data() => {
          "maPhieuKPICN": kpikhoaphong.maphieukpikhoaphong,
          "idBieuMau": kpikhoaphong.idbieumau,
          "maNV": kpikhoaphong.manv,
          "quyNam": kpikhoaphong.quynam, // Sẽ là null nếu không có giá trị
          "ngayLapPhieuKPICN": kpikhoaphong.ngaylapphieukpikhoaphong,
          "nguoiPheDuyetDDKKPI": kpikhoaphong.nguoipheduyetkpikhoaphong,
          "ngayPheDuyetDDKKPI": kpikhoaphong.ngaypheduyetkpikhoaphong,
          "trangThai": kpikhoaphong.trangthai,
          "maChucDanh": kpikhoaphong.machucdanh,
        };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  getKpikhoaphong() async {
    final url1 = Uri.http(urlapi, 'api/KPI_KhoaPhong');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonKpikhoaphong(resp.body);
    kpikhoaphong = response;
    notifyListeners();
  }

  Future<void> addKPIKhoaPhong(Kpikhoaphong kpikhoaphong) async {
    final url1 = Uri.http(urlapi, 'api/KPI_KhoaPhong');
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
            kpikhoaphong.toJson()), // Chuyển đổi đối tượng thành JSON
      );

      // In thử ra mã trạng thái và nội dung phản hồi từ API
      print('Response status: ${resp.statusCode}');
     // print('Response body: ${resp.body}');

      if (resp.statusCode == 201 || resp.statusCode == 200) {
        // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
        await getKpikhoaphong(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
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

  Future<void> updateKPIKhoaPhong(Kpikhoaphong kpikhoaphong) async {
  // Tạo URL cho PUT request
  final url1 = Uri.http(
      urlapi, 'api/KPI_KhoaPhong/${kpikhoaphong.maphieukpikhoaphong}');
  
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
    body: json.encode(kpikhoaphong.toJson()), // Chuyển đổi đối tượng thành JSON
  );

  // In ra mã trạng thái của phản hồi
  print('Response status code: ${resp.statusCode}');

  // Kiểm tra mã trạng thái
  if (resp.statusCode == 204) {
    // Cập nhật thành công
    print('KPI updated successfully.');
    
    // Gọi hàm để lấy lại dữ liệu
    getKpikhoaphong(); // Hoặc bạn có thể cập nhật thủ công danh sách usuarios
    notifyListeners();
  } else {
    // Xử lý lỗi nếu cần
    print('Failed to update KPI. Response: ${resp.body}');
    // throw Exception('Thất bại cập nhật KPI cá nhân');
  }
}


  Future<void> deleteKPIKhoaPhong(String maphieukpikhoaphong) async {
    final url1 = Uri.http(urlapi, 'api/KPI_KhoaPhong/$maphieukpikhoaphong');
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
        kpikhoaphong.removeWhere(
            (usuario) => usuario.maphieukpikhoaphong == maphieukpikhoaphong);
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
Future<Kpikhoaphong?> getKpikhoaphongByMaphieu(String maPhieu) async {
  final url = Uri.http(urlapi, 'api/KPI_KhoaPhong/getKpikhoaphongByMaphieu', {
    'maPhieu': maPhieu
  });
  print('Constructed URL: $url');
  
  final resp = await http.get(url, headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    'Content-type': 'application/json',
    'Accept': 'application/json'
  });



  if (resp.statusCode == 200) {
    try {
      List<dynamic> responseData = json.decode(resp.body);
      if (responseData.isNotEmpty) {
        // Trả về đối tượng đầu tiên trong danh sách
        return Kpikhoaphong.fromJson(responseData[0]); 
      } else {
        return null; // Nếu không có dữ liệu, trả về null
      }
    } catch (e) {
      // throw Exception('Failed to parse KPI details: ${e.toString()}');
    }
  } else {
    //throw Exception('Failed to load KPI details. Status code: ${resp.statusCode}, Response body: ${resp.body}');
  }
}
  // Gọi API tạo mã KPI
  Future<String?> getKpiCodeKP(DateTime date) async {
    final url1 = Uri.http(urlapi, 'api/Application/TaoMaKpiKP',
        {"ngay": date.toIso8601String().substring(0, 10)});
    try {
      final response = await http.get(url1);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        print('Lỗi: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi: $e');
      return null;
    }
  }

  Future<int> CheckNamPhieuKpiKP(int namphieu, String machucdanh) async {
    final url = Uri.http(urlapi, 'api/Application/CheckNamPhieuKP', {
      'namphieu': namphieu.toString(),
      'machucdanh': machucdanh,
    });
    try {
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        int trangThai = json.decode(resp.body); // Phản hồi là số nguyên
        return trangThai; // Trả về giá trị trạng thái nhận được từ API
      } else if (resp.statusCode == 404) {
        return -1; // Nếu không tìm thấy thì trả về -1
      } else {
         throw Exception(
             'Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (e) {
       throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI.');
    }
  }

//Chi tiết tieu chí mục tiêu bẹnh viện
  getChitietkpikhoaphong() async {
    final url1 = Uri.http(urlapi, 'api/ChiTietKPIKhoaPhongs');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonchitietKpikhoaphong(resp.body);
    chitietkpikhoaphong = response;
    notifyListeners();
  }

    getChitietkpikhoaphongbyMaCD(String maCD, int year) async {
   final url = Uri.http(
          urlapi, 'api/ChiTietKPIKhoaPhongs/GetChiTietKPIKKpByMCCDvaNam', {
        'maChucDanh': maCD.toString(),
        'Nam': year.toString(),
      });
    print(url);
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      // Kiểm tra mã trạng thái HTTP từ API
      if (resp.statusCode == 200) {
        try {
          List<dynamic> responseData = json.decode(resp.body);

          // Nếu API trả về một danh sách rỗng (không có dữ liệu cho năm/mã NV)
          if (responseData.isEmpty) {
          //   throw Exception(
          //       'Dữ liệu không tồn tại cho mã nhân viên và năm này.');
           }

          chitietkpikhoaphong =
              responseData.map((data) => ChitietKpiKP.fromJson(data)).toList();
          notifyListeners();
        } catch (e) {
          // throw Exception('Lỗi phân tích dữ liệu KPI: ${e.toString()}');
        }
      } else if (resp.statusCode == 404) {
        // Nếu mã trạng thái là 404, báo lỗi dữ liệu không tồn tại
        // throw Exception('Dữ liệu không tồn tại cho mã nhân viên và năm này.');
      } else {
        // Xử lý các lỗi khác từ API
        // throw Exception(
        //     'Không thể tải dữ liệu KPI. Mã trạng thái: ${resp.statusCode}, Nội dung phản hồi: ${resp.body}');
      }
    }
    void setChitietkpikhoaphong(List<ChitietKpiKP> newKpiDetails) {
    chitietkpikhoaphongtheoMaChucDanh = newKpiDetails;
    notifyListeners(); // Thông báo cho tất cả listeners để UI được cập nhật
  }
  String usuarioToJson1(ChitietKpiKP chitietKpiKP) {
    Map<String, dynamic> data() => {
          "maPhieuKPIKP": chitietKpiKP.maphieukpikhoaphong,
          "maKPI": chitietKpiKP.makpi,
          "noiDungKPIKP": chitietKpiKP.noidungkpikhoaphong,
          "nguonChungMinh": chitietKpiKP.nguonchungminh,
          "tieuChiDanhGiaKQ": chitietKpiKP.tieuchidanhgiaketqua,
          "keHoach": chitietKpiKP.kehoach,
          "trongSoKPIKP": chitietKpiKP.trongsokpikhoaphong,
        };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

Future<void> addChitietKPIKP(ChitietKpiKP chitietKpiKP) async {
  final url1 = Uri.http(urlapi, 'api/ChiTietKPIKhoaPhongs');

  // In ra URL
  print('Sending data to URL: $url1');

  // In ra JSON gửi đi
  final jsonBody = jsonEncode(chitietKpiKP.toJson());
  print('JSON Body: $jsonBody');

  try {
    final resp = await http.post(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonBody, // Chuyển đổi thành JSON
    );

    // In ra mã trạng thái phản hồi từ server
    print('Response status code: ${resp.statusCode}');

    // In ra body của phản hồi từ server
    print('Response body: ${resp.body}');

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      print('KPI added successfully');
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      await getChitietkpikhoaphong(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      print('Failed to add KPI: ${resp.body}');
      throw Exception('Failed to add KPI: ${resp.body}');
    }
  } catch (e) {
    // In ra lỗi khi gửi dữ liệu
    print('Error when adding KPI: $e');
    throw Exception('Error when adding KPI: $e');
  }
}


  Future<void> deletecchitietKPIKhoaPhong(String maphieukpikhoaphong) async {
    final url1 =
        Uri.http(urlapi, 'api/ChiTietKPIKhoaPhongs/$maphieukpikhoaphong');

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

      // In ra để kiểm tra mã trạng thái phản hồi từ server
     // print('Mã trạng thái phản hồi: ${resp.statusCode}');

      if (resp.statusCode == 204) {
        // Xóa thành công, cập nhật lại danh sách
        chitietkpikhoaphong.removeWhere(
            (usuario) => usuario.maphieukpikhoaphong == maphieukpikhoaphong);

        notifyListeners();
      } else {
        // In ra lỗi nếu mã trạng thái không phải 204
        print('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
        // throw Exception('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (error) {
      // In ra lỗi nếu có ngoại lệ xảy ra
       print('Lỗi khi xóa chi tiết KPI: $error');
      // throw Exception('Xảy ra lỗi trong quá trình xóa KPI.');
    }
  }
    Future<void> ChiTietKPIKPByMaCDvaNam(String maCD, int year) async {
      final url = Uri.http(
          urlapi, 'api/ChiTietKPIKhoaPhongs/GetChiTietKPIKKpByMCCDvaNam', {
        'maChucDanh': maCD,
        'Nam': year.toString(),
      });
      print(url);
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      // Kiểm tra mã trạng thái HTTP từ API
      if (resp.statusCode == 200) {
        try {
          List<dynamic> responseData = json.decode(resp.body);

          // Nếu API trả về một danh sách rỗng (không có dữ liệu cho năm/mã NV)
          if (responseData.isEmpty) {
          //   throw Exception(
          //       'Dữ liệu không tồn tại cho mã nhân viên và năm này.');
           }

          chitietkpikhoaphong =
              responseData.map((data) => ChitietKpiKP.fromJson(data)).toList();
          notifyListeners();
        } catch (e) {
          // throw Exception('Lỗi phân tích dữ liệu KPI: ${e.toString()}');
        }
      } else if (resp.statusCode == 404) {
        // Nếu mã trạng thái là 404, báo lỗi dữ liệu không tồn tại
        // throw Exception('Dữ liệu không tồn tại cho mã nhân viên và năm này.');
      } else {
        // Xử lý các lỗi khác từ API
        // throw Exception(
        //     'Không thể tải dữ liệu KPI. Mã trạng thái: ${resp.statusCode}, Nội dung phản hồi: ${resp.body}');
      }
    }
  String? GetChiTietKPIKKpByMCCDvaNam(String machucdanh, int Nam) {

  try {
    final Kpikhoaphong = kpikhoaphong.firstWhere((user) => user.machucdanh == machucdanh && user.quynam ==Nam);

    if (Kpikhoaphong.maphieukpikhoaphong != null && Kpikhoaphong.maphieukpikhoaphong!.isNotEmpty) {
      return Kpikhoaphong.maphieukpikhoaphong;
    } else {
      return 'Không có mã phiếu hoặc mã phiếu chưa xác định';
    }
  } catch (e) {
    // In thông báo lỗi nếu không tìm thấy nhân viên
    // return 'Không tìm thấy mã phiếu';
  }
}


}
