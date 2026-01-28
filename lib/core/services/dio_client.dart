import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

class DioClient {
  final Dio _dio;
  final StorageService _storageService;

  DioClient(this._storageService)
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storageService.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Can handle token refresh or global logging here
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;
}
