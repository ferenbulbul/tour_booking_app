// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_info_wrapper.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CustomerInfoWrapper _$CustomerInfoWrapperFromJson(Map<String, dynamic> json) {
  return _CustomerInfoWrapper.fromJson(json);
}

/// @nodoc
mixin _$CustomerInfoWrapper {
  List<CustomerInfo> get customerInfo => throw _privateConstructorUsedError;

  /// Serializes this CustomerInfoWrapper to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomerInfoWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerInfoWrapperCopyWith<CustomerInfoWrapper> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerInfoWrapperCopyWith<$Res> {
  factory $CustomerInfoWrapperCopyWith(
    CustomerInfoWrapper value,
    $Res Function(CustomerInfoWrapper) then,
  ) = _$CustomerInfoWrapperCopyWithImpl<$Res, CustomerInfoWrapper>;
  @useResult
  $Res call({List<CustomerInfo> customerInfo});
}

/// @nodoc
class _$CustomerInfoWrapperCopyWithImpl<$Res, $Val extends CustomerInfoWrapper>
    implements $CustomerInfoWrapperCopyWith<$Res> {
  _$CustomerInfoWrapperCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerInfoWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerInfo = null}) {
    return _then(
      _value.copyWith(
            customerInfo: null == customerInfo
                ? _value.customerInfo
                : customerInfo // ignore: cast_nullable_to_non_nullable
                      as List<CustomerInfo>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerInfoWrapperImplCopyWith<$Res>
    implements $CustomerInfoWrapperCopyWith<$Res> {
  factory _$$CustomerInfoWrapperImplCopyWith(
    _$CustomerInfoWrapperImpl value,
    $Res Function(_$CustomerInfoWrapperImpl) then,
  ) = __$$CustomerInfoWrapperImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CustomerInfo> customerInfo});
}

/// @nodoc
class __$$CustomerInfoWrapperImplCopyWithImpl<$Res>
    extends _$CustomerInfoWrapperCopyWithImpl<$Res, _$CustomerInfoWrapperImpl>
    implements _$$CustomerInfoWrapperImplCopyWith<$Res> {
  __$$CustomerInfoWrapperImplCopyWithImpl(
    _$CustomerInfoWrapperImpl _value,
    $Res Function(_$CustomerInfoWrapperImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerInfoWrapper
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? customerInfo = null}) {
    return _then(
      _$CustomerInfoWrapperImpl(
        customerInfo: null == customerInfo
            ? _value._customerInfo
            : customerInfo // ignore: cast_nullable_to_non_nullable
                  as List<CustomerInfo>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomerInfoWrapperImpl implements _CustomerInfoWrapper {
  const _$CustomerInfoWrapperImpl({
    required final List<CustomerInfo> customerInfo,
  }) : _customerInfo = customerInfo;

  factory _$CustomerInfoWrapperImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomerInfoWrapperImplFromJson(json);

  final List<CustomerInfo> _customerInfo;
  @override
  List<CustomerInfo> get customerInfo {
    if (_customerInfo is EqualUnmodifiableListView) return _customerInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_customerInfo);
  }

  @override
  String toString() {
    return 'CustomerInfoWrapper(customerInfo: $customerInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerInfoWrapperImpl &&
            const DeepCollectionEquality().equals(
              other._customerInfo,
              _customerInfo,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_customerInfo),
  );

  /// Create a copy of CustomerInfoWrapper
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerInfoWrapperImplCopyWith<_$CustomerInfoWrapperImpl> get copyWith =>
      __$$CustomerInfoWrapperImplCopyWithImpl<_$CustomerInfoWrapperImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomerInfoWrapperImplToJson(this);
  }
}

abstract class _CustomerInfoWrapper implements CustomerInfoWrapper {
  const factory _CustomerInfoWrapper({
    required final List<CustomerInfo> customerInfo,
  }) = _$CustomerInfoWrapperImpl;

  factory _CustomerInfoWrapper.fromJson(Map<String, dynamic> json) =
      _$CustomerInfoWrapperImpl.fromJson;

  @override
  List<CustomerInfo> get customerInfo;

  /// Create a copy of CustomerInfoWrapper
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerInfoWrapperImplCopyWith<_$CustomerInfoWrapperImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
