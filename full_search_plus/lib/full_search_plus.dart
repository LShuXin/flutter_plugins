import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'ffi.dart' as native;
import 'package:ffi/ffi.dart';
import 'package:isolate/ports.dart';

class SearchEngine {
  static setup() {
    native.store_dart_post_cobject(NativeApi.postCObject);
    debugPrint("Setup Done");
  }

  /// open a exist index or create a new directory to store index files
  /// path: the location path of directory on device
  /// schema: a json format string which defines the field data types of object
  /// for example:
  /// ```
  /// {"message_id": "i64","user_id": "i64", "guild_id": "i64", "channel_id": "i64", "timestamp": "date", "content": "text"}
  /// ```
  int openOrCreate(String path, String schema) {
    final pPath = path.toNativeUtf8();
    final pSchema = schema.toNativeUtf8();
    return native.se_open_or_create(pPath, pSchema);
  }

  /// test whether the engine has been created
  Future<bool> exists() async {
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_exists(sendPort.nativePort);

    assert(res == 1);
    final data = await completer.future;
    if (data is bool) {
      return data;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
    return true;
  }

  /// store and index the object
  /// doc: a json format string of the object which want to be indexed
  Future<void> index(String doc) async {
    final pDoc = doc.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);
    final res = native.se_index(sendPort.nativePort, pDoc);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// query and search the specified fields
  /// query: keywords used for search
  /// fields: search for the content of which fields
  Future<String?> search(String query, List fields, int pageStart, int pageSize) async {
    final pQuery = query.toNativeUtf8();
    final pFields = json.encode(fields).toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_search(sendPort.nativePort, pQuery, pFields, pageStart, pageSize);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return null;
    } else if (data is String) {
      return data;
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// retrieve a specify document by giving a field of i64 and it's value
  Future<String?> getByI64(String field, int id) async {
    final pField = field.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    // final res = native.se_get_by_i64(sendPort.nativePort, pField, id);
    // assert(res == 1);
    // final data = await completer.future;
    // if (data == null) {
    //   return null;
    // } else if (data is String) {
    //   return data;
    // } else {
    //   throw StateError('Got unknown type: ${data.runtimeType} $data');
    // }
    return null;
  }

  /// retrieve a specify document by giving a field of u64 and it's value
  Future<String?> getByU64(String field, int id) async {
    final pField = field.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_get_by_u64(sendPort.nativePort, pField, id);
    assert(res == 1);
    final data = await completer.future;

    if (data == null) {
      return null;
    } else if (data is String) {
      return data;
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// remove a specify document by giving a field of u64 and it's value
  Future<void> deleteByU64(String field, int id) async {
    final pField = field.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_delete_by_u64(sendPort.nativePort, pField, id);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// remove a specify document by giving a field of string and it's value
  Future<void> deleteByString(String field, String value) async {
    final pField = field.toNativeUtf8();
    final pValue = value.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_delete_by_str(sendPort.nativePort, pField, pValue);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// update a specify document by giving a field of string and it's value
  Future<void> updateByString(String field, String value, String doc) async {
    final pField = field.toNativeUtf8();
    final pValue = value.toNativeUtf8();
    final pDoc = doc.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_update_by_str(sendPort.nativePort, pField, pValue, pDoc);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }

  /// update a specify document by giving a field of string and it's value
  Future<void> updateByU64(String field, int value, String doc) async {
    final pField = field.toNativeUtf8();
    final pDoc = doc.toNativeUtf8();
    final completer = Completer<dynamic>();
    final sendPort = singleCompletePort(completer);

    final res = native.se_update_by_u64(sendPort.nativePort, pField, value, pDoc);
    assert(res == 1);
    final data = await completer.future;
    if (data == null) {
      return;
    } else if (data is String) {
      throw StateError(data);
    } else {
      throw StateError('Got unknown type: ${data.runtimeType} $data');
    }
  }
}
