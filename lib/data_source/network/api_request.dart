import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiRequest{

  ///<---------------Get API Calling------------------>
  Future<Response?> getAPICall(String url, Map<String, String>? headers, {bool isLogShow = true}) async {
    debugPrint("Debug URL : $url");
    try {
      Response response;
      if (headers != null) {
        response = await http.get(Uri.parse(url), headers: headers);
      } else {
        response = await http.get(Uri.parse(url));
      }

      if (isLogShow) {
        log("LOG : $url");
        log("RESPONSE : ${response.body}");
      }
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///<---------------Post API Calling------------------>
  Future<Response?> postAPICall(String url, Map<String, String> headers, {Object? body, bool toShowLogs = true}) async {
    if (toShowLogs) {
      debugPrint(url);
      debugPrint(body.toString());
    }

    try {
      Response response;
      if (body != null) {
        response =
        await http.post(Uri.parse(url), body: body, headers: headers);
      } else {
        response = await http.post(Uri.parse(url), headers: headers);
      }

      if (toShowLogs) {
        log(response.body);
      }
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///<---------------Put API Calling------------------>
  Future<Response?> putAPICall(String url, Object body, Map<String, String> headers) async {
    debugPrint(url);
    debugPrint(body.toString());
    headers.addAll({
      "Accept": "*/*",
      "Content-Type": "application/json",
    });

    log("headers>>>> $headers");
    try {
      Response response =
      await http.put(Uri.parse(url), body: body, headers: headers);
      log(response.body);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///<---------------Delete API Calling------------------>
  Future<Response?> deleteAPICall(String url, Map<String, String> headers) async {
    debugPrint(url);
    try {
      Response response = await http.delete(Uri.parse(url), headers: headers);
      log(response.body);

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  ///<---------------Upload Multipart Image------------------>
  Future<Response?> uploadMultipartImage(MultipartRequest? multipartRequest) async {
    try {
      StreamedResponse streamedResponse = await multipartRequest!.send();
      Response response = await Response.fromStream(streamedResponse);
      return response;
    } catch (e) {
      throw Exception(e);
    }
  }
}