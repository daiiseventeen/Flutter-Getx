import 'package:get/get.dart';

class AlquranServis extends GetConnect {
  @override
  void onInit() {
    // baseUrl API
    httpClient.baseUrl = 'https://api.npoint.io/99c279bb173a6e28359c';
    super.onInit();
  }

  // Ambil data Al-Qur'an dari endpoint
  Future<Response<List<dynamic>>> fetchAlquran() {
  return get('/data');
  }
}