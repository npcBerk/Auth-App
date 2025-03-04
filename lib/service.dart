import 'package:dio/dio.dart';

class Service {
  static Future<Response> request(
    String type,
    String endpoint, {
    Map<String, dynamic>? header, // {'Authorization': '$token'}
    Map<String, dynamic>? data, // { 'name': 'John Doe' }
  }) async {
    Dio dio = Dio();
    dio.options.headers = header;
    dio.options.contentType = Headers.jsonContentType;
    dio.options.responseType = ResponseType.json;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    switch (type) {
      case 'GET':
        return await dio.get(endpoint);
      case 'POST':
        return await dio.post(endpoint, data: data);
      case 'PUT':
        return await dio.put(endpoint, data: data);
      case 'DELETE':
        return await dio.delete(endpoint);
      default:
        return await dio.get(endpoint);
    }
  }
}

void getData() {
  Service.request(
    'GET',
    'http://localhost:8080/users',
    header: {
      'Authorization':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NDExNjkzMDcsImlhdCI6MTc0MTA4MjkwNywic3ViIjoiNjdjNmQxMWJlMzUzMjhjOWI0ZGUwNjIxIn0.fFVEyHCStjODaEiNyBr4Nbqpc4NsWi3dgaxFwUZ0Bxs',
    },
  ).then((response) {
    print(response.data);
  });
}

main() {
  getData();
}
