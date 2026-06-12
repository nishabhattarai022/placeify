/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Metadata for creating a vendor product with an uploaded photo.
abstract class VendorProductUploadInput implements _i1.SerializableModel {
  VendorProductUploadInput._({
    required this.name,
    required this.description,
    required this.price,
    required this.materials,
    required this.widthCm,
    required this.depthCm,
    required this.heightCm,
    required this.careInstructions,
    this.categoryId,
    this.weightKg,
    this.assemblyNote,
    this.warranty,
    bool? generateModel3d,
  }) : generateModel3d = generateModel3d ?? false;

  factory VendorProductUploadInput({
    required String name,
    required String description,
    required double price,
    required String materials,
    required double widthCm,
    required double depthCm,
    required double heightCm,
    required String careInstructions,
    int? categoryId,
    double? weightKg,
    String? assemblyNote,
    String? warranty,
    bool? generateModel3d,
  }) = _VendorProductUploadInputImpl;

  factory VendorProductUploadInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return VendorProductUploadInput(
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      price: (jsonSerialization['price'] as num).toDouble(),
      materials: jsonSerialization['materials'] as String,
      widthCm: (jsonSerialization['widthCm'] as num).toDouble(),
      depthCm: (jsonSerialization['depthCm'] as num).toDouble(),
      heightCm: (jsonSerialization['heightCm'] as num).toDouble(),
      careInstructions: jsonSerialization['careInstructions'] as String,
      categoryId: jsonSerialization['categoryId'] as int?,
      weightKg: (jsonSerialization['weightKg'] as num?)?.toDouble(),
      assemblyNote: jsonSerialization['assemblyNote'] as String?,
      warranty: jsonSerialization['warranty'] as String?,
      generateModel3d: jsonSerialization['generateModel3d'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['generateModel3d'],
            ),
    );
  }

  String name;

  String description;

  double price;

  String materials;

  double widthCm;

  double depthCm;

  double heightCm;

  String careInstructions;

  int? categoryId;

  double? weightKg;

  String? assemblyNote;

  String? warranty;

  bool generateModel3d;

  /// Returns a shallow copy of this [VendorProductUploadInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProductUploadInput copyWith({
    String? name,
    String? description,
    double? price,
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    String? careInstructions,
    int? categoryId,
    double? weightKg,
    String? assemblyNote,
    String? warranty,
    bool? generateModel3d,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProductUploadInput',
      'name': name,
      'description': description,
      'price': price,
      'materials': materials,
      'widthCm': widthCm,
      'depthCm': depthCm,
      'heightCm': heightCm,
      'careInstructions': careInstructions,
      if (categoryId != null) 'categoryId': categoryId,
      if (weightKg != null) 'weightKg': weightKg,
      if (assemblyNote != null) 'assemblyNote': assemblyNote,
      if (warranty != null) 'warranty': warranty,
      'generateModel3d': generateModel3d,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorProductUploadInputImpl extends VendorProductUploadInput {
  _VendorProductUploadInputImpl({
    required String name,
    required String description,
    required double price,
    required String materials,
    required double widthCm,
    required double depthCm,
    required double heightCm,
    required String careInstructions,
    int? categoryId,
    double? weightKg,
    String? assemblyNote,
    String? warranty,
    bool? generateModel3d,
  }) : super._(
         name: name,
         description: description,
         price: price,
         materials: materials,
         widthCm: widthCm,
         depthCm: depthCm,
         heightCm: heightCm,
         careInstructions: careInstructions,
         categoryId: categoryId,
         weightKg: weightKg,
         assemblyNote: assemblyNote,
         warranty: warranty,
         generateModel3d: generateModel3d,
       );

  /// Returns a shallow copy of this [VendorProductUploadInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProductUploadInput copyWith({
    String? name,
    String? description,
    double? price,
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    String? careInstructions,
    Object? categoryId = _Undefined,
    Object? weightKg = _Undefined,
    Object? assemblyNote = _Undefined,
    Object? warranty = _Undefined,
    bool? generateModel3d,
  }) {
    return VendorProductUploadInput(
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      materials: materials ?? this.materials,
      widthCm: widthCm ?? this.widthCm,
      depthCm: depthCm ?? this.depthCm,
      heightCm: heightCm ?? this.heightCm,
      careInstructions: careInstructions ?? this.careInstructions,
      categoryId: categoryId is int? ? categoryId : this.categoryId,
      weightKg: weightKg is double? ? weightKg : this.weightKg,
      assemblyNote: assemblyNote is String? ? assemblyNote : this.assemblyNote,
      warranty: warranty is String? ? warranty : this.warranty,
      generateModel3d: generateModel3d ?? this.generateModel3d,
    );
  }
}
