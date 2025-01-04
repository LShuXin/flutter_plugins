// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'demo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Result _$ResultFromJson(Map<String, dynamic> json) => Result(
      json['snippet'] as String,
      Message.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResultToJson(Result instance) => <String, dynamic>{
      'snippet': instance.snippet,
      'result': instance.result,
    };

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      (json['message_id'] as num).toInt(),
      (json['guild_id'] as num).toInt(),
      (json['user_id'] as num).toInt(),
      json['timestamp'] as String,
      json['content'] as String,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'message_id': instance.messageId,
      'guild_id': instance.guildId,
      'user_id': instance.userId,
      'timestamp': instance.timestamp,
      'content': instance.content,
    };
