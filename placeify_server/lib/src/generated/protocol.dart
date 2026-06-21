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
import 'admin_audit_log_summary.dart' as _i6;
import 'admin_platform_stats.dart' as _i7;
import 'admin_refund_request_summary.dart' as _i8;
import 'admin_type.dart' as _i9;
import 'admin_vendor_payout_summary.dart' as _i10;
import 'ar_session.dart' as _i11;
import 'cart.dart' as _i12;
import 'cart_item.dart' as _i13;
import 'category.dart' as _i14;
import 'checkout_request.dart' as _i15;
import 'checkout_result.dart' as _i16;
import 'complaint.dart' as _i17;
import 'complaint_status.dart' as _i18;
import 'customization_request.dart' as _i19;
import 'delivery_stage.dart' as _i20;
import 'greetings/greeting.dart' as _i21;
import 'notification_preference.dart' as _i22;
import 'order.dart' as _i23;
import 'order_delivery_update.dart' as _i24;
import 'order_item.dart' as _i25;
import 'order_page.dart' as _i26;
import 'order_status.dart' as _i27;
import 'order_vendor_payment.dart' as _i28;
import 'pagination_input.dart' as _i29;
import 'payment_transaction.dart' as _i30;
import 'payment_transaction_status.dart' as _i31;
import 'payment_update_summary.dart' as _i32;
import 'placeify_exception.dart' as _i33;
import 'platform_user_summary.dart' as _i34;
import 'product.dart' as _i35;
import 'product_page.dart' as _i36;
import 'product_search_input.dart' as _i37;
import 'product_status.dart' as _i38;
import 'refund_request.dart' as _i39;
import 'refund_request_summary.dart' as _i40;
import 'request_status.dart' as _i41;
import 'review.dart' as _i42;
import 'shop_listing_summary.dart' as _i43;
import 'user.dart' as _i44;
import 'user_account_status.dart' as _i45;
import 'user_ar_session_summary.dart' as _i46;
import 'user_dashboard.dart' as _i47;
import 'user_order_summary.dart' as _i48;
import 'user_role.dart' as _i49;
import 'vendor.dart' as _i50;
import 'vendor_application_detail.dart' as _i51;
import 'vendor_application_summary.dart' as _i52;
import 'vendor_bank_details.dart' as _i53;
import 'vendor_bank_details_input.dart' as _i54;
import 'vendor_dashboard.dart' as _i55;
import 'vendor_document.dart' as _i56;
import 'vendor_document_type.dart' as _i57;
import 'vendor_order_line_item.dart' as _i58;
import 'vendor_order_summary.dart' as _i59;
import 'vendor_payments_overview.dart' as _i60;
import 'vendor_payout.dart' as _i61;
import 'vendor_payout_status.dart' as _i62;
import 'vendor_payout_summary.dart' as _i63;
import 'vendor_product_stat.dart' as _i64;
import 'vendor_product_upload_input.dart' as _i65;
import 'vendor_profile_detail.dart' as _i66;
import 'vendor_profile_update_input.dart' as _i67;
import 'vendor_shop_order.dart' as _i68;
import 'wishlist_item.dart' as _i69;
import 'wishlist_page.dart' as _i70;
import 'package:placeify_server/src/generated/user_role.dart' as _i71;
import 'package:placeify_server/src/generated/user_order_summary.dart' as _i72;
import 'package:placeify_server/src/generated/user_ar_session_summary.dart'
    as _i73;
import 'package:placeify_server/src/generated/complaint.dart' as _i74;
import 'package:placeify_server/src/generated/platform_user_summary.dart'
    as _i75;
import 'package:placeify_server/src/generated/vendor_application_summary.dart'
    as _i76;
import 'package:placeify_server/src/generated/admin_audit_log_summary.dart'
    as _i77;
import 'package:placeify_server/src/generated/admin_vendor_payout_summary.dart'
    as _i78;
import 'package:placeify_server/src/generated/admin_refund_request_summary.dart'
    as _i79;
import 'package:placeify_server/src/generated/ar_session.dart' as _i80;
import 'package:placeify_server/src/generated/cart_item.dart' as _i81;
import 'package:placeify_server/src/generated/order_delivery_update.dart'
    as _i82;
import 'package:placeify_server/src/generated/payment_update_summary.dart'
    as _i83;
import 'package:placeify_server/src/generated/category.dart' as _i84;
import 'package:placeify_server/src/generated/shop_listing_summary.dart'
    as _i85;
import 'package:placeify_server/src/generated/product.dart' as _i86;
import 'package:placeify_server/src/generated/refund_request_summary.dart'
    as _i87;
import 'package:placeify_server/src/generated/review.dart' as _i88;
import 'package:placeify_server/src/generated/vendor_shop_order.dart' as _i89;
export 'admin.dart';
export 'admin_audit_log_summary.dart';
export 'admin_platform_stats.dart';
export 'admin_refund_request_summary.dart';
export 'admin_type.dart';
export 'admin_vendor_payout_summary.dart';
export 'ar_session.dart';
export 'cart.dart';
export 'cart_item.dart';
export 'category.dart';
export 'checkout_request.dart';
export 'checkout_result.dart';
export 'complaint.dart';
export 'complaint_status.dart';
export 'customization_request.dart';
export 'delivery_stage.dart';
export 'greetings/greeting.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_delivery_update.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_status.dart';
export 'order_vendor_payment.dart';
export 'pagination_input.dart';
export 'payment_transaction.dart';
export 'payment_transaction_status.dart';
export 'payment_update_summary.dart';
export 'placeify_exception.dart';
export 'platform_user_summary.dart';
export 'product.dart';
export 'product_page.dart';
export 'product_search_input.dart';
export 'product_status.dart';
export 'refund_request.dart';
export 'refund_request_summary.dart';
export 'request_status.dart';
export 'review.dart';
export 'shop_listing_summary.dart';
export 'user.dart';
export 'user_account_status.dart';
export 'user_ar_session_summary.dart';
export 'user_dashboard.dart';
export 'user_order_summary.dart';
export 'user_role.dart';
export 'vendor.dart';
export 'vendor_application_detail.dart';
export 'vendor_application_summary.dart';
export 'vendor_bank_details.dart';
export 'vendor_bank_details_input.dart';
export 'vendor_dashboard.dart';
export 'vendor_document.dart';
export 'vendor_document_type.dart';
export 'vendor_order_line_item.dart';
export 'vendor_order_summary.dart';
export 'vendor_payments_overview.dart';
export 'vendor_payout.dart';
export 'vendor_payout_status.dart';
export 'vendor_payout_summary.dart';
export 'vendor_product_stat.dart';
export 'vendor_product_upload_input.dart';
export 'vendor_profile_detail.dart';
export 'vendor_profile_update_input.dart';
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
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
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
          isNullable: true,
          dartType: 'String?',
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
          name: 'rejectionReason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
        _i2.IndexDefinition(
          indexName: 'order_status',
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
      name: 'order_delivery_update',
      dartName: 'OrderDeliveryUpdate',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'order_delivery_update_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
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
          name: 'stage',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DeliveryStage',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'photoUrl',
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
          constraintName: 'order_delivery_update_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_delivery_update_fk_1',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_delivery_update_pkey',
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
          indexName: 'order_delivery_update_order_vendor',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
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
        _i2.IndexDefinition(
          indexName: 'order_item_vendor_id',
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
          indexName: 'order_item_vendor_order',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
            ),
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
      name: 'order_vendor_payment',
      dartName: 'OrderVendorPayment',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'order_vendor_payment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
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
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentTransactionStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'note',
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
          constraintName: 'order_vendor_payment_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_vendor_payment_fk_1',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_vendor_payment_pkey',
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
          indexName: 'order_vendor_payment_order_vendor',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'orderId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'order_vendor_payment_vendor_id',
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
          indexName: 'order_vendor_payment_status',
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
      name: 'payment_transaction',
      dartName: 'PaymentTransaction',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'payment_transaction_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'provider',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'providerTransactionId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'NPR\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentTransactionStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'note',
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
          constraintName: 'payment_transaction_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'payment_transaction_fk_1',
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
          indexName: 'payment_transaction_pkey',
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
          indexName: 'payment_transaction_order_id',
          tableSpace: null,
          elements: [
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
          indexName: 'payment_transaction_user_id',
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
          indexName: 'payment_transaction_status',
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
        _i2.IndexDefinition(
          indexName: 'payment_transaction_provider_tx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'providerTransactionId',
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
        _i2.IndexDefinition(
          indexName: 'product_category_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'categoryId',
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
      name: 'refund_request',
      dartName: 'RefundRequest',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'refund_request_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RequestStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'refundAmount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
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
          constraintName: 'refund_request_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'refund_request_fk_1',
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
          indexName: 'refund_request_pkey',
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
          indexName: 'refund_request_user_id',
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
          indexName: 'refund_request_order_id',
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
        _i2.IndexDefinition(
          indexName: 'refund_request_status',
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
          name: 'city',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'country',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'shopCategory',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'contactEmail',
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
          name: 'bannerUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'coverUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isOpen',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'instagramHandle',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'facebookHandle',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'operatingHours',
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
      name: 'vendor_bank_details',
      dartName: 'VendorBankDetails',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'vendor_bank_details_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'vendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'accountHolderName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'bankName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'accountNumber',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'branchCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          constraintName: 'vendor_bank_details_fk_0',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'vendor_bank_details_pkey',
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
          indexName: 'vendor_bank_details_vendor_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vendorId',
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
      name: 'vendor_document',
      dartName: 'VendorDocument',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'vendor_document_id_seq\'::regclass)',
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
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'documentType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:VendorDocumentType',
        ),
        _i2.ColumnDefinition(
          name: 'fileUrl',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          constraintName: 'vendor_document_fk_0',
          columns: ['userId'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'vendor_document_fk_1',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'vendor_document_pkey',
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
          indexName: 'vendor_document_user_type',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'documentType',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'vendor_document_vendor_id',
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
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'vendor_payout',
      dartName: 'VendorPayout',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'vendor_payout_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'vendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'amount',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:VendorPayoutStatus',
          columnDefault: '\'pending\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'payoutMethod',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'reference',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'scheduledAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'paidAt',
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
          constraintName: 'vendor_payout_fk_0',
          columns: ['vendorId'],
          referenceTable: 'vendor',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'vendor_payout_pkey',
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
          indexName: 'vendor_payout_vendor_id',
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
          indexName: 'vendor_payout_status',
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
        _i2.IndexDefinition(
          indexName: 'vendor_payout_reference',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'reference',
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
    if (t == _i6.AdminAuditLogSummary) {
      return _i6.AdminAuditLogSummary.fromJson(data) as T;
    }
    if (t == _i7.AdminPlatformStats) {
      return _i7.AdminPlatformStats.fromJson(data) as T;
    }
    if (t == _i8.AdminRefundRequestSummary) {
      return _i8.AdminRefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i9.AdminType) {
      return _i9.AdminType.fromJson(data) as T;
    }
    if (t == _i10.AdminVendorPayoutSummary) {
      return _i10.AdminVendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i11.ARSession) {
      return _i11.ARSession.fromJson(data) as T;
    }
    if (t == _i12.Cart) {
      return _i12.Cart.fromJson(data) as T;
    }
    if (t == _i13.CartItem) {
      return _i13.CartItem.fromJson(data) as T;
    }
    if (t == _i14.Category) {
      return _i14.Category.fromJson(data) as T;
    }
    if (t == _i15.CheckoutRequest) {
      return _i15.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i16.CheckoutResult) {
      return _i16.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i17.Complaint) {
      return _i17.Complaint.fromJson(data) as T;
    }
    if (t == _i18.ComplaintStatus) {
      return _i18.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i19.CustomizationRequest) {
      return _i19.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i20.DeliveryStage) {
      return _i20.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i21.Greeting) {
      return _i21.Greeting.fromJson(data) as T;
    }
    if (t == _i22.NotificationPreference) {
      return _i22.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i23.Order) {
      return _i23.Order.fromJson(data) as T;
    }
    if (t == _i24.OrderDeliveryUpdate) {
      return _i24.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i25.OrderItem) {
      return _i25.OrderItem.fromJson(data) as T;
    }
    if (t == _i26.OrderPage) {
      return _i26.OrderPage.fromJson(data) as T;
    }
    if (t == _i27.OrderStatus) {
      return _i27.OrderStatus.fromJson(data) as T;
    }
    if (t == _i28.OrderVendorPayment) {
      return _i28.OrderVendorPayment.fromJson(data) as T;
    }
    if (t == _i29.PaginationInput) {
      return _i29.PaginationInput.fromJson(data) as T;
    }
    if (t == _i30.PaymentTransaction) {
      return _i30.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i31.PaymentTransactionStatus) {
      return _i31.PaymentTransactionStatus.fromJson(data) as T;
    }
    if (t == _i32.PaymentUpdateSummary) {
      return _i32.PaymentUpdateSummary.fromJson(data) as T;
    }
    if (t == _i33.PlaceifyException) {
      return _i33.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i34.PlatformUserSummary) {
      return _i34.PlatformUserSummary.fromJson(data) as T;
    }
    if (t == _i35.Product) {
      return _i35.Product.fromJson(data) as T;
    }
    if (t == _i36.ProductPage) {
      return _i36.ProductPage.fromJson(data) as T;
    }
    if (t == _i37.ProductSearchInput) {
      return _i37.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i38.ProductStatus) {
      return _i38.ProductStatus.fromJson(data) as T;
    }
    if (t == _i39.RefundRequest) {
      return _i39.RefundRequest.fromJson(data) as T;
    }
    if (t == _i40.RefundRequestSummary) {
      return _i40.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i41.RequestStatus) {
      return _i41.RequestStatus.fromJson(data) as T;
    }
    if (t == _i42.Review) {
      return _i42.Review.fromJson(data) as T;
    }
    if (t == _i43.ShopListingSummary) {
      return _i43.ShopListingSummary.fromJson(data) as T;
    }
    if (t == _i44.User) {
      return _i44.User.fromJson(data) as T;
    }
    if (t == _i45.UserAccountStatus) {
      return _i45.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i46.UserArSessionSummary) {
      return _i46.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i47.UserDashboard) {
      return _i47.UserDashboard.fromJson(data) as T;
    }
    if (t == _i48.UserOrderSummary) {
      return _i48.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i49.UserRole) {
      return _i49.UserRole.fromJson(data) as T;
    }
    if (t == _i50.Vendor) {
      return _i50.Vendor.fromJson(data) as T;
    }
    if (t == _i51.VendorApplicationDetail) {
      return _i51.VendorApplicationDetail.fromJson(data) as T;
    }
    if (t == _i52.VendorApplicationSummary) {
      return _i52.VendorApplicationSummary.fromJson(data) as T;
    }
    if (t == _i53.VendorBankDetails) {
      return _i53.VendorBankDetails.fromJson(data) as T;
    }
    if (t == _i54.VendorBankDetailsInput) {
      return _i54.VendorBankDetailsInput.fromJson(data) as T;
    }
    if (t == _i55.VendorDashboard) {
      return _i55.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i56.VendorDocument) {
      return _i56.VendorDocument.fromJson(data) as T;
    }
    if (t == _i57.VendorDocumentType) {
      return _i57.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i58.VendorOrderLineItem) {
      return _i58.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i59.VendorOrderSummary) {
      return _i59.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i60.VendorPaymentsOverview) {
      return _i60.VendorPaymentsOverview.fromJson(data) as T;
    }
    if (t == _i61.VendorPayout) {
      return _i61.VendorPayout.fromJson(data) as T;
    }
    if (t == _i62.VendorPayoutStatus) {
      return _i62.VendorPayoutStatus.fromJson(data) as T;
    }
    if (t == _i63.VendorPayoutSummary) {
      return _i63.VendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i64.VendorProductStat) {
      return _i64.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i65.VendorProductUploadInput) {
      return _i65.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i66.VendorProfileDetail) {
      return _i66.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i67.VendorProfileUpdateInput) {
      return _i67.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i68.VendorShopOrder) {
      return _i68.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i69.WishlistItem) {
      return _i69.WishlistItem.fromJson(data) as T;
    }
    if (t == _i70.WishlistPage) {
      return _i70.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Admin?>()) {
      return (data != null ? _i5.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminAuditLogSummary?>()) {
      return (data != null ? _i6.AdminAuditLogSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.AdminPlatformStats?>()) {
      return (data != null ? _i7.AdminPlatformStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AdminRefundRequestSummary?>()) {
      return (data != null
              ? _i8.AdminRefundRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i9.AdminType?>()) {
      return (data != null ? _i9.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AdminVendorPayoutSummary?>()) {
      return (data != null
              ? _i10.AdminVendorPayoutSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.ARSession?>()) {
      return (data != null ? _i11.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Cart?>()) {
      return (data != null ? _i12.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CartItem?>()) {
      return (data != null ? _i13.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Category?>()) {
      return (data != null ? _i14.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CheckoutRequest?>()) {
      return (data != null ? _i15.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CheckoutResult?>()) {
      return (data != null ? _i16.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.Complaint?>()) {
      return (data != null ? _i17.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ComplaintStatus?>()) {
      return (data != null ? _i18.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.CustomizationRequest?>()) {
      return (data != null ? _i19.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.DeliveryStage?>()) {
      return (data != null ? _i20.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Greeting?>()) {
      return (data != null ? _i21.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.NotificationPreference?>()) {
      return (data != null ? _i22.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.Order?>()) {
      return (data != null ? _i23.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.OrderDeliveryUpdate?>()) {
      return (data != null ? _i24.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.OrderItem?>()) {
      return (data != null ? _i25.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.OrderPage?>()) {
      return (data != null ? _i26.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.OrderStatus?>()) {
      return (data != null ? _i27.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.OrderVendorPayment?>()) {
      return (data != null ? _i28.OrderVendorPayment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.PaginationInput?>()) {
      return (data != null ? _i29.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.PaymentTransaction?>()) {
      return (data != null ? _i30.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.PaymentTransactionStatus?>()) {
      return (data != null
              ? _i31.PaymentTransactionStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i32.PaymentUpdateSummary?>()) {
      return (data != null ? _i32.PaymentUpdateSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.PlaceifyException?>()) {
      return (data != null ? _i33.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.PlatformUserSummary?>()) {
      return (data != null ? _i34.PlatformUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.Product?>()) {
      return (data != null ? _i35.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.ProductPage?>()) {
      return (data != null ? _i36.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.ProductSearchInput?>()) {
      return (data != null ? _i37.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.ProductStatus?>()) {
      return (data != null ? _i38.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.RefundRequest?>()) {
      return (data != null ? _i39.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.RefundRequestSummary?>()) {
      return (data != null ? _i40.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.RequestStatus?>()) {
      return (data != null ? _i41.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.Review?>()) {
      return (data != null ? _i42.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ShopListingSummary?>()) {
      return (data != null ? _i43.ShopListingSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.User?>()) {
      return (data != null ? _i44.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.UserAccountStatus?>()) {
      return (data != null ? _i45.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.UserArSessionSummary?>()) {
      return (data != null ? _i46.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.UserDashboard?>()) {
      return (data != null ? _i47.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.UserOrderSummary?>()) {
      return (data != null ? _i48.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.UserRole?>()) {
      return (data != null ? _i49.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.Vendor?>()) {
      return (data != null ? _i50.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.VendorApplicationDetail?>()) {
      return (data != null ? _i51.VendorApplicationDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.VendorApplicationSummary?>()) {
      return (data != null
              ? _i52.VendorApplicationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i53.VendorBankDetails?>()) {
      return (data != null ? _i53.VendorBankDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.VendorBankDetailsInput?>()) {
      return (data != null ? _i54.VendorBankDetailsInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.VendorDashboard?>()) {
      return (data != null ? _i55.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.VendorDocument?>()) {
      return (data != null ? _i56.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.VendorDocumentType?>()) {
      return (data != null ? _i57.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.VendorOrderLineItem?>()) {
      return (data != null ? _i58.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.VendorOrderSummary?>()) {
      return (data != null ? _i59.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.VendorPaymentsOverview?>()) {
      return (data != null ? _i60.VendorPaymentsOverview.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.VendorPayout?>()) {
      return (data != null ? _i61.VendorPayout.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.VendorPayoutStatus?>()) {
      return (data != null ? _i62.VendorPayoutStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.VendorPayoutSummary?>()) {
      return (data != null ? _i63.VendorPayoutSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.VendorProductStat?>()) {
      return (data != null ? _i64.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.VendorProductUploadInput?>()) {
      return (data != null
              ? _i65.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i66.VendorProfileDetail?>()) {
      return (data != null ? _i66.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i67.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i68.VendorShopOrder?>()) {
      return (data != null ? _i68.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.WishlistItem?>()) {
      return (data != null ? _i69.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.WishlistPage?>()) {
      return (data != null ? _i70.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i6.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i6.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i52.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i52.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Order>) {
      return (data as List).map((e) => deserialize<_i23.Order>(e)).toList()
          as T;
    }
    if (t == List<_i35.Product>) {
      return (data as List).map((e) => deserialize<_i35.Product>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i59.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i59.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i64.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i64.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i63.VendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i63.VendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i58.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i58.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i69.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i69.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i71.UserRole>) {
      return (data as List).map((e) => deserialize<_i71.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i72.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i72.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i73.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i73.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i74.Complaint>) {
      return (data as List).map((e) => deserialize<_i74.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i75.PlatformUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_i75.PlatformUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i76.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i76.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i77.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i77.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i78.AdminVendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i78.AdminVendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i79.AdminRefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i79.AdminRefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i80.ARSession>) {
      return (data as List).map((e) => deserialize<_i80.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i81.CartItem>) {
      return (data as List).map((e) => deserialize<_i81.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i82.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i82.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i83.PaymentUpdateSummary>) {
      return (data as List)
              .map((e) => deserialize<_i83.PaymentUpdateSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i84.Category>) {
      return (data as List).map((e) => deserialize<_i84.Category>(e)).toList()
          as T;
    }
    if (t == List<_i85.ShopListingSummary>) {
      return (data as List)
              .map((e) => deserialize<_i85.ShopListingSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.Product>) {
      return (data as List).map((e) => deserialize<_i86.Product>(e)).toList()
          as T;
    }
    if (t == List<_i87.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i87.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i88.Review>) {
      return (data as List).map((e) => deserialize<_i88.Review>(e)).toList()
          as T;
    }
    if (t == List<_i89.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i89.VendorShopOrder>(e))
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
      _i6.AdminAuditLogSummary => 'AdminAuditLogSummary',
      _i7.AdminPlatformStats => 'AdminPlatformStats',
      _i8.AdminRefundRequestSummary => 'AdminRefundRequestSummary',
      _i9.AdminType => 'AdminType',
      _i10.AdminVendorPayoutSummary => 'AdminVendorPayoutSummary',
      _i11.ARSession => 'ARSession',
      _i12.Cart => 'Cart',
      _i13.CartItem => 'CartItem',
      _i14.Category => 'Category',
      _i15.CheckoutRequest => 'CheckoutRequest',
      _i16.CheckoutResult => 'CheckoutResult',
      _i17.Complaint => 'Complaint',
      _i18.ComplaintStatus => 'ComplaintStatus',
      _i19.CustomizationRequest => 'CustomizationRequest',
      _i20.DeliveryStage => 'DeliveryStage',
      _i21.Greeting => 'Greeting',
      _i22.NotificationPreference => 'NotificationPreference',
      _i23.Order => 'Order',
      _i24.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i25.OrderItem => 'OrderItem',
      _i26.OrderPage => 'OrderPage',
      _i27.OrderStatus => 'OrderStatus',
      _i28.OrderVendorPayment => 'OrderVendorPayment',
      _i29.PaginationInput => 'PaginationInput',
      _i30.PaymentTransaction => 'PaymentTransaction',
      _i31.PaymentTransactionStatus => 'PaymentTransactionStatus',
      _i32.PaymentUpdateSummary => 'PaymentUpdateSummary',
      _i33.PlaceifyException => 'PlaceifyException',
      _i34.PlatformUserSummary => 'PlatformUserSummary',
      _i35.Product => 'Product',
      _i36.ProductPage => 'ProductPage',
      _i37.ProductSearchInput => 'ProductSearchInput',
      _i38.ProductStatus => 'ProductStatus',
      _i39.RefundRequest => 'RefundRequest',
      _i40.RefundRequestSummary => 'RefundRequestSummary',
      _i41.RequestStatus => 'RequestStatus',
      _i42.Review => 'Review',
      _i43.ShopListingSummary => 'ShopListingSummary',
      _i44.User => 'User',
      _i45.UserAccountStatus => 'UserAccountStatus',
      _i46.UserArSessionSummary => 'UserArSessionSummary',
      _i47.UserDashboard => 'UserDashboard',
      _i48.UserOrderSummary => 'UserOrderSummary',
      _i49.UserRole => 'UserRole',
      _i50.Vendor => 'Vendor',
      _i51.VendorApplicationDetail => 'VendorApplicationDetail',
      _i52.VendorApplicationSummary => 'VendorApplicationSummary',
      _i53.VendorBankDetails => 'VendorBankDetails',
      _i54.VendorBankDetailsInput => 'VendorBankDetailsInput',
      _i55.VendorDashboard => 'VendorDashboard',
      _i56.VendorDocument => 'VendorDocument',
      _i57.VendorDocumentType => 'VendorDocumentType',
      _i58.VendorOrderLineItem => 'VendorOrderLineItem',
      _i59.VendorOrderSummary => 'VendorOrderSummary',
      _i60.VendorPaymentsOverview => 'VendorPaymentsOverview',
      _i61.VendorPayout => 'VendorPayout',
      _i62.VendorPayoutStatus => 'VendorPayoutStatus',
      _i63.VendorPayoutSummary => 'VendorPayoutSummary',
      _i64.VendorProductStat => 'VendorProductStat',
      _i65.VendorProductUploadInput => 'VendorProductUploadInput',
      _i66.VendorProfileDetail => 'VendorProfileDetail',
      _i67.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i68.VendorShopOrder => 'VendorShopOrder',
      _i69.WishlistItem => 'WishlistItem',
      _i70.WishlistPage => 'WishlistPage',
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
      case _i6.AdminAuditLogSummary():
        return 'AdminAuditLogSummary';
      case _i7.AdminPlatformStats():
        return 'AdminPlatformStats';
      case _i8.AdminRefundRequestSummary():
        return 'AdminRefundRequestSummary';
      case _i9.AdminType():
        return 'AdminType';
      case _i10.AdminVendorPayoutSummary():
        return 'AdminVendorPayoutSummary';
      case _i11.ARSession():
        return 'ARSession';
      case _i12.Cart():
        return 'Cart';
      case _i13.CartItem():
        return 'CartItem';
      case _i14.Category():
        return 'Category';
      case _i15.CheckoutRequest():
        return 'CheckoutRequest';
      case _i16.CheckoutResult():
        return 'CheckoutResult';
      case _i17.Complaint():
        return 'Complaint';
      case _i18.ComplaintStatus():
        return 'ComplaintStatus';
      case _i19.CustomizationRequest():
        return 'CustomizationRequest';
      case _i20.DeliveryStage():
        return 'DeliveryStage';
      case _i21.Greeting():
        return 'Greeting';
      case _i22.NotificationPreference():
        return 'NotificationPreference';
      case _i23.Order():
        return 'Order';
      case _i24.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i25.OrderItem():
        return 'OrderItem';
      case _i26.OrderPage():
        return 'OrderPage';
      case _i27.OrderStatus():
        return 'OrderStatus';
      case _i28.OrderVendorPayment():
        return 'OrderVendorPayment';
      case _i29.PaginationInput():
        return 'PaginationInput';
      case _i30.PaymentTransaction():
        return 'PaymentTransaction';
      case _i31.PaymentTransactionStatus():
        return 'PaymentTransactionStatus';
      case _i32.PaymentUpdateSummary():
        return 'PaymentUpdateSummary';
      case _i33.PlaceifyException():
        return 'PlaceifyException';
      case _i34.PlatformUserSummary():
        return 'PlatformUserSummary';
      case _i35.Product():
        return 'Product';
      case _i36.ProductPage():
        return 'ProductPage';
      case _i37.ProductSearchInput():
        return 'ProductSearchInput';
      case _i38.ProductStatus():
        return 'ProductStatus';
      case _i39.RefundRequest():
        return 'RefundRequest';
      case _i40.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i41.RequestStatus():
        return 'RequestStatus';
      case _i42.Review():
        return 'Review';
      case _i43.ShopListingSummary():
        return 'ShopListingSummary';
      case _i44.User():
        return 'User';
      case _i45.UserAccountStatus():
        return 'UserAccountStatus';
      case _i46.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i47.UserDashboard():
        return 'UserDashboard';
      case _i48.UserOrderSummary():
        return 'UserOrderSummary';
      case _i49.UserRole():
        return 'UserRole';
      case _i50.Vendor():
        return 'Vendor';
      case _i51.VendorApplicationDetail():
        return 'VendorApplicationDetail';
      case _i52.VendorApplicationSummary():
        return 'VendorApplicationSummary';
      case _i53.VendorBankDetails():
        return 'VendorBankDetails';
      case _i54.VendorBankDetailsInput():
        return 'VendorBankDetailsInput';
      case _i55.VendorDashboard():
        return 'VendorDashboard';
      case _i56.VendorDocument():
        return 'VendorDocument';
      case _i57.VendorDocumentType():
        return 'VendorDocumentType';
      case _i58.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i59.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i60.VendorPaymentsOverview():
        return 'VendorPaymentsOverview';
      case _i61.VendorPayout():
        return 'VendorPayout';
      case _i62.VendorPayoutStatus():
        return 'VendorPayoutStatus';
      case _i63.VendorPayoutSummary():
        return 'VendorPayoutSummary';
      case _i64.VendorProductStat():
        return 'VendorProductStat';
      case _i65.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i66.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i67.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i68.VendorShopOrder():
        return 'VendorShopOrder';
      case _i69.WishlistItem():
        return 'WishlistItem';
      case _i70.WishlistPage():
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
    if (dataClassName == 'AdminAuditLogSummary') {
      return deserialize<_i6.AdminAuditLogSummary>(data['data']);
    }
    if (dataClassName == 'AdminPlatformStats') {
      return deserialize<_i7.AdminPlatformStats>(data['data']);
    }
    if (dataClassName == 'AdminRefundRequestSummary') {
      return deserialize<_i8.AdminRefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i9.AdminType>(data['data']);
    }
    if (dataClassName == 'AdminVendorPayoutSummary') {
      return deserialize<_i10.AdminVendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i11.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i12.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i13.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i14.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i15.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i16.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i17.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i18.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i19.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i20.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i21.Greeting>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i22.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i23.Order>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i24.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i25.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i26.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i27.OrderStatus>(data['data']);
    }
    if (dataClassName == 'OrderVendorPayment') {
      return deserialize<_i28.OrderVendorPayment>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i29.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i30.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionStatus') {
      return deserialize<_i31.PaymentTransactionStatus>(data['data']);
    }
    if (dataClassName == 'PaymentUpdateSummary') {
      return deserialize<_i32.PaymentUpdateSummary>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i33.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'PlatformUserSummary') {
      return deserialize<_i34.PlatformUserSummary>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i35.Product>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i36.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i37.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i38.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i39.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i40.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i41.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i42.Review>(data['data']);
    }
    if (dataClassName == 'ShopListingSummary') {
      return deserialize<_i43.ShopListingSummary>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i44.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i45.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i46.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i47.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i48.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i49.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i50.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorApplicationDetail') {
      return deserialize<_i51.VendorApplicationDetail>(data['data']);
    }
    if (dataClassName == 'VendorApplicationSummary') {
      return deserialize<_i52.VendorApplicationSummary>(data['data']);
    }
    if (dataClassName == 'VendorBankDetails') {
      return deserialize<_i53.VendorBankDetails>(data['data']);
    }
    if (dataClassName == 'VendorBankDetailsInput') {
      return deserialize<_i54.VendorBankDetailsInput>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i55.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i56.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i57.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i58.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i59.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorPaymentsOverview') {
      return deserialize<_i60.VendorPaymentsOverview>(data['data']);
    }
    if (dataClassName == 'VendorPayout') {
      return deserialize<_i61.VendorPayout>(data['data']);
    }
    if (dataClassName == 'VendorPayoutStatus') {
      return deserialize<_i62.VendorPayoutStatus>(data['data']);
    }
    if (dataClassName == 'VendorPayoutSummary') {
      return deserialize<_i63.VendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i64.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i65.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i66.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i67.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i68.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i69.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i70.WishlistPage>(data['data']);
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
      case _i11.ARSession:
        return _i11.ARSession.t;
      case _i12.Cart:
        return _i12.Cart.t;
      case _i13.CartItem:
        return _i13.CartItem.t;
      case _i14.Category:
        return _i14.Category.t;
      case _i17.Complaint:
        return _i17.Complaint.t;
      case _i19.CustomizationRequest:
        return _i19.CustomizationRequest.t;
      case _i22.NotificationPreference:
        return _i22.NotificationPreference.t;
      case _i23.Order:
        return _i23.Order.t;
      case _i24.OrderDeliveryUpdate:
        return _i24.OrderDeliveryUpdate.t;
      case _i25.OrderItem:
        return _i25.OrderItem.t;
      case _i28.OrderVendorPayment:
        return _i28.OrderVendorPayment.t;
      case _i30.PaymentTransaction:
        return _i30.PaymentTransaction.t;
      case _i35.Product:
        return _i35.Product.t;
      case _i39.RefundRequest:
        return _i39.RefundRequest.t;
      case _i42.Review:
        return _i42.Review.t;
      case _i44.User:
        return _i44.User.t;
      case _i50.Vendor:
        return _i50.Vendor.t;
      case _i53.VendorBankDetails:
        return _i53.VendorBankDetails.t;
      case _i56.VendorDocument:
        return _i56.VendorDocument.t;
      case _i61.VendorPayout:
        return _i61.VendorPayout.t;
      case _i69.WishlistItem:
        return _i69.WishlistItem.t;
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
