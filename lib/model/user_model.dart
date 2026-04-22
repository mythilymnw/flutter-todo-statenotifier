library user_model;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'serializers.dart';

part 'user_model.g.dart';

abstract class AppUser implements Built<AppUser, AppUserBuilder> {
  String get uid;
  String get name;
  String get email;
  String get password; 
  String get createdAt;
  String get updatedAt;

  AppUser._();
  factory AppUser([void Function(AppUserBuilder) updates]) = _$AppUser;

  static Serializer<AppUser> get serializer => _$appUserSerializer;

  static AppUser fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AppUser.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AppUser.serializer, this)
        as Map<String, dynamic>;
  }
}