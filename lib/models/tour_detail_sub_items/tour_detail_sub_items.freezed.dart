// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tour_detail_sub_items.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

RoutePointItem _$RoutePointItemFromJson(Map<String, dynamic> json) {
  return _RoutePointItem.fromJson(json);
}

/// @nodoc
mixin _$RoutePointItem {
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  int get pointType => throw _privateConstructorUsedError;

  /// Serializes this RoutePointItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoutePointItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoutePointItemCopyWith<RoutePointItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoutePointItemCopyWith<$Res> {
  factory $RoutePointItemCopyWith(
    RoutePointItem value,
    $Res Function(RoutePointItem) then,
  ) = _$RoutePointItemCopyWithImpl<$Res, RoutePointItem>;
  @useResult
  $Res call({
    String name,
    String? description,
    double latitude,
    double longitude,
    int orderIndex,
    int pointType,
  });
}

/// @nodoc
class _$RoutePointItemCopyWithImpl<$Res, $Val extends RoutePointItem>
    implements $RoutePointItemCopyWith<$Res> {
  _$RoutePointItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoutePointItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? orderIndex = null,
    Object? pointType = null,
  }) {
    return _then(
      _value.copyWith(
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            pointType: null == pointType
                ? _value.pointType
                : pointType // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RoutePointItemImplCopyWith<$Res>
    implements $RoutePointItemCopyWith<$Res> {
  factory _$$RoutePointItemImplCopyWith(
    _$RoutePointItemImpl value,
    $Res Function(_$RoutePointItemImpl) then,
  ) = __$$RoutePointItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String name,
    String? description,
    double latitude,
    double longitude,
    int orderIndex,
    int pointType,
  });
}

/// @nodoc
class __$$RoutePointItemImplCopyWithImpl<$Res>
    extends _$RoutePointItemCopyWithImpl<$Res, _$RoutePointItemImpl>
    implements _$$RoutePointItemImplCopyWith<$Res> {
  __$$RoutePointItemImplCopyWithImpl(
    _$RoutePointItemImpl _value,
    $Res Function(_$RoutePointItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RoutePointItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = freezed,
    Object? latitude = null,
    Object? longitude = null,
    Object? orderIndex = null,
    Object? pointType = null,
  }) {
    return _then(
      _$RoutePointItemImpl(
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        pointType: null == pointType
            ? _value.pointType
            : pointType // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$RoutePointItemImpl implements _RoutePointItem {
  const _$RoutePointItemImpl({
    required this.name,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.orderIndex,
    required this.pointType,
  });

  factory _$RoutePointItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoutePointItemImplFromJson(json);

  @override
  final String name;
  @override
  final String? description;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  final int orderIndex;
  @override
  final int pointType;

  @override
  String toString() {
    return 'RoutePointItem(name: $name, description: $description, latitude: $latitude, longitude: $longitude, orderIndex: $orderIndex, pointType: $pointType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoutePointItemImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.pointType, pointType) ||
                other.pointType == pointType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    latitude,
    longitude,
    orderIndex,
    pointType,
  );

  /// Create a copy of RoutePointItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoutePointItemImplCopyWith<_$RoutePointItemImpl> get copyWith =>
      __$$RoutePointItemImplCopyWithImpl<_$RoutePointItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$RoutePointItemImplToJson(this);
  }
}

abstract class _RoutePointItem implements RoutePointItem {
  const factory _RoutePointItem({
    required final String name,
    final String? description,
    required final double latitude,
    required final double longitude,
    required final int orderIndex,
    required final int pointType,
  }) = _$RoutePointItemImpl;

  factory _RoutePointItem.fromJson(Map<String, dynamic> json) =
      _$RoutePointItemImpl.fromJson;

  @override
  String get name;
  @override
  String? get description;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  int get orderIndex;
  @override
  int get pointType;

  /// Create a copy of RoutePointItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoutePointItemImplCopyWith<_$RoutePointItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HighlightItem _$HighlightItemFromJson(Map<String, dynamic> json) {
  return _HighlightItem.fromJson(json);
}

/// @nodoc
mixin _$HighlightItem {
  String get text => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this HighlightItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightItemCopyWith<HighlightItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightItemCopyWith<$Res> {
  factory $HighlightItemCopyWith(
    HighlightItem value,
    $Res Function(HighlightItem) then,
  ) = _$HighlightItemCopyWithImpl<$Res, HighlightItem>;
  @useResult
  $Res call({String text, int orderIndex});
}

/// @nodoc
class _$HighlightItemCopyWithImpl<$Res, $Val extends HighlightItem>
    implements $HighlightItemCopyWith<$Res> {
  _$HighlightItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? orderIndex = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HighlightItemImplCopyWith<$Res>
    implements $HighlightItemCopyWith<$Res> {
  factory _$$HighlightItemImplCopyWith(
    _$HighlightItemImpl value,
    $Res Function(_$HighlightItemImpl) then,
  ) = __$$HighlightItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, int orderIndex});
}

/// @nodoc
class __$$HighlightItemImplCopyWithImpl<$Res>
    extends _$HighlightItemCopyWithImpl<$Res, _$HighlightItemImpl>
    implements _$$HighlightItemImplCopyWith<$Res> {
  __$$HighlightItemImplCopyWithImpl(
    _$HighlightItemImpl _value,
    $Res Function(_$HighlightItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? orderIndex = null}) {
    return _then(
      _$HighlightItemImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightItemImpl implements _HighlightItem {
  const _$HighlightItemImpl({required this.text, required this.orderIndex});

  factory _$HighlightItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightItemImplFromJson(json);

  @override
  final String text;
  @override
  final int orderIndex;

  @override
  String toString() {
    return 'HighlightItem(text: $text, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightItemImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, orderIndex);

  /// Create a copy of HighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightItemImplCopyWith<_$HighlightItemImpl> get copyWith =>
      __$$HighlightItemImplCopyWithImpl<_$HighlightItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightItemImplToJson(this);
  }
}

abstract class _HighlightItem implements HighlightItem {
  const factory _HighlightItem({
    required final String text,
    required final int orderIndex,
  }) = _$HighlightItemImpl;

  factory _HighlightItem.fromJson(Map<String, dynamic> json) =
      _$HighlightItemImpl.fromJson;

  @override
  String get text;
  @override
  int get orderIndex;

  /// Create a copy of HighlightItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightItemImplCopyWith<_$HighlightItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InclusionItem _$InclusionItemFromJson(Map<String, dynamic> json) {
  return _InclusionItem.fromJson(json);
}

/// @nodoc
mixin _$InclusionItem {
  String get text => throw _privateConstructorUsedError;
  bool get isIncluded => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this InclusionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InclusionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InclusionItemCopyWith<InclusionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InclusionItemCopyWith<$Res> {
  factory $InclusionItemCopyWith(
    InclusionItem value,
    $Res Function(InclusionItem) then,
  ) = _$InclusionItemCopyWithImpl<$Res, InclusionItem>;
  @useResult
  $Res call({String text, bool isIncluded, int orderIndex});
}

/// @nodoc
class _$InclusionItemCopyWithImpl<$Res, $Val extends InclusionItem>
    implements $InclusionItemCopyWith<$Res> {
  _$InclusionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InclusionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isIncluded = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            isIncluded: null == isIncluded
                ? _value.isIncluded
                : isIncluded // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InclusionItemImplCopyWith<$Res>
    implements $InclusionItemCopyWith<$Res> {
  factory _$$InclusionItemImplCopyWith(
    _$InclusionItemImpl value,
    $Res Function(_$InclusionItemImpl) then,
  ) = __$$InclusionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, bool isIncluded, int orderIndex});
}

/// @nodoc
class __$$InclusionItemImplCopyWithImpl<$Res>
    extends _$InclusionItemCopyWithImpl<$Res, _$InclusionItemImpl>
    implements _$$InclusionItemImplCopyWith<$Res> {
  __$$InclusionItemImplCopyWithImpl(
    _$InclusionItemImpl _value,
    $Res Function(_$InclusionItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InclusionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? isIncluded = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _$InclusionItemImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        isIncluded: null == isIncluded
            ? _value.isIncluded
            : isIncluded // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InclusionItemImpl implements _InclusionItem {
  const _$InclusionItemImpl({
    required this.text,
    required this.isIncluded,
    required this.orderIndex,
  });

  factory _$InclusionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$InclusionItemImplFromJson(json);

  @override
  final String text;
  @override
  final bool isIncluded;
  @override
  final int orderIndex;

  @override
  String toString() {
    return 'InclusionItem(text: $text, isIncluded: $isIncluded, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InclusionItemImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isIncluded, isIncluded) ||
                other.isIncluded == isIncluded) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, isIncluded, orderIndex);

  /// Create a copy of InclusionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InclusionItemImplCopyWith<_$InclusionItemImpl> get copyWith =>
      __$$InclusionItemImplCopyWithImpl<_$InclusionItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InclusionItemImplToJson(this);
  }
}

abstract class _InclusionItem implements InclusionItem {
  const factory _InclusionItem({
    required final String text,
    required final bool isIncluded,
    required final int orderIndex,
  }) = _$InclusionItemImpl;

  factory _InclusionItem.fromJson(Map<String, dynamic> json) =
      _$InclusionItemImpl.fromJson;

  @override
  String get text;
  @override
  bool get isIncluded;
  @override
  int get orderIndex;

  /// Create a copy of InclusionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InclusionItemImplCopyWith<_$InclusionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ImportantInfoItem _$ImportantInfoItemFromJson(Map<String, dynamic> json) {
  return _ImportantInfoItem.fromJson(json);
}

/// @nodoc
mixin _$ImportantInfoItem {
  String get text => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this ImportantInfoItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ImportantInfoItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ImportantInfoItemCopyWith<ImportantInfoItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ImportantInfoItemCopyWith<$Res> {
  factory $ImportantInfoItemCopyWith(
    ImportantInfoItem value,
    $Res Function(ImportantInfoItem) then,
  ) = _$ImportantInfoItemCopyWithImpl<$Res, ImportantInfoItem>;
  @useResult
  $Res call({String text, int orderIndex});
}

/// @nodoc
class _$ImportantInfoItemCopyWithImpl<$Res, $Val extends ImportantInfoItem>
    implements $ImportantInfoItemCopyWith<$Res> {
  _$ImportantInfoItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ImportantInfoItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? orderIndex = null}) {
    return _then(
      _value.copyWith(
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ImportantInfoItemImplCopyWith<$Res>
    implements $ImportantInfoItemCopyWith<$Res> {
  factory _$$ImportantInfoItemImplCopyWith(
    _$ImportantInfoItemImpl value,
    $Res Function(_$ImportantInfoItemImpl) then,
  ) = __$$ImportantInfoItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, int orderIndex});
}

/// @nodoc
class __$$ImportantInfoItemImplCopyWithImpl<$Res>
    extends _$ImportantInfoItemCopyWithImpl<$Res, _$ImportantInfoItemImpl>
    implements _$$ImportantInfoItemImplCopyWith<$Res> {
  __$$ImportantInfoItemImplCopyWithImpl(
    _$ImportantInfoItemImpl _value,
    $Res Function(_$ImportantInfoItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ImportantInfoItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? orderIndex = null}) {
    return _then(
      _$ImportantInfoItemImpl(
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ImportantInfoItemImpl implements _ImportantInfoItem {
  const _$ImportantInfoItemImpl({required this.text, required this.orderIndex});

  factory _$ImportantInfoItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImportantInfoItemImplFromJson(json);

  @override
  final String text;
  @override
  final int orderIndex;

  @override
  String toString() {
    return 'ImportantInfoItem(text: $text, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImportantInfoItemImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, orderIndex);

  /// Create a copy of ImportantInfoItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ImportantInfoItemImplCopyWith<_$ImportantInfoItemImpl> get copyWith =>
      __$$ImportantInfoItemImplCopyWithImpl<_$ImportantInfoItemImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ImportantInfoItemImplToJson(this);
  }
}

abstract class _ImportantInfoItem implements ImportantInfoItem {
  const factory _ImportantInfoItem({
    required final String text,
    required final int orderIndex,
  }) = _$ImportantInfoItemImpl;

  factory _ImportantInfoItem.fromJson(Map<String, dynamic> json) =
      _$ImportantInfoItemImpl.fromJson;

  @override
  String get text;
  @override
  int get orderIndex;

  /// Create a copy of ImportantInfoItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ImportantInfoItemImplCopyWith<_$ImportantInfoItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
