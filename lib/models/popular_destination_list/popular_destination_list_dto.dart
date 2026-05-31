import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tour_booking/models/popular_destination/popular_destination_dto.dart';

part 'popular_destination_list_dto.freezed.dart';
part 'popular_destination_list_dto.g.dart';

@freezed
class PopularDestinationListDto with _$PopularDestinationListDto {
  const factory PopularDestinationListDto({
    @JsonKey(name: 'popularDestinations')
    @Default([])
    List<PopularDestinationDto> popularDestinations,
  }) = _PopularDestinationListDto;

  factory PopularDestinationListDto.fromJson(Map<String, dynamic> json) =>
      _$PopularDestinationListDtoFromJson(json);
}
