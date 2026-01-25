import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';

part 'customer_info_wrapper.freezed.dart';
part 'customer_info_wrapper.g.dart';

@freezed
class CustomerInfoWrapper with _$CustomerInfoWrapper {
  const factory CustomerInfoWrapper({
    required List<CustomerInfo> customerInfo,
  }) = _CustomerInfoWrapper;

  factory CustomerInfoWrapper.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoWrapperFromJson(json);
}
