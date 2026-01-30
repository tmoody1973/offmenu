import 'package:serverpod/serverpod.dart';

/// CORS middleware for the Serverpod API server.
///
/// This applies to RPC/API endpoints (method calls from Flutter clients),
/// which is different from the web server middleware.
Middleware apiCorsMiddleware(List<String> allowedOrigins) {
  return (Handler innerHandler) {
    return (Request request) async {
      final originHeader = request.headers['origin'];
      final origin = originHeader?.firstOrNull;
      final isOriginAllowed =
          origin != null && allowedOrigins.contains(origin);

      // Build CORS headers
      final corsHeaders = <String, List<String>>{
        'Access-Control-Allow-Methods': ['GET, POST, PUT, DELETE, OPTIONS'],
        'Access-Control-Allow-Headers': [
          'Content-Type, Authorization, X-Serverpod-Client-Id, serverpod_idp'
        ],
        'Access-Control-Allow-Credentials': ['true'],
        'Access-Control-Max-Age': ['86400'],
      };

      if (isOriginAllowed) {
        corsHeaders['Access-Control-Allow-Origin'] = [origin!];
      }

      // Handle preflight OPTIONS requests
      if (request.method == Method.options) {
        return Response.noContent(
          headers: Headers.fromMap(corsHeaders),
        );
      }

      // Process the request through the inner handler
      final result = await innerHandler(request);

      // Add CORS headers to the response if it's a Response object
      if (isOriginAllowed && result is Response) {
        return result.copyWith(
          headers: result.headers.transform((h) {
            h['Access-Control-Allow-Origin'] = [origin!];
            h['Access-Control-Allow-Credentials'] = ['true'];
          }),
        );
      }

      return result;
    };
  };
}
