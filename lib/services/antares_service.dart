import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/antares_config.dart';
import '../models/lokasi_model.dart';

class AntaresService {
  static Future<LokasiMotor> getLokasiTerakhir() async {
    final url =
        "${AntaresConfig.baseUrl}/${AntaresConfig.appName}/${AntaresConfig.gpsDevice}/la";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "X-M2M-Origin": AntaresConfig.accessKey,
        "Accept": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil data Antares");
    }

    final body = jsonDecode(response.body);
    final content = jsonDecode(body["m2m:cin"]["con"]);

    return LokasiMotor.fromJson(content);
  }

  static Future<void> kirimPerintahRelay(String command) async {
    final url =
        "${AntaresConfig.baseUrl}/${AntaresConfig.appName}/${AntaresConfig.relayDevice}";

    final body = {
      "m2m:cin": {
        "con": '{"command":"$command"}'
      }
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "X-M2M-Origin": AntaresConfig.accessKey,
        "Content-Type": "application/json;ty=4",
        "Accept": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      throw Exception("Gagal mengirim perintah relay");
    }
  }
}
