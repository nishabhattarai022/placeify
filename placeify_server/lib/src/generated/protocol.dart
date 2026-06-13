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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i3;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i4;
import 'admin.dart' as _i5;
import 'admin_type.dart' as _i6;
import 'ar_session.dart' as _i7;
import 'cart.dart' as _i8;
import 'cart_item.dart' as _i9;
import 'category.dart' as _i10;
import 'checkout_request.dart' as _i11;
import 'checkout_result.dart' as _i12;
import 'complaint.dart' as _i13;
import 'complaint_status.dart' as _i14;
import 'customization_request.dart' as _i15;
import 'greetings/greeting.dart' as _i16;
import 'notification_preference.dart' as _i17;
import 'order.dart' as _i18;
import 'order_item.dart' as _i19;
import 'order_page.dart' as _i20;
import 'order_status.dart' as _i21;
import 'pagination_input.dart' as _i22;
import 'product.dart' as _i23;
import 'product_page.dart' as _i24;
import 'product_search_input.dart' as _i25;
import 'product_status.dart' as _i26;
import 'request_status.dart' as _i27;
import 'review.dart' as _i28;
import 'user.dart' as _i29;
import 'user_account_status.dart' as _i30;
import 'user_ar_session_summary.dart' as _i31;
import 'user_dashboard.dart' as _i32;
import 'user_order_summary.dart' as _i33;
import 'user_role.dart' as _i34;
import 'vendor.dart' as _i35;
import 'vendor_dashboard.dart' as _i36;
import 'vendor_order_line_item.dart' as _i37;
import 'vendor_order_summary.dart' as _i38;
import 'vendor_product_stat.dart' as _i39;
import 'vendor_product_upload_input.dart' as _i40;
import 'vendor_shop_order.dart' as _i41;
import 'wishlist_item.dart' as _i42;
import 'wishlist_page.dart' as _i43;
import 'package:placeify_server/src/generated/user_role.dart' as _i44;
import 'package:placeify_server/src/generated/user_order_summary.dart' as _i45;
import 'package:placeify_server/src/generated/user_ar_session_summary.dart'
    as _i46;
import 'package:placeify_server/src/generated/complaint.dart' as _i47;
import 'package:placeify_server/src/generated/ar_session.dart' as _i48;
import 'package:placeify_server/src/generated/cart_item.dart' as _i49;
import 'package:placeify_server/src/generated/category.dart' as _i50;
import 'package:placeify_server/src/generated/product.dart' as _i51;
import 'package:placeify_server/src/generated/review.dart' as _i52;
import 'package:placeify_server/src/generated/vendor_shop_order.dart' as _i53;
export 'admin.dart';
export 'admin_type.dart';
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'checkout_request.dart';
export 'checkout_result.dart';
export 'complaint.dart';
export 'complaint_status.dart';
export 'customization_request.dart';
export 'greetings/greeting.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_status.dart';
export 'pagination_input.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'request_status.dart';
export 'review.dart';
export 'user.dart';
export 'user_account_status.dart';
export 'user_ar_session_summary.dart';
export 'user_dashboard.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_dashboard.dart';
export 'vendor_order_line_item.dart';
export 'vendor_order_summary.dart';
export 'vendor_product_stat.dart';
export 'vendor_product_upload_input.dart';
export 'vendor_shop_order.dart';
export 'wishlist_item.dart';
export 'wishlist_page.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'admin',
      dartName: 'Admin',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'fullName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'phoneNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'adminType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AdminType',
          columnDefault: '\'moderator\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'lastLoginAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'admin_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'admin_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'ar_session',
      dartName: 'ARSession',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ar_session_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'startedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'deviceInfo',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'snapshotUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'ar_session_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'ar_session_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ar_session_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'ar_session_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'ar_session_product_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cart',
      dartName: 'Cart',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'cart_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'cart_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cart_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'cart_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cart_item',
      dartName: 'CartItem',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'cart_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'cartId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
        ),
        _i2.ColumnDefinition(
          name: 'unitPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'cart_item_fk_0',
          columns: ['cartId'],
          referenceTable: 'cart',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'cart_item_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cart_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'cart_item_cart_product',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'cartId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'category',
      dartName: 'Category',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'category_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'category_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'category_name',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'name',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'complaint',
      dartName: 'Complaint',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'complaint_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'reportedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ComplaintStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'resolvedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'resolvedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_0',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_1',
          columns: ['reportedById'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_2',
          columns: ['resolvedById'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'complaint_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_product_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_reported_by_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'reportedById',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'complaint_status',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'customization_request',
      dartName: 'CustomizationRequest',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'customization_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'vendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'attachmentUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RequestStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'customization_request_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'customization_request_fk_1',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'customization_request_fk_2',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'customization_request_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'customization_request_vendor_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'customization_request_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'notification_preference',
      dartName: 'NotificationPreference',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'notification_preference_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderUpdates',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'refundStatus',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'arReminders',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'priceDropAlerts',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'vendorMessages',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'promotions',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'notification_preference_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'notification_preference_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'notification_preference_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order',
      dartName: 'Order',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'order_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:OrderStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'totalAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'shippingAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'placedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_item',
      dartName: 'OrderItem',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'order_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'vendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'unitPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_item_fk_2',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'order_item_order_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'product',
      dartName: 'Product',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'product_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'vendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'categoryId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'price',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'materials',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'widthCm',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'depthCm',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'heightCm',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'weightKg',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'assemblyNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'careInstructions',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'warranty',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'model3dUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'thumbnailUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProductStatus',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'removedReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'removedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'removedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'product_fk_0',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'product_fk_1',
          columns: ['categoryId'],
          referenceTable: 'category',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'product_fk_2',
          columns: ['removedById'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'product_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'product_vendor_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'product_status',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'review',
      dartName: 'Review',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'review_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'comment',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'review_fk_2',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'review_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'review_user_product_order',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'review_product_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user',
      dartName: 'User',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'address',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'profileImageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:UserRole',
          columnDefault: '\'consumer\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:UserAccountStatus',
          columnDefault: '\'approved\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'approvedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'statusChangedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'user_fk_1',
          columns: ['approvedById'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'user_fk_2',
          columns: ['statusChangedById'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_auth_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'authUserId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_role',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'role',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'user_status',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'status',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'vendor',
      dartName: 'Vendor',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'shopName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'businessAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'logoUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'rating',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'approvedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'approvedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'updatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'vendor_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'vendor_fk_1',
          columns: ['approvedById'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'vendor_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'vendor_user_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'wishlist_item',
      dartName: 'WishlistItem',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'wishlist_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'productId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'wishlist_item_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'wishlist_item_fk_1',
          columns: ['productId'],
          referenceTable: 'product',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'wishlist_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'wishlist_item_user_product',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'productId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i5.Admin) {
      return _i5.Admin.fromJson(data) as T;
    }
    if (t == _i6.AdminType) {
      return _i6.AdminType.fromJson(data) as T;
    }
    if (t == _i7.ARSession) {
      return _i7.ARSession.fromJson(data) as T;
    }
    if (t == _i8.Cart) {
      return _i8.Cart.fromJson(data) as T;
    }
    if (t == _i9.CartItem) {
      return _i9.CartItem.fromJson(data) as T;
    }
    if (t == _i10.Category) {
      return _i10.Category.fromJson(data) as T;
    }
    if (t == _i11.CheckoutRequest) {
      return _i11.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i12.CheckoutResult) {
      return _i12.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i13.Complaint) {
      return _i13.Complaint.fromJson(data) as T;
    }
    if (t == _i14.ComplaintStatus) {
      return _i14.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i15.CustomizationRequest) {
      return _i15.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i16.Greeting) {
      return _i16.Greeting.fromJson(data) as T;
    }
    if (t == _i17.NotificationPreference) {
      return _i17.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i18.Order) {
      return _i18.Order.fromJson(data) as T;
    }
    if (t == _i19.OrderItem) {
      return _i19.OrderItem.fromJson(data) as T;
    }
    if (t == _i20.OrderPage) {
      return _i20.OrderPage.fromJson(data) as T;
    }
    if (t == _i21.OrderStatus) {
      return _i21.OrderStatus.fromJson(data) as T;
    }
    if (t == _i22.PaginationInput) {
      return _i22.PaginationInput.fromJson(data) as T;
    }
    if (t == _i23.Product) {
      return _i23.Product.fromJson(data) as T;
    }
    if (t == _i24.ProductPage) {
      return _i24.ProductPage.fromJson(data) as T;
    }
    if (t == _i25.ProductSearchInput) {
      return _i25.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i26.ProductStatus) {
      return _i26.ProductStatus.fromJson(data) as T;
    }
    if (t == _i27.RequestStatus) {
      return _i27.RequestStatus.fromJson(data) as T;
    }
    if (t == _i28.Review) {
      return _i28.Review.fromJson(data) as T;
    }
    if (t == _i29.User) {
      return _i29.User.fromJson(data) as T;
    }
    if (t == _i30.UserAccountStatus) {
      return _i30.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i31.UserArSessionSummary) {
      return _i31.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i32.UserDashboard) {
      return _i32.UserDashboard.fromJson(data) as T;
    }
    if (t == _i33.UserOrderSummary) {
      return _i33.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i34.UserRole) {
      return _i34.UserRole.fromJson(data) as T;
    }
    if (t == _i35.Vendor) {
      return _i35.Vendor.fromJson(data) as T;
    }
    if (t == _i36.VendorDashboard) {
      return _i36.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i37.VendorOrderLineItem) {
      return _i37.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i38.VendorOrderSummary) {
      return _i38.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i39.VendorProductStat) {
      return _i39.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i40.VendorProductUploadInput) {
      return _i40.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i41.VendorShopOrder) {
      return _i41.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i42.WishlistItem) {
      return _i42.WishlistItem.fromJson(data) as T;
    }
    if (t == _i43.WishlistPage) {
      return _i43.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Admin?>()) {
      return (data != null ? _i5.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminType?>()) {
      return (data != null ? _i6.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ARSession?>()) {
      return (data != null ? _i7.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Cart?>()) {
      return (data != null ? _i8.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CartItem?>()) {
      return (data != null ? _i9.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Category?>()) {
      return (data != null ? _i10.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CheckoutRequest?>()) {
      return (data != null ? _i11.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CheckoutResult?>()) {
      return (data != null ? _i12.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.Complaint?>()) {
      return (data != null ? _i13.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ComplaintStatus?>()) {
      return (data != null ? _i14.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CustomizationRequest?>()) {
      return (data != null ? _i15.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.Greeting?>()) {
      return (data != null ? _i16.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.NotificationPreference?>()) {
      return (data != null ? _i17.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.Order?>()) {
      return (data != null ? _i18.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.OrderItem?>()) {
      return (data != null ? _i19.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.OrderPage?>()) {
      return (data != null ? _i20.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.OrderStatus?>()) {
      return (data != null ? _i21.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PaginationInput?>()) {
      return (data != null ? _i22.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Product?>()) {
      return (data != null ? _i23.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ProductPage?>()) {
      return (data != null ? _i24.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ProductSearchInput?>()) {
      return (data != null ? _i25.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.ProductStatus?>()) {
      return (data != null ? _i26.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.RequestStatus?>()) {
      return (data != null ? _i27.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Review?>()) {
      return (data != null ? _i28.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.User?>()) {
      return (data != null ? _i29.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.UserAccountStatus?>()) {
      return (data != null ? _i30.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.UserArSessionSummary?>()) {
      return (data != null ? _i31.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.UserDashboard?>()) {
      return (data != null ? _i32.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.UserOrderSummary?>()) {
      return (data != null ? _i33.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.UserRole?>()) {
      return (data != null ? _i34.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.Vendor?>()) {
      return (data != null ? _i35.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.VendorDashboard?>()) {
      return (data != null ? _i36.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.VendorOrderLineItem?>()) {
      return (data != null ? _i37.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.VendorOrderSummary?>()) {
      return (data != null ? _i38.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.VendorProductStat?>()) {
      return (data != null ? _i39.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.VendorProductUploadInput?>()) {
      return (data != null
              ? _i40.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i41.VendorShopOrder?>()) {
      return (data != null ? _i41.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.WishlistItem?>()) {
      return (data != null ? _i42.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.WishlistPage?>()) {
      return (data != null ? _i43.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i18.Order>) {
      return (data as List).map((e) => deserialize<_i18.Order>(e)).toList()
          as T;
    }
    if (t == List<_i23.Product>) {
      return (data as List).map((e) => deserialize<_i23.Product>(e)).toList()
          as T;
    }
    if (t == List<_i38.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i38.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i39.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i39.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i37.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i42.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i42.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i44.UserRole>) {
      return (data as List).map((e) => deserialize<_i44.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i45.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i45.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i46.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i46.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i47.Complaint>) {
      return (data as List).map((e) => deserialize<_i47.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i48.ARSession>) {
      return (data as List).map((e) => deserialize<_i48.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i49.CartItem>) {
      return (data as List).map((e) => deserialize<_i49.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i50.Category>) {
      return (data as List).map((e) => deserialize<_i50.Category>(e)).toList()
          as T;
    }
    if (t == List<_i51.Product>) {
      return (data as List).map((e) => deserialize<_i51.Product>(e)).toList()
          as T;
    }
    if (t == List<_i52.Review>) {
      return (data as List).map((e) => deserialize<_i52.Review>(e)).toList()
          as T;
    }
    if (t == List<_i53.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i53.VendorShopOrder>(e))
              .toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.Admin => 'Admin',
      _i6.AdminType => 'AdminType',
      _i7.ARSession => 'ARSession',
      _i8.Cart => 'Cart',
      _i9.CartItem => 'CartItem',
      _i10.Category => 'Category',
      _i11.CheckoutRequest => 'CheckoutRequest',
      _i12.CheckoutResult => 'CheckoutResult',
      _i13.Complaint => 'Complaint',
      _i14.ComplaintStatus => 'ComplaintStatus',
      _i15.CustomizationRequest => 'CustomizationRequest',
      _i16.Greeting => 'Greeting',
      _i17.NotificationPreference => 'NotificationPreference',
      _i18.Order => 'Order',
      _i19.OrderItem => 'OrderItem',
      _i20.OrderPage => 'OrderPage',
      _i21.OrderStatus => 'OrderStatus',
      _i22.PaginationInput => 'PaginationInput',
      _i23.Product => 'Product',
      _i24.ProductPage => 'ProductPage',
      _i25.ProductSearchInput => 'ProductSearchInput',
      _i26.ProductStatus => 'ProductStatus',
      _i27.RequestStatus => 'RequestStatus',
      _i28.Review => 'Review',
      _i29.User => 'User',
      _i30.UserAccountStatus => 'UserAccountStatus',
      _i31.UserArSessionSummary => 'UserArSessionSummary',
      _i32.UserDashboard => 'UserDashboard',
      _i33.UserOrderSummary => 'UserOrderSummary',
      _i34.UserRole => 'UserRole',
      _i35.Vendor => 'Vendor',
      _i36.VendorDashboard => 'VendorDashboard',
      _i37.VendorOrderLineItem => 'VendorOrderLineItem',
      _i38.VendorOrderSummary => 'VendorOrderSummary',
      _i39.VendorProductStat => 'VendorProductStat',
      _i40.VendorProductUploadInput => 'VendorProductUploadInput',
      _i41.VendorShopOrder => 'VendorShopOrder',
      _i42.WishlistItem => 'WishlistItem',
      _i43.WishlistPage => 'WishlistPage',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('placeify.', '');
    }

    switch (data) {
      case _i5.Admin():
        return 'Admin';
      case _i6.AdminType():
        return 'AdminType';
      case _i7.ARSession():
        return 'ARSession';
      case _i8.Cart():
        return 'Cart';
      case _i9.CartItem():
        return 'CartItem';
      case _i10.Category():
        return 'Category';
      case _i11.CheckoutRequest():
        return 'CheckoutRequest';
      case _i12.CheckoutResult():
        return 'CheckoutResult';
      case _i13.Complaint():
        return 'Complaint';
      case _i14.ComplaintStatus():
        return 'ComplaintStatus';
      case _i15.CustomizationRequest():
        return 'CustomizationRequest';
      case _i16.Greeting():
        return 'Greeting';
      case _i17.NotificationPreference():
        return 'NotificationPreference';
      case _i18.Order():
        return 'Order';
      case _i19.OrderItem():
        return 'OrderItem';
      case _i20.OrderPage():
        return 'OrderPage';
      case _i21.OrderStatus():
        return 'OrderStatus';
      case _i22.PaginationInput():
        return 'PaginationInput';
      case _i23.Product():
        return 'Product';
      case _i24.ProductPage():
        return 'ProductPage';
      case _i25.ProductSearchInput():
        return 'ProductSearchInput';
      case _i26.ProductStatus():
        return 'ProductStatus';
      case _i27.RequestStatus():
        return 'RequestStatus';
      case _i28.Review():
        return 'Review';
      case _i29.User():
        return 'User';
      case _i30.UserAccountStatus():
        return 'UserAccountStatus';
      case _i31.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i32.UserDashboard():
        return 'UserDashboard';
      case _i33.UserOrderSummary():
        return 'UserOrderSummary';
      case _i34.UserRole():
        return 'UserRole';
      case _i35.Vendor():
        return 'Vendor';
      case _i36.VendorDashboard():
        return 'VendorDashboard';
      case _i37.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i38.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i39.VendorProductStat():
        return 'VendorProductStat';
      case _i40.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i41.VendorShopOrder():
        return 'VendorShopOrder';
      case _i42.WishlistItem():
        return 'WishlistItem';
      case _i43.WishlistPage():
        return 'WishlistPage';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Admin') {
      return deserialize<_i5.Admin>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i6.AdminType>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i7.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i8.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i9.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i10.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i11.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i12.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i13.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i14.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i15.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i16.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i17.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i18.Order>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i19.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i20.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i21.OrderStatus>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i22.PaginationInput>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i23.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i24.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i25.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i26.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i27.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i28.Review>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i29.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i30.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i31.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i32.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i33.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i34.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i35.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i36.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i37.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i38.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i39.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i40.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i41.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i42.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i43.WishlistPage>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.Admin:
        return _i5.Admin.t;
      case _i7.ARSession:
        return _i7.ARSession.t;
      case _i8.Cart:
        return _i8.Cart.t;
      case _i9.CartItem:
        return _i9.CartItem.t;
      case _i10.Category:
        return _i10.Category.t;
      case _i13.Complaint:
        return _i13.Complaint.t;
      case _i15.CustomizationRequest:
        return _i15.CustomizationRequest.t;
      case _i17.NotificationPreference:
        return _i17.NotificationPreference.t;
      case _i18.Order:
        return _i18.Order.t;
      case _i19.OrderItem:
        return _i19.OrderItem.t;
      case _i23.Product:
        return _i23.Product.t;
      case _i28.Review:
        return _i28.Review.t;
      case _i29.User:
        return _i29.User.t;
      case _i35.Vendor:
        return _i35.Vendor.t;
      case _i42.WishlistItem:
        return _i42.WishlistItem.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'placeify';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
