import 'package:relic/relic.dart';

/// CORS middleware to allow cross-origin requests from specified origins.
///
/// This is required for Flutter web clients hosted on different domains
/// (e.g., Vercel) to access the Serverpod API.
Middleware corsMiddleware(List<String> allowedOrigins) {
  return (Handler next) {
    return (Request request) async {
      final originHeader = request.headers['origin'];
      final origin = originHeader?.firstOrNull;
      final isOriginAllowed = origin != null && allowedOrigins.contains(origin);

      // Handle preflight OPTIONS requests
      if (request.method == Method.options) {
        return Response.ok(
          headers: Headers.fromMap({
            if (isOriginAllowed) 'Access-Control-Allow-Origin': [origin],
            'Access-Control-Allow-Methods': ['GET, POST, PUT, DELETE, OPTIONS'],
            'Access-Control-Allow-Headers': [
              'Content-Type, Authorization, X-Serverpod-Client-Id, serverpod_idp'
            ],
            'Access-Control-Allow-Credentials': ['true'],
            'Access-Control-Max-Age': ['86400'],
          }),
        );
      }

      // Process the actual request
      final result = await next(request);

      // Add CORS headers to the response if it's a Response
      if (isOriginAllowed && result is Response) {
        final currentHeaders = result.headers;
        return result.copyWith(
          headers: Headers.fromMap({
            ...currentHeaders,
            'Access-Control-Allow-Origin': [origin],
            'Access-Control-Allow-Credentials': ['true'],
          }),
        );
      }

      return result;
    };
  };
}
