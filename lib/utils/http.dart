import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'index.dart';

/// A singleton HTTP client for making API requests throughout the app.
///
/// Features:
/// - Singleton pattern for consistent configuration
/// - Automatic JSON encoding/decoding
/// - Timeout handling
/// - Error handling with custom exceptions
/// - Request/response logging
/// - Common headers management
class HttpClient {
  static HttpClient? _instance;
  late final http.Client _client;

  // Default configuration
  static const Duration _defaultTimeout = Duration(seconds: 30);
  static const String _defaultContentType = 'application/json';

  // Base URL - can be configured per environment
  String? _baseUrl;
  Map<String, String> _defaultHeaders = {};

  HttpClient._internal() {
    _client = http.Client();
    _setDefaultHeaders();
  }

  /// Get the singleton instance
  // ignore: prefer_constructors_over_static_methods
  static HttpClient get instance {
    _instance ??= HttpClient._internal();
    return _instance!;
  }

  /// Configure the client with base URL and additional headers
  void configure({
    String? baseUrl,
    Map<String, String>? headers,
  }) {
    _baseUrl = baseUrl;
    if (headers != null) {
      _defaultHeaders.addAll(headers);
    }
  }

  /// Set default headers
  void _setDefaultHeaders() {
    _defaultHeaders = {
      'Content-Type': _defaultContentType,
      'Accept': _defaultContentType,
    };
  }

  /// Add authorization header
  void setAuthToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  /// Remove authorization header
  void clearAuthToken() {
    _defaultHeaders.remove('Authorization');
  }

  /// Build complete URL
  String _buildUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }

    if (_baseUrl == null) {
      throw const HttpClientException('Base URL not configured');
    }

    return '${_baseUrl?.replaceAll(RegExp(r'/$'), '')}/${endpoint.replaceAll(RegExp('^/'), '')}';
  }

  /// Merge headers
  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final headers = Map<String, String>.from(_defaultHeaders);
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  /// Log request details
  void _logRequest(String method, String url, Map<String, String> headers, dynamic body) {
    printDebug('🌐 HTTP $method: $url');
    printDebug('📤 Headers: $headers');
    if (body != null) {
      printDebug('📤 Body: $body');
    }
  }

  /// Log response details
  void _logResponse(http.Response response) {
    printDebug('📥 Response ${response.statusCode}: ${response.reasonPhrase}');
    printDebug('📥 Body: ${response.body}');
  }

  /// Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    _logResponse(response);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;

      try {
        return json.decode(response.body);
      } on Exception {
        return response.body;
      }
    }

    // Handle different error status codes
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorizedException(response.body);
      case 403:
        throw ForbiddenException(response.body);
      case 404:
        throw NotFoundException(response.body);
      case 500:
        throw InternalServerErrorException(response.body);
      default:
        throw HttpClientException(
          'HTTP Error ${response.statusCode}: ${response.reasonPhrase}',
        );
    }
  }

  /// Generic request method
  Future<dynamic> _request({
    required String method,
    required String endpoint,
    dynamic body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    try {
      final url = Uri.parse(_buildUrl(endpoint));
      final mergedHeaders = _mergeHeaders(headers);
      final requestTimeout = timeout ?? _defaultTimeout;

      _logRequest(method, url.toString(), mergedHeaders, body);

      http.Response response;

      switch (method.toLowerCase()) {
        case 'get':
          response = await _client.get(url, headers: mergedHeaders).timeout(requestTimeout);
        case 'post':
          response = await _client
              .post(
                url,
                headers: mergedHeaders,
                body: body is String ? body : json.encode(body),
              )
              .timeout(requestTimeout);
        case 'put':
          response = await _client
              .put(
                url,
                headers: mergedHeaders,
                body: body is String ? body : json.encode(body),
              )
              .timeout(requestTimeout);
        case 'patch':
          response = await _client
              .patch(
                url,
                headers: mergedHeaders,
                body: body is String ? body : json.encode(body),
              )
              .timeout(requestTimeout);
        case 'delete':
          response = await _client.delete(url, headers: mergedHeaders).timeout(requestTimeout);
        default:
          throw HttpClientException('Unsupported HTTP method: $method');
      }

      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException('No internet connection');
    } on HttpClientException {
      rethrow;
    } catch (e) {
      throw HttpClientException('Request failed: $e');
    }
  }

  /// GET request
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _request(
      method: 'GET',
      endpoint: endpoint,
      headers: headers,
      timeout: timeout,
    );
  }

  /// POST request
  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _request(
      method: 'POST',
      endpoint: endpoint,
      body: body,
      headers: headers,
      timeout: timeout,
    );
  }

  /// PUT request
  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _request(
      method: 'PUT',
      endpoint: endpoint,
      body: body,
      headers: headers,
      timeout: timeout,
    );
  }

  /// PATCH request
  Future<dynamic> patch(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _request(
      method: 'PATCH',
      endpoint: endpoint,
      body: body,
      headers: headers,
      timeout: timeout,
    );
  }

  /// DELETE request
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    Duration? timeout,
  }) async {
    return _request(
      method: 'DELETE',
      endpoint: endpoint,
      headers: headers,
      timeout: timeout,
    );
  }

  /// Close the client
  void dispose() {
    _client.close();
    _instance = null;
  }
}

/// Base HTTP exception class
class HttpClientException implements Exception {
  final String message;

  const HttpClientException(this.message);

  @override
  String toString() => 'HttpClientException: $message';
}

/// Network connection exception
class NetworkException extends HttpClientException {
  const NetworkException(super.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// Bad request (400) exception
class BadRequestException extends HttpClientException {
  const BadRequestException(super.message);

  @override
  String toString() => 'BadRequestException: $message';
}

/// Unauthorized (401) exception
class UnauthorizedException extends HttpClientException {
  const UnauthorizedException(super.message);

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// Forbidden (403) exception
class ForbiddenException extends HttpClientException {
  const ForbiddenException(super.message);

  @override
  String toString() => 'ForbiddenException: $message';
}

/// Not found (404) exception
class NotFoundException extends HttpClientException {
  const NotFoundException(super.message);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Internal server error (500) exception
class InternalServerErrorException extends HttpClientException {
  const InternalServerErrorException(super.message);

  @override
  String toString() => 'InternalServerErrorException: $message';
}
