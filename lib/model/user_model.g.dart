// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppUser> _$appUserSerializer = _$AppUserSerializer();

class _$AppUserSerializer implements StructuredSerializer<AppUser> {
  @override
  final Iterable<Type> types = const [AppUser, _$AppUser];
  @override
  final String wireName = 'AppUser';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    AppUser object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'uid',
      serializers.serialize(object.uid, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'email',
      serializers.serialize(
        object.email,
        specifiedType: const FullType(String),
      ),
      'password',
      serializers.serialize(
        object.password,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(String),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(String),
      ),
    ];

    return result;
  }

  @override
  AppUser deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AppUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'uid':
          result.uid =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'email':
          result.email =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'password':
          result.password =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
      }
    }

    return result.build();
  }
}

class _$AppUser extends AppUser {
  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;
  @override
  final String password;
  @override
  final String createdAt;
  @override
  final String updatedAt;

  factory _$AppUser([void Function(AppUserBuilder)? updates]) =>
      (AppUserBuilder()..update(updates))._build();

  _$AppUser._({
    required this.uid,
    required this.name,
    required this.email,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  AppUser rebuild(void Function(AppUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppUserBuilder toBuilder() => AppUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppUser &&
        uid == other.uid &&
        name == other.name &&
        email == other.email &&
        password == other.password &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uid.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AppUser')
          ..add('uid', uid)
          ..add('name', name)
          ..add('email', email)
          ..add('password', password)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class AppUserBuilder implements Builder<AppUser, AppUserBuilder> {
  _$AppUser? _$v;

  String? _uid;
  String? get uid => _$this._uid;
  set uid(String? uid) => _$this._uid = uid;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  AppUserBuilder();

  AppUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uid = $v.uid;
      _name = $v.name;
      _email = $v.email;
      _password = $v.password;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppUser other) {
    _$v = other as _$AppUser;
  }

  @override
  void update(void Function(AppUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AppUser build() => _build();

  _$AppUser _build() {
    final _$result =
        _$v ??
        _$AppUser._(
          uid: BuiltValueNullFieldError.checkNotNull(uid, r'AppUser', 'uid'),
          name: BuiltValueNullFieldError.checkNotNull(name, r'AppUser', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
            email,
            r'AppUser',
            'email',
          ),
          password: BuiltValueNullFieldError.checkNotNull(
            password,
            r'AppUser',
            'password',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AppUser',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'AppUser',
            'updatedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
