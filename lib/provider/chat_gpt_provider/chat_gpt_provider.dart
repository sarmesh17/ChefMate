
import 'package:airecipe/repository/chat_repo/chat_repo.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_gpt_provider.g.dart';

final  dioProvider= Provider((ref) => Dio());
final  loggerProvider = Provider((ref)=> Logger());



 @riverpod 
ChatRepo chatRepo (Ref ref){

  final dio = ref.read(dioProvider);
  final logger = ref.read(loggerProvider);
  return ChatRepo(dio, logger);

}


