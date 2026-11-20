import 'package:dio/dio.dart';

/// Servicio HTTP convencional con Dio e interceptor simulado para cabeceras.
class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://api.simulada.local/v1'));
  String? authToken;

  ApiService() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Accept'] = 'application/json';
          if (authToken != null) {
            options.headers['Authorization'] = 'Bearer $authToken';
          }
          handler.resolve(_mockResponse(options));
        },
      ),
    );
  }

  Response<dynamic> _mockResponse(RequestOptions options) {
    if (options.path == '/auth/login' && options.method == 'POST') {
      final data = options.data as Map<String, dynamic>;
      if (data['username'] == 'usuario_prueba' && data['password'] == 'clave123') {
        return Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'user_id': 'usr_001',
            'username': data['username'],
            'token': 'mock_jwt_token_mvvm_001',
          },
        );
      }
      return Response(requestOptions: options, statusCode: 401, data: {'error': 'Inválido'});
    }

    if (options.path == '/items' && options.method == 'GET') {
      return Response(requestOptions: options, statusCode: 200, data: _mockItems);
    }

    if (options.path.startsWith('/items/') && options.method == 'GET') {
      final id = options.path.replaceFirst('/items/', '');
      final match = _mockItems.where((e) => e['id'] == id).toList();
      if (match.isNotEmpty) {
        return Response(requestOptions: options, statusCode: 200, data: match.first);
      }
    }

    return Response(requestOptions: options, statusCode: 404, data: {'error': 'No encontrado'});
  }

  static const List<Map<String, dynamic>> _mockItems = [
    {
      'id': '1',
      'title': 'Elemento de Prueba 1',
      'description': 'Detalle técnico del elemento 1 obtenido desde API simulada.',
      'category': 'Arquitectura',
    },
    {
      'id': '2',
      'title': 'Elemento de Prueba 2',
      'description': 'Detalle técnico del elemento 2 con persistencia en SQLite.',
      'category': 'Métricas',
    },
    {
      'id': '3',
      'title': 'Elemento de Prueba 3',
      'description': 'Detalle técnico del elemento 3 para validar filtro de búsqueda.',
      'category': 'Calidad',
    },
  ];
}
