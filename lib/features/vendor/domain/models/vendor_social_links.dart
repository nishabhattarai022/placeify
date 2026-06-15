import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_social_links.freezed.dart';
part 'vendor_social_links.g.dart';

@freezed
abstract class VendorSocialLinks with _$VendorSocialLinks {
  const factory VendorSocialLinks({
    @Default('') String facebook,
    @Default('') String instagram,
    @Default('') String website,
  }) = _VendorSocialLinks;

  factory VendorSocialLinks.fromJson(Map<String, dynamic> json) =>
      _$VendorSocialLinksFromJson(json);
}
