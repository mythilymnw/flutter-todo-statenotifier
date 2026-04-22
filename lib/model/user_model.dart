library user_model;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
part 'user_model.g.dart';
abstract class AppUser implements Built<AppUser, AppUserBuilder> {
  String get uid;
  String get name;
  String get email;
  String get createdAt;

  AppUser._();

  factory AppUser([void Function(AppUserBuilder) updates]) = _$AppUser;

  static Serializer<AppUser> get serializer => _$appUserSerializer;
}  