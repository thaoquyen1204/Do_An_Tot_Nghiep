// ignore_for_file: avoid_print

import 'package:flutter/widgets.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants.dart';
import 'package:flutter_login_api/models/chitietkpicanhannv.dart';
import 'package:flutter_login_api/models/chitiettieuchimuctieubv.dart';
import 'package:flutter_login_api/models/kpibenhvien.dart';
import 'package:flutter_login_api/models/kpicanhan.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlapi = url;

class Usuario_provider1 with ChangeNotifier {
  List<Kpibenhvien> kpibenhvien = [];
  List<ChiTietTieuChiMucTieuBV> chitiettieuchimuctieuBV = [];
  List<Kpicanhan> kpicanhan = [];
  List<ChiTietKPICaNhanNV> chitiietkpicanhan = [];

  Usuario_provider1() {
    getKpibenhvien();
    getTieuchimuctieubv();
    getKpicn();
  }
  String usuarioToJson(Kpibenhvien kpibenhvien) {
    final Map<String, dynamic> data = {
      "maPhieuKPIBV": kpibenhvien.maphieukpibenhvien,
      "namPhieu": kpibenhvien.namphieu,
      "nguoiLap": kpibenhvien.nguoilap,
      "nguoiPheDuyet": kpibenhvien.nguoipheduyet,
      "ngayLapPhieuKPIBV": kpibenhvien.ngaylapphieukpibv,
      "ngayPheDuyet": kpibenhvien.ngaypheduyet,
      "idBieuMau": kpibenhvien.idbieumau,
      "trangThai": kpibenhvien.trangthai,
      "tenBieuMau": kpibenhvien.tenbieumau,
    };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  getKpibenhvien() async {
    final url1 = Uri.http(urlapi, 'api/KPIBenhViens/KpiBenhVienBM');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonKpibenhvien(resp.body);
    kpibenhvien = response;
    notifyListeners();
  }

  Future<void> addKPIBenhVien(Kpibenhvien kpibenhvien) async {
    final url1 = Uri.http(urlapi, 'api/KPIBenhViens');
    final resp = await http.post(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(kpibenhvien.toJson()), // Chuyển đổi đối tượng thành JSON
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      await getKpibenhvien(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to add usuario: ${resp.body}');
    }
  }

  Future<void> updateKPIBenhVien(Kpibenhvien kpibenhvien) async {
    final url1 =
        Uri.http(urlapi, 'api/KPIBenhViens/${kpibenhvien.maphieukpibenhvien}');

    // Thay đổi hàm chuyển đổi JSON chỉ chuyển đổi đối tượng đơn lẻ, không phải danh sách
    final resp = await http.put(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body:
          json.encode(kpibenhvien.toJson()), // Chuyển đổi đối tượng thành JSON
    );

    if (resp.statusCode == 204) {
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      getKpibenhvien(); // Hoặc bạn có thể cập nhật thủ công danh sách usuarios
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Thất bại cập nhật KPI cá nhân');
    }
  }

  Future<void> deleteKPIBenhVien(String maphieukpibenhvien) async {
    final url1 = Uri.http(urlapi, 'api/KPIBenhViens/$maphieukpibenhvien');
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
        kpibenhvien.removeWhere(
            (usuario) => usuario.maphieukpibenhvien == maphieukpibenhvien);
        notifyListeners();
      } else {
        // Xử lý lỗi nếu cần
        throw Exception(
            'Failed to delete usuario. Status code: ${resp.statusCode}');
      }
    } catch (error) {
      print('Error deleting usuario: $error');
      // Có thể thêm thông báo lỗi cho người dùng ở đây
      throw Exception('An error occurred while deleting usuario.');
    }
  }

  Future<int> CheckNamPhieuKpiBV(int year) async {
    final url = Uri.http(urlapi, 'api/Application/CheckNamPhieuAsync', {
      'namphieu': year.toString(),
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
      throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI5.');
    }
  }

  // Gọi API tạo mã KPI
  Future<String?> getKpiCode(DateTime date) async {
    final url1 = Uri.http(urlapi, 'api/Application/TaoMaKpi',
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

  Future<Kpibenhvien?> getKpibenhvienByMaphieu(String maPhieu) async {
    final url = Uri.http(urlapi, 'api/KPIBenhViens/getKpibenhvienByMaphieu',
        {'maPhieu': maPhieu});

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
          return Kpibenhvien.fromJson(responseData[0]);
        } else {
          return null; // Nếu không có dữ liệu, trả về null
        }
      } catch (e) {
        throw Exception('Failed to parse KPI details: ${e.toString()}');
      }
    } else {
      throw Exception('Failed to load KPI details.');
    }
  }

  Future<int> KPIBVTTByNam(int year) async {
    final url = Uri.http(urlapi, 'api/KPIBenhViens/GetKPIBVTTByNam', {
      'Nam': year.toString(),
    });

    try {
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        // Giả sử phản hồi chứa một giá trị duy nhất (trạng thái)
        int trangThai = json.decode(resp.body);
        return trangThai; // Thêm câu lệnh return để trả về trạng thái
      } else if (resp.statusCode == 404) {
        return -1; // Hoặc giá trị nào đó để biểu thị không tìm thấy
      } else {
        throw Exception(
            'Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI6.');
    }
  }

  String? getMaphieuKpiBvByNam(int nam) {
    try {
      final Kpibenhvien =
          kpibenhvien.firstWhere((user) => user.namphieu == nam);

      if (Kpibenhvien.maphieukpibenhvien != null &&
          Kpibenhvien.maphieukpibenhvien!.isNotEmpty) {
        return Kpibenhvien.maphieukpibenhvien;
      } else {
        return 'Không có mã phiếu hoặc mã phiếu chưa xác định';
      }
    } catch (e) {
      // In thông báo lỗi nếu không tìm thấy nhân viên
      return 'Không tìm thấy mã phiếu';
    }
  }

//Chi tiết tieu chí mục tiêu bẹnh viện
  getTieuchimuctieubv() async {
    final url1 = Uri.http(urlapi, 'api/ChiTietTieuChiMucTieuBVs');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonChiTietTieuChiMucTieuBV(resp.body);
    chitiettieuchimuctieuBV = response;
    notifyListeners();
  }

  String usuarioToJson1(ChiTietTieuChiMucTieuBV chitiettieuchimuctieuBV) {
    final Map<String, dynamic> data = {
      "maKPI": chitiettieuchimuctieuBV.makpi,
      "noiDungKPI": chitiettieuchimuctieuBV.noidungkpi,
      "keHoach": chitiettieuchimuctieuBV.kehoach,
      "trongSoKPIBV": chitiettieuchimuctieuBV.trongsokpibv,
      "maPhieuKPIBV": chitiettieuchimuctieuBV.maphieukpibenhvien,
      "tieuChiID": chitiettieuchimuctieuBV.tieuchiid,
      "congViecCaNhanBV": chitiettieuchimuctieuBV.congvieccanhanbv,
    };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  String fixJsonResponse(String response) {
    return response.replaceAllMapped(
      RegExp(r'(\w+):'),
      (match) => '"${match.group(1)}":',
    );
  }

  Future<void> addTieuchimuctieubv(
      ChiTietTieuChiMucTieuBV chitiettieuchimuctieuBV) async {
    final url1 = Uri.http(urlapi, 'api/ChiTietTieuChiMucTieuBVs');
    final resp = await http.post(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(chitiettieuchimuctieuBV.toJson()),
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      await getTieuchimuctieubv(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to add usuario: ${resp.body}');
    }
  }

  ChiTietKPIBVByNam(int year) async {
    final url =
        Uri.http(urlapi, 'api/ChiTietTieuChiMucTieuBVs/GetChiTietKPIBVByNam', {
      'Nam': year.toString(),
    });

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
          throw Exception(
              'Dữ liệu không tồn tại cho mã khoa phòng và năm này.');
        }

        chitiettieuchimuctieuBV = responseData
            .map((data) => ChiTietTieuChiMucTieuBV.fromJson(data))
            .toList();
        notifyListeners();
      } catch (e) {
        throw Exception('Lỗi phân tích dữ liệu KPI: ${e.toString()}');
      }
    } else if (resp.statusCode == 404) {
      // Nếu mã trạng thái là 404, báo lỗi dữ liệu không tồn tại
      throw Exception('Dữ liệu không tồn tại cho khoa phòng vào năm này.');
    } else {
      // Xử lý các lỗi khác từ API
      throw Exception(
          'Không thể tải dữ liệu KPI. Mã trạng thái: ${resp.statusCode}, Nội dung phản hồi: ${resp.body}');
    }
  }

  Future<void> deletecchitietKPIBenhVien(String maphieukpibenhvien) async {
    final url1 =
        Uri.http(urlapi, 'api/ChiTietTieuChiMucTieuBVs/$maphieukpibenhvien');

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
      print('Mã trạng thái phản hồi: ${resp.statusCode}');

      if (resp.statusCode == 204) {
        // Xóa thành công, cập nhật lại danh sách
        chitiettieuchimuctieuBV.removeWhere(
            (usuario) => usuario.maphieukpibenhvien == maphieukpibenhvien);

        notifyListeners();
      } else {
        // In ra lỗi nếu mã trạng thái không phải 204
        print('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
        throw Exception('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (error) {
      // In ra lỗi nếu có ngoại lệ xảy ra
      print('Lỗi khi xóa chi tiết KPI: $error');
      throw Exception('Xảy ra lỗi trong quá trình xóa KPI.');
    }
  }

//Cá nhân

  Future<String?> getKpiCodeCN(DateTime date) async {
    final url1 = Uri.http(urlapi, 'api/Application/TaoMaKpiCN',
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

  getKpicn() async {
    final url1 = Uri.http(urlapi, 'api/KPI_CaNhan');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonKpicanhan(resp.body);
    kpicanhan = response;
    notifyListeners();
  }

  String usuarioToJsonCN(Kpicanhan kpicanhan) {
    final Map<String, dynamic> data = {
      "maPhieuKPICN": kpicanhan.maphieukpicanhan,
      "idBieuMau": kpicanhan.idbieumau,
      "maNV": kpicanhan.manv,
      "quyNam": kpicanhan.quynam, // Sẽ là null nếu không có giá trị
      "ngayLapPhieuKPICN": kpicanhan.ngaylapphieukpicanhan,
      // if (ngaypheduyet != null) "ngayPheDuyet": ngaypheduyet!.toIso8601String(), // Sẽ gửi null nếu không có giá trị
      "nguoiPheDuyetDDKKPI": kpicanhan.nguoipheduyetkpicanhan,
      "ngayPheDuyetDDKKPI": kpicanhan.ngaypheduyetkpicanhan,
      "trangThai": kpicanhan.trangthai,
    };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  Future<void> addKPICaNhan(Kpicanhan kpicanhan) async {
    final url1 = Uri.http(urlapi, 'api/KPI_CaNhan');
    final resp = await http.post(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(kpicanhan.toJson()), // Chuyển đổi đối tượng thành JSON
    );

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      getKpicn(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to add usuario: ${resp.body}');
    }
  }

  Future<void> updateKPICaNhan(Kpicanhan kpicanhan) async {
    final url1 =
        Uri.http(urlapi, 'api/KPI_CaNhan/${kpicanhan.maphieukpicanhan}');

    print('URL gọi API: $url1');

    // Kiểm tra dữ liệu trước khi gửi
    final requestBody = json.encode(kpicanhan.toJson());
    print('Dữ liệu JSON gửi lên: $requestBody');

    try {
      final resp = await http.put(
        url1,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: requestBody,
      );

      print('Status code: ${resp.statusCode}');
      print('Response body: ${resp.body}');

      if (resp.statusCode == 204) {
        print('Cập nhật KPI thành công');
        getKpicn(); // Gọi lại hàm lấy dữ liệu
        notifyListeners();
      } else {
        throw Exception(
            'Thất bại cập nhật KPI cá nhân, mã lỗi: ${resp.statusCode}');
      }
    } catch (e) {
      print('Lỗi xảy ra: $e');
      rethrow;
    }
  }

  Future<Kpicanhan?> getKpicanhanByMaphieu(String maPhieu) async {
    final url = Uri.http(
        urlapi, 'api/KPI_CaNhan/getKpicanhanByMaphieu', {'maPhieu': maPhieu});
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
          return Kpicanhan.fromJson(responseData[0]);
        } else {
          return null; // Nếu không có dữ liệu, trả về null
        }
      } catch (e) {
        throw Exception('Failed to parse KPI details: ${e.toString()}');
      }
    } else {
      throw Exception(
          'Failed to load KPI details. Status code: ${resp.statusCode}, Response body: ${resp.body}');
    }
  }

  Future<int> KPICNTTByMaNVvaNam(String maNV, int year) async {
    final url = Uri.http(urlapi, 'api/KPI_CaNhan/GetKPICNTTByMaNVvaNam', {
      'maNV': maNV,
      'Nam': year.toString(),
    });

    try {
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        // Giả sử phản hồi chứa một giá trị duy nhất (trạng thái)
        int trangThai = json.decode(resp.body);
        print('Trang Thai: $trangThai'); // Xử lý trạng thái như cần thiết
        return trangThai; // Thêm câu lệnh return để trả về trạng thái
      } else if (resp.statusCode == 404) {
        print('Không tìm thấy trạng thái cho maNV: $maNV trong năm: $year');
        return -1; // Hoặc giá trị nào đó để biểu thị không tìm thấy
      } else {
        throw Exception(
            'Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (e) {
      print('Lỗi khi lấy trạng thái KPI: $e');
      throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI7.');
    }
  }

  Future<int> CheckNamPhieuKpiCN(int namphieu, String manv) async {
    final url = Uri.http(urlapi, 'api/Application/CheckNamPhieuNV', {
      'namphieu': namphieu.toString(),
      'manv': manv,
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
      throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI8.');
    }
  }

  String? getMaphieuKpCNByNamandMaNV(int nam, String manv) {
    try {
      final Kpicanhan = kpicanhan
          .firstWhere((user) => user.quynam == nam && user.manv == manv);

      if (Kpicanhan.maphieukpicanhan != null &&
          Kpicanhan.maphieukpicanhan!.isNotEmpty) {
        return Kpicanhan.maphieukpicanhan;
      } else {
        return 'Không có mã phiếu hoặc mã phiếu chưa xác định';
      }
    } catch (e) {
      // In thông báo lỗi nếu không tìm thấy nhân viên
      return 'Không tìm thấy mã phiếu';
    }
  }

  // chi tiết kpi cá nhân
  getTieuchimuctieuCN() async {
    final url1 = Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJsonChiTietKpiCaNhan(resp.body);
    chitiietkpicanhan = response;
    notifyListeners();
  }

  String usuarioToJsonchitietkpicanhan(ChiTietKPICaNhanNV chiTietKPICaNhanNV) {
    final Map<String, dynamic> data = {
      // "stt":chiTietKPICaNhanNV.stt,
      "maPhieuKPICN": chiTietKPICaNhanNV.maphieukpicanhan,
      "maKPI": chiTietKPICaNhanNV.makpi,
      "noiDungKPICN": chiTietKPICaNhanNV.noidungkpicanhan,
      "nguonChungMinh": chiTietKPICaNhanNV.nguonchungminh,
      "tieuChiDanhGiaKQ": chiTietKPICaNhanNV.tieuchidanhgiaketqua,
      "keHoach": chiTietKPICaNhanNV.kehoach,
      "trongSoKPICN": chiTietKPICaNhanNV.trongsokpicanhan,
      "thucHien": chiTietKPICaNhanNV.thuchien,
      "tyLeHoanThanh": chiTietKPICaNhanNV.tylehoanthanh,
      "ketQua": chiTietKPICaNhanNV.ketqua,
    };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }

  Future<void> addTieuchikpicanhan(
      ChiTietKPICaNhanNV chiTietKPICaNhanNV) async {
    final url1 = Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs');
    final resp = await http.post(
      url1,
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(chiTietKPICaNhanNV.toJson()),
    );

    print('Response status: ${resp.statusCode}');
    print('Response body: ${resp.body}');

    if (resp.statusCode == 201 || resp.statusCode == 200) {
      // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
      await getKpibenhvien(); // Hoặc bạn có thể cập nhật thủ công danh sách kpi
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to add usuario: ${resp.body}');
    }
  }

  Future<void> ChiTietKPICNByMaNVvaNam(String maNV, int year) async {
    final url =
        Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs/GetChiTietKPICNByMaNVvaNam', {
      'maNV': maNV,
      'Nam': year.toString(),
    });

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

        // In dữ liệu lấy được từ API
        print('Dữ liệu trả về từ API: $responseData');

        // Nếu API trả về một danh sách rỗng (không có dữ liệu cho năm/mã NV)
        if (responseData.isEmpty) {
          throw Exception(
              'Dữ liệu không tồn tại cho mã nhân viên và năm này1.');
        }

        chitiietkpicanhan = responseData
            .map((data) => ChiTietKPICaNhanNV.fromJson(data))
            .toList();
        notifyListeners();
      } catch (e) {
        throw Exception('Lỗi phân tích dữ liệu KPI: ${e.toString()}');
      }
    } else if (resp.statusCode == 404) {
      // Nếu mã trạng thái là 404, báo lỗi dữ liệu không tồn tại
      throw Exception('Dữ liệu không tồn tại cho mã nhân viên và năm này2.');
    } else {
      // Xử lý các lỗi khác từ API
      throw Exception(
          'Không thể tải dữ liệu KPI. Mã trạng thái: ${resp.statusCode}, Nội dung phản hồi: ${resp.body}');
    }
  }

  Future<void> ChiTietKPICNByMaNVvaNamAll(String maNV, int year) async {
    final url = Uri.http(
        urlapi, 'api/ChiTietKPICaNhanNVs/GetChiTietKPICNByMaNVvaNamAll', {
      'maNV': maNV,
      'Nam': year.toString(),
    });

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

        // In dữ liệu lấy được từ API
        print('Dữ liệu trả về từ API: $responseData');

        // Nếu API trả về một danh sách rỗng (không có dữ liệu cho năm/mã NV)
        if (responseData.isEmpty) {
          throw Exception(
              'Dữ liệu không tồn tại cho mã nhân viên và năm này3.');
        }

        chitiietkpicanhan = responseData
            .map((data) => ChiTietKPICaNhanNV.fromJson(data))
            .toList();
        notifyListeners();
      } catch (e) {
        throw Exception('Lỗi phân tích dữ liệu KPI: ${e.toString()}');
      }
    } else if (resp.statusCode == 404) {
      // Nếu mã trạng thái là 404, báo lỗi dữ liệu không tồn tại
      throw Exception('Dữ liệu không tồn tại cho mã nhân viên và năm này4.');
    } else {
      // Xử lý các lỗi khác từ API
      throw Exception(
          'Không thể tải dữ liệu KPI. Mã trạng thái: ${resp.statusCode}, Nội dung phản hồi: ${resp.body}');
    }
  }

 Future<double> GetTyLeHoanThanhByMaNVvaNam(String maNV, int year) async {
  final url = Uri.http(
      urlapi, 'api/ChiTietKPICaNhanNVs/GetTyLeHoanThanhByMaNVvaNam', {
    'maNV': maNV,
    'Nam': year.toString(),
  });

  try {
    print("URL: $url"); // Log URL
    final resp = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });

    print("HTTP status: ${resp.statusCode}"); // Log status code

    if (resp.statusCode == 200) {
      print("Phản hồi: ${resp.body}"); // Log phản hồi từ API
      final data = json.decode(resp.body);
      return data is double ? data : (data as num).toDouble(); // Chuyển đổi chính xác
    } else if (resp.statusCode == 404) {
      print("Không tìm thấy dữ liệu cho maNV: $maNV, năm: $year");
      return -1.0; // Trả về giá trị mặc định nếu không tìm thấy
    } else {
      throw Exception(
          'Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
    }
  } catch (e) {
    print("Lỗi khi gọi API: $e"); // Log lỗi
    throw Exception('Đã xảy ra lỗi trong khi lấy tỷ lệ hoàn thành.');
  }
}


  Future<void> deleteKPICaNhan(String maphieukpicanhan) async {
    final url1 = Uri.http(urlapi, 'api/KPI_CaNhan/$maphieukpicanhan');
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
        kpicanhan.removeWhere(
            (usuario) => usuario.maphieukpicanhan == maphieukpicanhan);
        notifyListeners();
      } else {
        // Xử lý lỗi nếu cần
        throw Exception(
            'Failed to delete usuario. Status code: ${resp.statusCode}');
      }
    } catch (error) {
      print('Error deleting usuario: $error');
      // Có thể thêm thông báo lỗi cho người dùng ở đây
      throw Exception('An error occurred while deleting usuario.');
    }
  }

  Future<void> deletecchitietKPICaNhan(String maphieukpicanhan) async {
    final url1 = Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs/$maphieukpicanhan');
    print("đường dẫn:$url1");
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
      print('Mã trạng thái phản hồi: ${resp.statusCode}');

      if (resp.statusCode == 204) {
        // Xóa thành công, cập nhật lại danh sách
        chitiietkpicanhan.removeWhere(
            (usuario) => usuario.maphieukpicanhan == maphieukpicanhan);

        notifyListeners();
      } else {
        // In ra lỗi nếu mã trạng thái không phải 204
        print('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
        throw Exception('Xóa thất bại. Mã trạng thái: ${resp.statusCode}');
      }
    } catch (error) {
      // In ra lỗi nếu có ngoại lệ xảy ra
      print('Lỗi khi xóa chi tiết KPI: $error');
      throw Exception('Xảy ra lỗi trong quá trình xóa KPI.');
    }
  }

  Future<void> updateChiTietKPICaNhan(
      ChiTietKPICaNhanNV chitietkpicanhan) async {
    final url1 = Uri.http(
      urlapi,
      'api/ChiTietKPICaNhanNVs/${chitietkpicanhan.stt}',
    );
    print("URL: $url1"); // In URL để kiểm tra

    // Chuyển đổi đối tượng thành JSON và in ra để xem dữ liệu trước khi gửi
    final jsonData = json.encode(chitietkpicanhan.toJson());
    print("JSON Body: $jsonData");

    try {
      final resp = await http.put(
        url1,
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Credentials": "true",
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonData, // Dữ liệu JSON
      );

      print("Response status: ${resp.statusCode}");
      print("Response body: ${resp.body}");

      if (resp.statusCode == 204) {
        print("Update successful."); // In ra nếu thành công
        getKpicn(); // Lấy lại danh sách KPI hoặc cập nhật thủ công danh sách
        notifyListeners();
      } else {
        // Xử lý lỗi nếu mã trạng thái không phải 204
        print("Failed to update, status code: ${resp.statusCode}");
        throw Exception('Thất bại cập nhật KPI cá nhân');
      }
    } catch (e) {
      print("Error: $e"); // In lỗi nếu xảy ra ngoại lệ
    }
  }

  Future<ChiTietKPICaNhanNV?> getChiTietKpicanhanByMaphieu(int stt) async {
    final url = Uri.http(
        urlapi, 'api/ChiTietKPICaNhanNVs/getChitietKpicanhanByMaphieu', {
      'stt': stt.toString(),
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
          return ChiTietKPICaNhanNV.fromJson(responseData[0]);
        } else {
          return null; // Nếu không có dữ liệu, trả về null
        }
      } catch (e) {
        throw Exception('Failed to parse KPI details: ${e.toString()}');
      }
    } else {
      throw Exception(
          'Failed to load KPI details. Status code: ${resp.statusCode}, Response body: ${resp.body}');
    }
  }

  Future<int> GetidByMaPhieuandMaKPI(String maPhieu, int MaKPI) async {
    final url =
        Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs/GetidByMaPhieuandMaKPI', {
      'maPhieu': maPhieu,
      'MaKPI': MaKPI.toString(),
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
      throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI10.');
    }
  }

  Future<int> GetDemChiTietKPICNByMaNVvaNam(String maNV, int Nam) async {
    final url = Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs/GetDemChiTietKPICNByMaNVvaNam', {
      'maNV': maNV.toString(),
        'Nam': Nam.toString(),
    });
    try {
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        int count = json.decode(resp.body); // Phản hồi là số nguyên
        return count; // Trả về giá trị trạng thái nhận được từ API
      } else if (resp.statusCode == 404) {
        return -1; // Nếu không tìm thấy thì trả về -1
      } else {
        throw Exception(
            'Không thể tải chi tiết KPI. Mã số đếm: ${resp.statusCode}');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi trong khi lấy số đếm .');
    }
  }
  Future<int> GetDemChiTietKPICNByMaNVvaNamHT(String maNV, int Nam) async {
    final url = Uri.http(urlapi, 'api/ChiTietKPICaNhanNVs/GetDemChiTietKPICNByMaNVvaNamHT', {
      'maNV': maNV.toString(),
        'Nam': Nam.toString(),
    });
    try {
      final resp = await http.get(url, headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Credentials": "true",
        'Content-type': 'application/json',
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        int count = json.decode(resp.body); // Phản hồi là số nguyên
        return count; // Trả về giá trị trạng thái nhận được từ API
      } else if (resp.statusCode == 404) {
        return -1; // Nếu không tìm thấy thì trả về -1
      } else {
        throw Exception(
            'Không thể tải chi tiết KPI. Mã số đếm: ${resp.statusCode}');
      }
    } catch (e) {
      throw Exception('Đã xảy ra lỗi trong khi lấy số đếm HT.');
    }
  }
}
