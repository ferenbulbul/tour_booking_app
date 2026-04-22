// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) {
  return _BookingDto.fromJson(json);
}

/// @nodoc
mixin _$BookingDto {
  String get id => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get tourPointName => throw _privateConstructorUsedError;
  String get tourPointCity => throw _privateConstructorUsedError;
  String get tourPointDistrict => throw _privateConstructorUsedError;
  String get departureTime => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  num get tourPointPrice => throw _privateConstructorUsedError;
  String get guideName => throw _privateConstructorUsedError;
  num get guidePrice => throw _privateConstructorUsedError;
  num get totalPrice => throw _privateConstructorUsedError;
  String get vehicleBrand => throw _privateConstructorUsedError;
  int get seatCount => throw _privateConstructorUsedError;
  String get departureLocationDescription => throw _privateConstructorUsedError;
  String get departureCity => throw _privateConstructorUsedError;
  String get departureDistrict => throw _privateConstructorUsedError;
  String get departureDate => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  bool? get canRate => throw _privateConstructorUsedError;
  String? get ratingRequestId => throw _privateConstructorUsedError;
  String? get ratingToken => throw _privateConstructorUsedError;
  int get bookingType => throw _privateConstructorUsedError;
  String? get pickupAddress => throw _privateConstructorUsedError;
  String? get dropoffAddress => throw _privateConstructorUsedError;
  double? get distanceKm => throw _privateConstructorUsedError;
  String? get pickupTime => throw _privateConstructorUsedError;

  /// Serializes this BookingDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookingDtoCopyWith<BookingDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookingDtoCopyWith<$Res> {
  factory $BookingDtoCopyWith(
    BookingDto value,
    $Res Function(BookingDto) then,
  ) = _$BookingDtoCopyWithImpl<$Res, BookingDto>;
  @useResult
  $Res call({
    String id,
    String image,
    String tourPointName,
    String tourPointCity,
    String tourPointDistrict,
    String departureTime,
    String driverName,
    num tourPointPrice,
    String guideName,
    num guidePrice,
    num totalPrice,
    String vehicleBrand,
    int seatCount,
    String departureLocationDescription,
    String departureCity,
    String departureDistrict,
    String departureDate,
    String status,
    bool? canRate,
    String? ratingRequestId,
    String? ratingToken,
    int bookingType,
    String? pickupAddress,
    String? dropoffAddress,
    double? distanceKm,
    String? pickupTime,
  });
}

/// @nodoc
class _$BookingDtoCopyWithImpl<$Res, $Val extends BookingDto>
    implements $BookingDtoCopyWith<$Res> {
  _$BookingDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? image = null,
    Object? tourPointName = null,
    Object? tourPointCity = null,
    Object? tourPointDistrict = null,
    Object? departureTime = null,
    Object? driverName = null,
    Object? tourPointPrice = null,
    Object? guideName = null,
    Object? guidePrice = null,
    Object? totalPrice = null,
    Object? vehicleBrand = null,
    Object? seatCount = null,
    Object? departureLocationDescription = null,
    Object? departureCity = null,
    Object? departureDistrict = null,
    Object? departureDate = null,
    Object? status = null,
    Object? canRate = freezed,
    Object? ratingRequestId = freezed,
    Object? ratingToken = freezed,
    Object? bookingType = null,
    Object? pickupAddress = freezed,
    Object? dropoffAddress = freezed,
    Object? distanceKm = freezed,
    Object? pickupTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            image: null == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointName: null == tourPointName
                ? _value.tourPointName
                : tourPointName // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointCity: null == tourPointCity
                ? _value.tourPointCity
                : tourPointCity // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointDistrict: null == tourPointDistrict
                ? _value.tourPointDistrict
                : tourPointDistrict // ignore: cast_nullable_to_non_nullable
                      as String,
            departureTime: null == departureTime
                ? _value.departureTime
                : departureTime // ignore: cast_nullable_to_non_nullable
                      as String,
            driverName: null == driverName
                ? _value.driverName
                : driverName // ignore: cast_nullable_to_non_nullable
                      as String,
            tourPointPrice: null == tourPointPrice
                ? _value.tourPointPrice
                : tourPointPrice // ignore: cast_nullable_to_non_nullable
                      as num,
            guideName: null == guideName
                ? _value.guideName
                : guideName // ignore: cast_nullable_to_non_nullable
                      as String,
            guidePrice: null == guidePrice
                ? _value.guidePrice
                : guidePrice // ignore: cast_nullable_to_non_nullable
                      as num,
            totalPrice: null == totalPrice
                ? _value.totalPrice
                : totalPrice // ignore: cast_nullable_to_non_nullable
                      as num,
            vehicleBrand: null == vehicleBrand
                ? _value.vehicleBrand
                : vehicleBrand // ignore: cast_nullable_to_non_nullable
                      as String,
            seatCount: null == seatCount
                ? _value.seatCount
                : seatCount // ignore: cast_nullable_to_non_nullable
                      as int,
            departureLocationDescription: null == departureLocationDescription
                ? _value.departureLocationDescription
                : departureLocationDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            departureCity: null == departureCity
                ? _value.departureCity
                : departureCity // ignore: cast_nullable_to_non_nullable
                      as String,
            departureDistrict: null == departureDistrict
                ? _value.departureDistrict
                : departureDistrict // ignore: cast_nullable_to_non_nullable
                      as String,
            departureDate: null == departureDate
                ? _value.departureDate
                : departureDate // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            canRate: freezed == canRate
                ? _value.canRate
                : canRate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            ratingRequestId: freezed == ratingRequestId
                ? _value.ratingRequestId
                : ratingRequestId // ignore: cast_nullable_to_non_nullable
                      as String?,
            ratingToken: freezed == ratingToken
                ? _value.ratingToken
                : ratingToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            bookingType: null == bookingType
                ? _value.bookingType
                : bookingType // ignore: cast_nullable_to_non_nullable
                      as int,
            pickupAddress: freezed == pickupAddress
                ? _value.pickupAddress
                : pickupAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            dropoffAddress: freezed == dropoffAddress
                ? _value.dropoffAddress
                : dropoffAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            distanceKm: freezed == distanceKm
                ? _value.distanceKm
                : distanceKm // ignore: cast_nullable_to_non_nullable
                      as double?,
            pickupTime: freezed == pickupTime
                ? _value.pickupTime
                : pickupTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookingDtoImplCopyWith<$Res>
    implements $BookingDtoCopyWith<$Res> {
  factory _$$BookingDtoImplCopyWith(
    _$BookingDtoImpl value,
    $Res Function(_$BookingDtoImpl) then,
  ) = __$$BookingDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String image,
    String tourPointName,
    String tourPointCity,
    String tourPointDistrict,
    String departureTime,
    String driverName,
    num tourPointPrice,
    String guideName,
    num guidePrice,
    num totalPrice,
    String vehicleBrand,
    int seatCount,
    String departureLocationDescription,
    String departureCity,
    String departureDistrict,
    String departureDate,
    String status,
    bool? canRate,
    String? ratingRequestId,
    String? ratingToken,
    int bookingType,
    String? pickupAddress,
    String? dropoffAddress,
    double? distanceKm,
    String? pickupTime,
  });
}

/// @nodoc
class __$$BookingDtoImplCopyWithImpl<$Res>
    extends _$BookingDtoCopyWithImpl<$Res, _$BookingDtoImpl>
    implements _$$BookingDtoImplCopyWith<$Res> {
  __$$BookingDtoImplCopyWithImpl(
    _$BookingDtoImpl _value,
    $Res Function(_$BookingDtoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? image = null,
    Object? tourPointName = null,
    Object? tourPointCity = null,
    Object? tourPointDistrict = null,
    Object? departureTime = null,
    Object? driverName = null,
    Object? tourPointPrice = null,
    Object? guideName = null,
    Object? guidePrice = null,
    Object? totalPrice = null,
    Object? vehicleBrand = null,
    Object? seatCount = null,
    Object? departureLocationDescription = null,
    Object? departureCity = null,
    Object? departureDistrict = null,
    Object? departureDate = null,
    Object? status = null,
    Object? canRate = freezed,
    Object? ratingRequestId = freezed,
    Object? ratingToken = freezed,
    Object? bookingType = null,
    Object? pickupAddress = freezed,
    Object? dropoffAddress = freezed,
    Object? distanceKm = freezed,
    Object? pickupTime = freezed,
  }) {
    return _then(
      _$BookingDtoImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        image: null == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointName: null == tourPointName
            ? _value.tourPointName
            : tourPointName // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointCity: null == tourPointCity
            ? _value.tourPointCity
            : tourPointCity // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointDistrict: null == tourPointDistrict
            ? _value.tourPointDistrict
            : tourPointDistrict // ignore: cast_nullable_to_non_nullable
                  as String,
        departureTime: null == departureTime
            ? _value.departureTime
            : departureTime // ignore: cast_nullable_to_non_nullable
                  as String,
        driverName: null == driverName
            ? _value.driverName
            : driverName // ignore: cast_nullable_to_non_nullable
                  as String,
        tourPointPrice: null == tourPointPrice
            ? _value.tourPointPrice
            : tourPointPrice // ignore: cast_nullable_to_non_nullable
                  as num,
        guideName: null == guideName
            ? _value.guideName
            : guideName // ignore: cast_nullable_to_non_nullable
                  as String,
        guidePrice: null == guidePrice
            ? _value.guidePrice
            : guidePrice // ignore: cast_nullable_to_non_nullable
                  as num,
        totalPrice: null == totalPrice
            ? _value.totalPrice
            : totalPrice // ignore: cast_nullable_to_non_nullable
                  as num,
        vehicleBrand: null == vehicleBrand
            ? _value.vehicleBrand
            : vehicleBrand // ignore: cast_nullable_to_non_nullable
                  as String,
        seatCount: null == seatCount
            ? _value.seatCount
            : seatCount // ignore: cast_nullable_to_non_nullable
                  as int,
        departureLocationDescription: null == departureLocationDescription
            ? _value.departureLocationDescription
            : departureLocationDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        departureCity: null == departureCity
            ? _value.departureCity
            : departureCity // ignore: cast_nullable_to_non_nullable
                  as String,
        departureDistrict: null == departureDistrict
            ? _value.departureDistrict
            : departureDistrict // ignore: cast_nullable_to_non_nullable
                  as String,
        departureDate: null == departureDate
            ? _value.departureDate
            : departureDate // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        canRate: freezed == canRate
            ? _value.canRate
            : canRate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        ratingRequestId: freezed == ratingRequestId
            ? _value.ratingRequestId
            : ratingRequestId // ignore: cast_nullable_to_non_nullable
                  as String?,
        ratingToken: freezed == ratingToken
            ? _value.ratingToken
            : ratingToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        bookingType: null == bookingType
            ? _value.bookingType
            : bookingType // ignore: cast_nullable_to_non_nullable
                  as int,
        pickupAddress: freezed == pickupAddress
            ? _value.pickupAddress
            : pickupAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        dropoffAddress: freezed == dropoffAddress
            ? _value.dropoffAddress
            : dropoffAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        distanceKm: freezed == distanceKm
            ? _value.distanceKm
            : distanceKm // ignore: cast_nullable_to_non_nullable
                  as double?,
        pickupTime: freezed == pickupTime
            ? _value.pickupTime
            : pickupTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookingDtoImpl implements _BookingDto {
  const _$BookingDtoImpl({
    required this.id,
    this.image = '',
    this.tourPointName = '',
    this.tourPointCity = '',
    this.tourPointDistrict = '',
    this.departureTime = '',
    this.driverName = '',
    this.tourPointPrice = 0,
    this.guideName = '',
    this.guidePrice = 0,
    this.totalPrice = 0,
    this.vehicleBrand = '',
    this.seatCount = 0,
    this.departureLocationDescription = '',
    this.departureCity = '',
    this.departureDistrict = '',
    this.departureDate = '',
    this.status = '',
    this.canRate,
    this.ratingRequestId,
    this.ratingToken,
    this.bookingType = 0,
    this.pickupAddress,
    this.dropoffAddress,
    this.distanceKm,
    this.pickupTime,
  });

  factory _$BookingDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookingDtoImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String image;
  @override
  @JsonKey()
  final String tourPointName;
  @override
  @JsonKey()
  final String tourPointCity;
  @override
  @JsonKey()
  final String tourPointDistrict;
  @override
  @JsonKey()
  final String departureTime;
  @override
  @JsonKey()
  final String driverName;
  @override
  @JsonKey()
  final num tourPointPrice;
  @override
  @JsonKey()
  final String guideName;
  @override
  @JsonKey()
  final num guidePrice;
  @override
  @JsonKey()
  final num totalPrice;
  @override
  @JsonKey()
  final String vehicleBrand;
  @override
  @JsonKey()
  final int seatCount;
  @override
  @JsonKey()
  final String departureLocationDescription;
  @override
  @JsonKey()
  final String departureCity;
  @override
  @JsonKey()
  final String departureDistrict;
  @override
  @JsonKey()
  final String departureDate;
  @override
  @JsonKey()
  final String status;
  @override
  final bool? canRate;
  @override
  final String? ratingRequestId;
  @override
  final String? ratingToken;
  @override
  @JsonKey()
  final int bookingType;
  @override
  final String? pickupAddress;
  @override
  final String? dropoffAddress;
  @override
  final double? distanceKm;
  @override
  final String? pickupTime;

  @override
  String toString() {
    return 'BookingDto(id: $id, image: $image, tourPointName: $tourPointName, tourPointCity: $tourPointCity, tourPointDistrict: $tourPointDistrict, departureTime: $departureTime, driverName: $driverName, tourPointPrice: $tourPointPrice, guideName: $guideName, guidePrice: $guidePrice, totalPrice: $totalPrice, vehicleBrand: $vehicleBrand, seatCount: $seatCount, departureLocationDescription: $departureLocationDescription, departureCity: $departureCity, departureDistrict: $departureDistrict, departureDate: $departureDate, status: $status, canRate: $canRate, ratingRequestId: $ratingRequestId, ratingToken: $ratingToken, bookingType: $bookingType, pickupAddress: $pickupAddress, dropoffAddress: $dropoffAddress, distanceKm: $distanceKm, pickupTime: $pickupTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookingDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.tourPointName, tourPointName) ||
                other.tourPointName == tourPointName) &&
            (identical(other.tourPointCity, tourPointCity) ||
                other.tourPointCity == tourPointCity) &&
            (identical(other.tourPointDistrict, tourPointDistrict) ||
                other.tourPointDistrict == tourPointDistrict) &&
            (identical(other.departureTime, departureTime) ||
                other.departureTime == departureTime) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.tourPointPrice, tourPointPrice) ||
                other.tourPointPrice == tourPointPrice) &&
            (identical(other.guideName, guideName) ||
                other.guideName == guideName) &&
            (identical(other.guidePrice, guidePrice) ||
                other.guidePrice == guidePrice) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.vehicleBrand, vehicleBrand) ||
                other.vehicleBrand == vehicleBrand) &&
            (identical(other.seatCount, seatCount) ||
                other.seatCount == seatCount) &&
            (identical(
                  other.departureLocationDescription,
                  departureLocationDescription,
                ) ||
                other.departureLocationDescription ==
                    departureLocationDescription) &&
            (identical(other.departureCity, departureCity) ||
                other.departureCity == departureCity) &&
            (identical(other.departureDistrict, departureDistrict) ||
                other.departureDistrict == departureDistrict) &&
            (identical(other.departureDate, departureDate) ||
                other.departureDate == departureDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.canRate, canRate) || other.canRate == canRate) &&
            (identical(other.ratingRequestId, ratingRequestId) ||
                other.ratingRequestId == ratingRequestId) &&
            (identical(other.ratingToken, ratingToken) ||
                other.ratingToken == ratingToken) &&
            (identical(other.bookingType, bookingType) ||
                other.bookingType == bookingType) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.dropoffAddress, dropoffAddress) ||
                other.dropoffAddress == dropoffAddress) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.pickupTime, pickupTime) ||
                other.pickupTime == pickupTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    image,
    tourPointName,
    tourPointCity,
    tourPointDistrict,
    departureTime,
    driverName,
    tourPointPrice,
    guideName,
    guidePrice,
    totalPrice,
    vehicleBrand,
    seatCount,
    departureLocationDescription,
    departureCity,
    departureDistrict,
    departureDate,
    status,
    canRate,
    ratingRequestId,
    ratingToken,
    bookingType,
    pickupAddress,
    dropoffAddress,
    distanceKm,
    pickupTime,
  ]);

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      __$$BookingDtoImplCopyWithImpl<_$BookingDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookingDtoImplToJson(this);
  }
}

abstract class _BookingDto implements BookingDto {
  const factory _BookingDto({
    required final String id,
    final String image,
    final String tourPointName,
    final String tourPointCity,
    final String tourPointDistrict,
    final String departureTime,
    final String driverName,
    final num tourPointPrice,
    final String guideName,
    final num guidePrice,
    final num totalPrice,
    final String vehicleBrand,
    final int seatCount,
    final String departureLocationDescription,
    final String departureCity,
    final String departureDistrict,
    final String departureDate,
    final String status,
    final bool? canRate,
    final String? ratingRequestId,
    final String? ratingToken,
    final int bookingType,
    final String? pickupAddress,
    final String? dropoffAddress,
    final double? distanceKm,
    final String? pickupTime,
  }) = _$BookingDtoImpl;

  factory _BookingDto.fromJson(Map<String, dynamic> json) =
      _$BookingDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get image;
  @override
  String get tourPointName;
  @override
  String get tourPointCity;
  @override
  String get tourPointDistrict;
  @override
  String get departureTime;
  @override
  String get driverName;
  @override
  num get tourPointPrice;
  @override
  String get guideName;
  @override
  num get guidePrice;
  @override
  num get totalPrice;
  @override
  String get vehicleBrand;
  @override
  int get seatCount;
  @override
  String get departureLocationDescription;
  @override
  String get departureCity;
  @override
  String get departureDistrict;
  @override
  String get departureDate;
  @override
  String get status;
  @override
  bool? get canRate;
  @override
  String? get ratingRequestId;
  @override
  String? get ratingToken;
  @override
  int get bookingType;
  @override
  String? get pickupAddress;
  @override
  String? get dropoffAddress;
  @override
  double? get distanceKm;
  @override
  String? get pickupTime;

  /// Create a copy of BookingDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookingDtoImplCopyWith<_$BookingDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
