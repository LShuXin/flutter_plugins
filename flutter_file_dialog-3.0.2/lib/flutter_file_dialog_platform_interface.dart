import 'dart:async';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/services.dart';
import 'flutter_file_dialog_method_channel.dart';

abstract class FlutterFileDialogPlatform extends PlatformInterface {
  /// Constructs a FlutterFileDialogPlatform.
  FlutterFileDialogPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFileDialogPlatform _instance = MethodChannelFlutterFileDialog();

  /// The default instance of [FlutterFileDialogPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFileDialog].
  static FlutterFileDialogPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFileDialogPlatform] when
  /// they register themselves.
  static set instance(FlutterFileDialogPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Displays a dialog for picking a file.
  ///
  /// Returns the path of the picked file or null if operation was cancelled.
  /// Throws exception on error.
  Future<String?> pickFile({OpenFileDialogParams? params}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Displays a dialog for picking a directory.
  /// Availabe on Android 21/iOS 13 and above. Use [isPickDirectorySupported] to
  /// check whether the current platform supports [pickDirectory] or not if
  /// you are targeting an older version of Android/iOS.
  ///
  /// Returns the path of the picked directory or null if operation was cancelled.
  /// Throws exception on error.
  Future<DirectoryLocation?> pickDirectory() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> isPickDirectorySupported() async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Displays a dialog for selecting a location where to save the file and
  /// saves the file to the selected location.
  ///
  /// Returns path of the saved file or null if operation was cancelled.
  /// Throws exception on error.
  Future<String?> saveFile({SaveFileDialogParams? params}) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Saves a file to the specified directory that picked by [pickDirectory].
  /// The file is saving in background, be sure the [directory] is permission
  /// granted.
  /// Availabe on Android 21/iOS 13 and above.
  ///
  /// [mimeType] is required for Android.
  /// [replace] iOS only
  /// [onFileExists] iOS only
  ///
  /// - on iOS
  /// In case to prevent files from being overwritten unexpectedly,
  /// by default:
  ///   this method will skip saving file if that file already exists. You can
  ///   provide a callback [onFileExists] to ask your user and call [saveFileToDirectory]
  ///   again.
  ///   If [replace] is true, [onFileExists] will be ignored.
  ///
  /// - on Android:
  ///   [fileName] will be renamed automaticlly by Android if file already exists.
  ///
  /// Returns path of the saved file.
  /// Throws exception on error.
  Future<String?> saveFileToDirectory({
    required DirectoryLocation directory,
    required Uint8List data,
    required String fileName,
    String? mimeType,
    bool replace = false,
    Future Function()? onFileExists,
  }) async {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

class DirectoryLocation {
  final String rawUri;

  DirectoryLocation(this.rawUri);

  @override
  String toString() => rawUri;
}

/// Dialog types for [pickFile] (iOS only)
enum OpenFileDialogType { document, image }

String? _openFileDialogTypeToString(OpenFileDialogType dialogType) {
  switch (dialogType) {
    case OpenFileDialogType.document:
      return 'document';
    case OpenFileDialogType.image:
      return 'image';
    }
}

/// Source types for [pickFile] (iOS only)
enum SourceType { camera, photoLibrary, savedPhotosAlbum }

String? _sourceTypeToString(SourceType sourceType) {
  switch (sourceType) {
    case SourceType.camera:
      return 'camera';
    case SourceType.photoLibrary:
      return 'photoLibrary';
    case SourceType.savedPhotosAlbum:
      return 'savedPhotosAlbum';
    }
}

/// Parameters for the [pickFile] method.
class OpenFileDialogParams {
  /// Dialog type (iOS)
  final OpenFileDialogType dialogType;

  /// Source type (iOS)
  final SourceType sourceType;

  // Allow editing? (iOS)
  final bool allowEditing;

  /// You need to register the document types that your application can open
  /// with iOS. To do this you need to add a document type to your app’s
  /// Info.plist for each document type that your app can open. Additionally
  /// if any of the document types are not known by iOS, you will need
  /// to provide an Uniform Type Identifier (UTI) for that document type.
  ///
  /// More info:
  /// https://developer.apple.com/library/archive/qa/qa1587/_index.html
  final List<String>? allowedUtiTypes;

  /// Filter for file extensions (null to allow any extension)
  final List<String>? fileExtensionsFilter;

  /// MIME types filter (Android only)
  /// Only files with the provided MIME types will be shown in the file picker.
  final List<String>? mimeTypesFilter;

  /// Access files in local device only (Android)?
  final bool localOnly;

  /// Flag telling if the picked file should be copied to the application
  /// specific cache directory (Android only).
  ///
  /// If true, [pickFile] returns path to the copied file.
  /// If false, [pickFile] returns path to the original picked file.
  final bool copyFileToCacheDir;

  /// Create parameters for the [pickFile] method.
  const OpenFileDialogParams({
    this.dialogType = OpenFileDialogType.document,
    this.sourceType = SourceType.photoLibrary,
    this.allowEditing = false,
    this.allowedUtiTypes,
    this.fileExtensionsFilter,
    this.mimeTypesFilter,
    this.localOnly = false,
    this.copyFileToCacheDir = true,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dialogType': _openFileDialogTypeToString(dialogType),
      'sourceType': _sourceTypeToString(sourceType),
      'allowEditing': allowEditing,
      'allowedUtiTypes': allowedUtiTypes,
      'fileExtensionsFilter': fileExtensionsFilter,
      'mimeTypesFilter': mimeTypesFilter,
      'localOnly': localOnly,
      'copyFileToCacheDir': copyFileToCacheDir,
    };
  }
}

/// Parameters for the [saveFile] method.
class SaveFileDialogParams {
  /// Path of the file to save.
  /// Provide either [sourceFilePath] or [data].
  final String? sourceFilePath;

  /// File data.
  /// Provide either [sourceFilePath] or [data].
  final Uint8List? data;

  /// The suggested file name to use when saving the file.
  /// Required if [data] is provided.
  final String? fileName;

  /// MIME types filter (Android only)
  /// Only files with the provided MIME types will be shown in the file picker.
  final List<String>? mimeTypesFilter;

  /// Access files in local device only (Android)?
  final bool localOnly;

  /// Create parameters for the [saveFile] method.
  const SaveFileDialogParams({
    this.sourceFilePath,
    this.data,
    this.fileName,
    this.mimeTypesFilter,
    this.localOnly = false,
  })  : assert(sourceFilePath == null || data == null,
  'sourceFilePath or data should be null'),
        assert(sourceFilePath != null || data != null,
        'Missing sourceFilePath or data'),
        assert(data == null || (fileName != null && fileName != ''),
        'Missing fileName');

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'sourceFilePath': sourceFilePath,
      'data': data,
      'fileName': fileName,
      'mimeTypesFilter': mimeTypesFilter,
      'localOnly': localOnly,
    };
  }
}