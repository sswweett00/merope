import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:merope_models/auth/auth_user.dart';
import '../../security/session_storage.dart';
import './exceptions.dart';
import './api_client.dart';

class AuthApi {
  final Dio _dio;
  final SessionStorage _sessionStorage;

  AuthApi(this._dio, this._sessionStorage);

  Future<ApiResult<AuthUser>> login({required String email, required String password, String? fingerprint}) async {
    try {
      final response = await _dio.post('/api/v10/auth/login', data: {'email':email,'password':password,if(fingerprint!=null)'fingerprint':fingerprint});
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data=response.data as Map<String,dynamic>;
        final token=data['token'] as String?; final userMap=data['user'] as Map<String,dynamic>?;
        if(token!=null){await _sessionStorage.saveSession(token:token,refreshToken:data['refresh_token'] as String?,expiresAt:token.contains('.')?_parseJwtExpiry(token):null,user:userMap!=null?AuthUser.fromJson(userMap):null);}
        if(userMap!=null)return ApiResult.success(AuthUser.fromJson(userMap),statusCode:response.statusCode);
        return ApiResult.error('User data missing in response',statusCode:response.statusCode);
      }
      return ApiResult.error(response.data?['error']?.toString()??'Login failed',statusCode:response.statusCode);
    } on DioException catch(e){return ApiResult.error(MeropeAPIException.fromDioError(e),statusCode:e.response?.statusCode);} on SocketException catch(_){return ApiResult.error(NetworkTimeoutException(),statusCode:null);} catch(e){return ApiResult.error(e.toString(),statusCode:null);}
  }

  Future<ApiResult<AuthUser>> register({required String username,required String email,required String password,String? displayName}) async {
    try{
      final response=await _dio.post('/api/v10/auth/register',data:{'username':username,'email':email,'password':password,if(displayName!=null)'display_name':displayName});
      if(response.statusCode==201){final data=response.data as Map<String,dynamic>;final token=data['token'] as String?;final userMap=data['user'] as Map<String,dynamic>?;if(token!=null){await _sessionStorage.saveSession(token:token,refreshToken:data['refresh_token'] as String?,user:userMap!=null?AuthUser.fromJson(userMap):null);}if(userMap!=null)return ApiResult.success(AuthUser.fromJson(userMap),statusCode:response.statusCode);return ApiResult.error('User data missing in response',statusCode:response.statusCode);}
      return ApiResult.error(response.data?['error']?.toString()??'Registration failed',statusCode:response.statusCode);
    } on DioException catch(e){return ApiResult.error(MeropeAPIException.fromDioError(e),statusCode:e.response?.statusCode);} on SocketException catch(_){return ApiResult.error(NetworkTimeoutException(),statusCode:null);} catch(e){return ApiResult.error(e.toString(),statusCode:null);}
  }

  Future<ApiResult<void>> logout() async {
    try{final result=await _dio.post('/api/v10/auth/logout');if(result.statusCode==200||result.statusCode==204){await _sessionStorage.clearSession();return const ApiResult.success(null,statusCode:200);}await _sessionStorage.clearSession();return ApiResult.error('Logout returned ${result.statusCode}',statusCode:result.statusCode);} on DioException catch(e){if(e.response?.statusCode==401){await _sessionStorage.clearSession();return const ApiResult.success(null,statusCode:200);}await _sessionStorage.clearSession();return ApiResult.error(MeropeAPIException.fromDioError(e),statusCode:e.response?.statusCode);} catch(e){await _sessionStorage.clearSession();return ApiResult.error(e.toString(),statusCode:null);}
  }

  int? _parseJwtExpiry(String token){try{final parts=token.split('.');if(parts.length!=3)return null;final normalized=base64Url.normalize(parts[1]);final decoded=utf8.decode(base64Url.decode(normalized));final map=jsonDecode(decoded) as Map<String,dynamic>;final exp=map['exp'] as int?;if(exp!=null)return DateTime.fromMillisecondsSinceEpoch(exp*1000).millisecondsSinceEpoch;}catch(_){ }return null;}
}

final authApiServiceProvider=Provider<AuthApi>((ref){final apiClient=ApiClient();return AuthApi(apiClient.dio,SessionStorage());});
