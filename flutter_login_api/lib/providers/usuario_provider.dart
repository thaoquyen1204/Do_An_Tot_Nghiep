import 'package:flutter/widgets.dart';
import 'package:flutter_login_api/models/kpiphongcntt.dart';
import 'package:flutter_login_api/models/modelchucdanh.dart';
import 'package:flutter_login_api/models/usuario.dart';
import 'package:flutter_login_api/models/usuario1.dart';
import 'package:flutter_login_api/mausacvakichthuoc/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const urlapi = url;
class Usuario_provider with ChangeNotifier{
  List<Usuario> usuarios =[];
  List<Usuario1> usuarios1 =[];
  List<Kpiphongcntt> kpicntt =[];
    List<KPIGroupByChucVu> kpicnttbycv =[];
  List<ChucDanh> chucdanh =[];
  Usuario_provider(){
    getUsuarios();
    getUsuarios1();
    getKpiPhongKhoa();
    getChucdanh();
    GetKPIByCVCN();
    getNhanVien();
    getNhanVienAll();
  }
  // bảng người dùng
  String usuarioToJson(Usuario usuario) {
    final Map<String, dynamic> data = {
      'maNv': usuario.maNv,
      'tenNv': usuario.tenNv,
      'maChucDanh': usuario.maChucDanh,
      "hinhAnhNV": usuario.hinhAnhNv,
      "sdt": usuario.sdt,
      "gmail":usuario. gmail,
      "tenTaiKhoan": usuario.tenTaiKhoan,
      "matKhau": usuario.matKhau,
      "maPhongKhoa": usuario.maPhongKhoa,
      // ignore: equal_keys_in_map
      "maChucDanh":usuario.maChucDanh,
      "maQuyen": usuario.maQuyen,
      // "maCapDoKPIBenhVien": usuario.maCapDoKpiBenhVien,
      "quyenTruyCap": usuario.quyenTruyCap,
      //"maChucNang": usuario.maChucNang,
      // Add other fields if needed
    };
    return jsonEncode(data); // Chuyển đổi user object thành  JSON
  }
  getUsuarios() async{
    final url1 = Uri.http(urlapi,'api/NguoiDung');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response = usuarioFromJson(resp.body);
    usuarios = response;
    notifyListeners();
  }
// Hàm lấy tên nhân viên theo mã
String getEmployeeNameByMaNV(String maNV) {
  try {
    print("Danh sách nhân viên hiện tại:");
    for (var user in usuarios) {
      print("Mã NV: ${user.maNv}, Tên NV: ${user.tenNv}");
    }
    
    print("Đang tìm kiếm mã nhân viên: $maNV");
    final usuario = usuarios.firstWhere((user) {
      print("Đang kiểm tra: ${user.maNv}");
      return user.maNv == maNV;
    });
    
    print("Tìm thấy nhân viên: ${usuario.tenNv}");
    return usuario.tenNv;
  } catch (e) {
    print("Không tìm thấy mã nhân viên: $maNV");
    return 'Không tìm thấy nhân viên';
  }
}

  // Hàm lấy quyen nhân viên theo mã
// String? getEmployeeQuyenByMaNV(String maNV) {

//   try {
//     final usuario = usuarios.firstWhere((user) => user.maNv == maNV);

//     // Nếu tìm thấy và quyền không phải null
//     if (usuario.maQuyen != null && usuario.maQuyen!.isNotEmpty) {
//       return usuario.maQuyen;
//     } else {
//       return 'Không có quyền hoặc quyền chưa xác định';
//     }
//   } catch (e) {
//     // In thông báo lỗi nếu không tìm thấy nhân viên
//     return 'Không tìm thấy nhân viên';
//   }
// }
Future<String> getEmployeeQuyenByMaNV(String MaNV) async {
  final url = Uri.http(urlapi, 'api/NguoiDung/GetMaQuyenByMaNV', {
    'MaNV': MaNV,
  });
  try {
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      String maQuyen = json.decode(resp.body); // Phản hồi là số nguyên
      return maQuyen; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải chi tiết KPI. Mã quyền: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy quyền.');
  }
}
Future<String> GetMaNVByEmail(String gmail) async {
  final url = Uri.http(urlapi, 'api/NguoiDung/getMaNVByEmail', {
    'gmail': gmail,
  });
  try {
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      String maNV = json.decode(resp.body); // Phản hồi là số nguyên
      return maNV; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI1.');
  }
}

Future<String> getChucDanhByEmail(String gmail) async {
  final url = Uri.http(urlapi, 'api/NguoiDung/getChucDanhByEmail', {
    'gmail': gmail,
  });
  try {
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      String maNV = json.decode(resp.body); // Phản hồi là số nguyên
      return maNV; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải chi tiết KPI. Mã trạng thái: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI2.');
  }
}
Future<String> getNameByMaND(String manv) async {
  final url = Uri.http(urlapi, 'api/NguoiDung/getNameByMaND', {
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
      String maNV = json.decode(resp.body); // Phản hồi là số nguyên
      return maNV; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải tên: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy tên KPI.');
  }
}


getNhanVien() async {
  final url1 = Uri.http(urlapi, 'api/NguoiDung');
  final resp = await http.get(url1, headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    'Content-type': 'application/json',
    'Accept': 'application/json'
  });

  if (resp.statusCode == 200) {
    // Parse dữ liệu từ API
    final response = usuarioFromJson(resp.body);
    // Lọc chỉ những người có maQuyen = 'NV'
    usuarios = response.where((usuario) => usuario.maQuyen == 'NV').toList();
    //usuarios = response.where((usuario) => usuario.maQuyen == 'NV' || usuario.maQuyen == 'TKP').toList();

    //print("Data fetched successfully: ${usuarios.length} NV users found.");
    //print(resp.body);  
  } else {
    print("Failed to fetch data. Status code: ${resp.statusCode}");
  }

  notifyListeners();
}

getNhanVienAll() async {
  final url1 = Uri.http(urlapi, 'api/NguoiDung');
  final resp = await http.get(url1, headers: {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Credentials": "true",
    'Content-type': 'application/json',
    'Accept': 'application/json'
  });

  if (resp.statusCode == 200) {
    // Parse dữ liệu từ API
    final response = usuarioFromJson(resp.body);
    // Lọc chỉ những người có maQuyen = 'NV'
    usuarios = response.where((usuario) => usuario.maQuyen == 'NV' || usuario.maQuyen == 'TKP'|| usuario.maQuyen == 'PKP').toList();

    //print("Data fetched successfully: ${usuarios.length} NV users found.");
    //print(resp.body);  
  } else {
    print("Failed to fetch data. Status code: ${resp.statusCode}");
  }

  notifyListeners();
}
//Đang làm
Future<Usuario?> getNhanVienByMaNv(String maNv) async {
  try {
    final url1 = Uri.http(urlapi, 'api/NguoiDung/getUserByMaNV/', {
      'MaNV': maNv,
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

      if (jsonData.isNotEmpty) {
        // Trả về đối tượng `Usuario` đầu tiên từ danh sách
        return Usuario.fromJson(jsonData[0]);
      } else {
        return null; // Không tìm thấy nhân viên
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




  Future<void> addUsuario( Usuario usuario) async {
  final url1 = Uri.http(urlapi, 'api/NguoiDung');
  final resp = await http.post(
    url1,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    },
    body: usuarioToJson(usuario),
   // body: usuarioToJson(usuario), // Chuyển đổi đối tượng thành JSON
  );

   if (resp.statusCode == 201 || resp.statusCode == 200) {
    // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
    await getUsuarios(); // Hoặc bạn có thể cập nhật thủ công danh sách usuarios
    notifyListeners();
  } else {
    // Xử lý lỗi nếu cần
    throw Exception('Failed to add usuario: ${resp.body}');
  }
}
  Future<void> updateUsuario( Usuario usuario) async {
  final url1 = Uri.http(urlapi, 'api/NguoiDung/${usuario.maNv}');
  final resp = await http.put(
    url1,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    },
    body: usuarioToJson(usuario),
   // body: usuarioToJson(usuario), // Chuyển đổi đối tượng thành JSON
  );

  if (resp.statusCode == 204) {
    // Cập nhật thành công, bạn có thể cập nhật danh sách hoặc lấy lại dữ liệu
    getUsuarios(); // Hoặc bạn có thể cập nhật thủ công danh sách usuarios
    notifyListeners();
  } else {
    // Xử lý lỗi nếu cần
    throw Exception('Failed to update usuario');
  }
}

 Future<void> deleteUsuario(String maNv) async {
  final url1 = Uri.http(urlapi, 'api/NguoiDung/$maNv');
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
      usuarios.removeWhere((usuario) => usuario.maNv == maNv);
      notifyListeners();
    } else {
      // Xử lý lỗi nếu cần
      throw Exception('Failed to delete usuario. Status code: ${resp.statusCode}');
    }
  } catch (error) {
    print('Error deleting usuario: $error');
    // Có thể thêm thông báo lỗi cho người dùng ở đây
    throw Exception('An error occurred while deleting usuario.');
  }
}
// Bảng danh sách KPI
  getUsuarios1() async{
    final url1 = Uri.http(urlapi,'api/KPI');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response1 = usuarioFromJson1(resp.body);
    usuarios1 = response1;
    notifyListeners();
  }
  // Lấy theo phòng
   getKpiPhongKhoa() async{
    final url1 = Uri.http(urlapi,'api/Application/GetKPIByPK/CNTT');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response2 = usuarioFromJson2(resp.body);
    kpicntt = response2;
    notifyListeners();
  }
  // Lấy theo chức danh
   getChucdanh() async{
    final url1 = Uri.http(urlapi,'api/ChucDanhs/getByMaPK/CNTT');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response3 = usuarioFromJson3(resp.body);
    chucdanh = response3;
    print('ChucDanh data fetched: ${chucdanh.length} items');
    notifyListeners();
  }

 // Lấy theo phòng khoa giao cho cá nhân
   getKPIByPKCN() async{
    final url1 = Uri.http(urlapi,'api/Application/GetKPIByPKCaNhan/CNTT');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response2 = usuarioFromJson2(resp.body);
    kpicntt = response2;
    notifyListeners();
  }


  Future<List<Kpiphongcntt>> getKpiPhongKhoatheomaKPI(List<int> maKpis) async {
    final url = Uri.http(urlapi, 'api/Application/GetKPIByPK/CNTT');
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      List<Kpiphongcntt> allKpis = usuarioFromJson2(resp.body);
      // Lọc ra các KPI có mã khớp với mã KPI trong danh sách `maKpis`
      return allKpis.where((kpi) => maKpis.contains(kpi.makpi)).toList();
    } else {
      throw Exception('Failed to load KPI details');
    }
  }
  // Lấy người dùng theo công việc cá nhân
    GetKPIByCVCN() async{
    final url1 = Uri.http(urlapi,'api/KPI/GetKPIByCVCN');
    final resp = await http.get(url1, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials" : "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    final response2 = usuarioFromJson2(resp.body);
    kpicntt = response2;
    notifyListeners();
  }
  Future<String> GetKPITenCDByMaCD(String macd) async {
  final url = Uri.http(urlapi, 'api/ChucDanhs/GetKPITenCDByMaCD', {
    'maCD': macd.toString(),
  });
  print(url);
  try {
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      String trangThai = json.decode(resp.body); // Phản hồi là số nguyên
      return trangThai; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải tên chúc danh. Mã trạng thái: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI3.');
  }
}
 Future<String> getMaNVByMaQuyen(String maquyen) async {
  final url = Uri.http(urlapi, 'api/NguoiDung/getMaNVByMaQuyen', {
    'maquyen': maquyen.toString(),
  });
  print(url);
  try {
    final resp = await http.get(url, headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });

    if (resp.statusCode == 200) {
      String maquyen = json.decode(resp.body); // Phản hồi là số nguyên
      return maquyen; // Trả về giá trị trạng thái nhận được từ API
    } else if (resp.statusCode == 404) {
      return '0'; // Nếu không tìm thấy thì trả về -1
    } else {
      throw Exception('Không thể tải tên chúc danh. Mã maquyen: ${resp.statusCode}');
    }
  } catch (e) {
    throw Exception('Đã xảy ra lỗi trong khi lấy trạng thái KPI4.');
  }
}

}