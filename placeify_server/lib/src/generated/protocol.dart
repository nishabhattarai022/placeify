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
import 'admin_action_type.dart' as _i6;
import 'admin_audit_log.dart' as _i7;
import 'admin_audit_log_summary.dart' as _i8;
import 'admin_platform_stats.dart' as _i9;
import 'admin_product_complaint_summary.dart' as _i10;
import 'admin_product_detail.dart' as _i11;
import 'admin_product_list_input.dart' as _i12;
import 'admin_product_summary.dart' as _i13;
import 'admin_product_visibility_filter.dart' as _i14;
import 'admin_refund_request_summary.dart' as _i15;
import 'admin_type.dart' as _i16;
import 'admin_vendor_payout_summary.dart' as _i17;
import 'ar_session.dart' as _i18;
import 'cart.dart' as _i19;
import 'cart_item.dart' as _i20;
import 'category.dart' as _i21;
import 'checkout_request.dart' as _i22;
import 'checkout_result.dart' as _i23;
import 'complaint.dart' as _i24;
import 'complaint_status.dart' as _i25;
import 'customization_request.dart' as _i26;
import 'delivery_stage.dart' as _i27;
import 'greetings/greeting.dart' as _i28;
import 'in_app_notification.dart' as _i29;
import 'in_app_notification_summary.dart' as _i30;
import 'in_app_notification_type.dart' as _i31;
import 'marketplace_highlights.dart' as _i32;
import 'notification_preference.dart' as _i33;
import 'order.dart' as _i34;
import 'order_auto_cancel_trigger.dart' as _i35;
import 'order_delivery_status.dart' as _i36;
import 'order_delivery_update.dart' as _i37;
import 'order_item.dart' as _i38;
import 'order_page.dart' as _i39;
import 'order_payment_status.dart' as _i40;
import 'order_status.dart' as _i41;
import 'order_status_history.dart' as _i42;
import 'order_status_history_type.dart' as _i43;
import 'order_vendor_payment.dart' as _i44;
import 'pagination_input.dart' as _i45;
import 'payment_method.dart' as _i46;
import 'payment_transaction.dart' as _i47;
import 'payment_transaction_status.dart' as _i48;
import 'payment_update_summary.dart' as _i49;
import 'placeify_exception.dart' as _i50;
import 'platform_user_detail.dart' as _i51;
import 'platform_user_summary.dart' as _i52;
import 'product.dart' as _i53;
import 'product_3d_generation_trigger.dart' as _i54;
import 'product_page.dart' as _i55;
import 'product_search_input.dart' as _i56;
import 'product_status.dart' as _i57;
import 'refund_request.dart' as _i58;
import 'refund_request_summary.dart' as _i59;
import 'request_status.dart' as _i60;
import 'review.dart' as _i61;
import 'shop_listing_summary.dart' as _i62;
import 'user.dart' as _i63;
import 'user_account_status.dart' as _i64;
import 'user_ar_session_summary.dart' as _i65;
import 'user_dashboard.dart' as _i66;
import 'user_order_delivery_event.dart' as _i67;
import 'user_order_detail.dart' as _i68;
import 'user_order_line_item.dart' as _i69;
import 'user_order_payment_event.dart' as _i70;
import 'user_order_payment_summary.dart' as _i71;
import 'user_order_summary.dart' as _i72;
import 'user_role.dart' as _i73;
import 'vendor.dart' as _i74;
import 'vendor_application_detail.dart' as _i75;
import 'vendor_application_summary.dart' as _i76;
import 'vendor_bank_details.dart' as _i77;
import 'vendor_bank_details_input.dart' as _i78;
import 'vendor_dashboard.dart' as _i79;
import 'vendor_document.dart' as _i80;
import 'vendor_document_type.dart' as _i81;
import 'vendor_moderation_result.dart' as _i82;
import 'vendor_notification_summary.dart' as _i83;
import 'vendor_notification_type.dart' as _i84;
import 'vendor_order_line_item.dart' as _i85;
import 'vendor_order_summary.dart' as _i86;
import 'vendor_payments_overview.dart' as _i87;
import 'vendor_payout.dart' as _i88;
import 'vendor_payout_status.dart' as _i89;
import 'vendor_payout_summary.dart' as _i90;
import 'vendor_product_stat.dart' as _i91;
import 'vendor_product_upload_input.dart' as _i92;
import 'vendor_profile_detail.dart' as _i93;
import 'vendor_profile_update_input.dart' as _i94;
import 'vendor_review_summary.dart' as _i95;
import 'vendor_shop_order.dart' as _i96;
import 'wishlist_item.dart' as _i97;
import 'wishlist_page.dart' as _i98;
import 'package:placeify_server/src/generated/user_role.dart' as _i99;
import 'package:placeify_server/src/generated/user_order_summary.dart' as _i100;
import 'package:placeify_server/src/generated/user_ar_session_summary.dart'
    as _i101;
import 'package:placeify_server/src/generated/complaint.dart' as _i102;
import 'package:placeify_server/src/generated/platform_user_summary.dart'
    as _i103;
import 'package:placeify_server/src/generated/vendor_application_summary.dart'
    as _i104;
import 'package:placeify_server/src/generated/admin_audit_log_summary.dart'
    as _i105;
import 'package:placeify_server/src/generated/admin_vendor_payout_summary.dart'
    as _i106;
import 'package:placeify_server/src/generated/admin_refund_request_summary.dart'
    as _i107;
import 'package:placeify_server/src/generated/admin_product_summary.dart'
    as _i108;
import 'package:placeify_server/src/generated/ar_session.dart' as _i109;
import 'package:placeify_server/src/generated/cart_item.dart' as _i110;
import 'package:placeify_server/src/generated/in_app_notification_summary.dart'
    as _i111;
import 'package:placeify_server/src/generated/order_delivery_update.dart'
    as _i112;
import 'package:placeify_server/src/generated/payment_update_summary.dart'
    as _i113;
import 'package:placeify_server/src/generated/category.dart' as _i114;
import 'package:placeify_server/src/generated/shop_listing_summary.dart'
    as _i115;
import 'package:placeify_server/src/generated/product.dart' as _i116;
import 'package:placeify_server/src/generated/refund_request_summary.dart'
    as _i117;
import 'package:placeify_server/src/generated/review.dart' as _i118;
import 'package:placeify_server/src/generated/vendor_shop_order.dart' as _i119;
import 'package:placeify_server/src/generated/vendor_notification_summary.dart'
    as _i120;
import 'package:placeify_server/src/generated/vendor_review_summary.dart'
    as _i121;
export 'admin.dart';
export 'admin_action_type.dart';
export 'admin_audit_log.dart';
export 'admin_audit_log_summary.dart';
export 'admin_platform_stats.dart';
export 'admin_product_complaint_summary.dart';
export 'admin_product_detail.dart';
export 'admin_product_list_input.dart';
export 'admin_product_summary.dart';
export 'admin_product_visibility_filter.dart';
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
export 'in_app_notification.dart';
export 'in_app_notification_summary.dart';
export 'in_app_notification_type.dart';
export 'marketplace_highlights.dart';
export 'notification_preference.dart';
export 'order.dart';
export 'order_auto_cancel_trigger.dart';
export 'order_delivery_status.dart';
export 'order_delivery_update.dart';
export 'order_item.dart';
export 'order_page.dart';
export 'order_payment_status.dart';
export 'order_status.dart';
export 'order_status_history.dart';
export 'order_status_history_type.dart';
export 'order_vendor_payment.dart';
export 'pagination_input.dart';
export 'payment_method.dart';
export 'payment_transaction.dart';
export 'payment_transaction_status.dart';
export 'payment_update_summary.dart';
export 'placeify_exception.dart';
export 'platform_user_detail.dart';
export 'platform_user_summary.dart';
export 'product.dart';
export 'product_3d_generation_trigger.dart';
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
export 'user_order_delivery_event.dart';
export 'user_order_detail.dart';
export 'user_order_line_item.dart';
export 'user_order_payment_event.dart';
export 'user_order_payment_summary.dart';
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
export 'vendor_moderation_result.dart';
export 'vendor_notification_summary.dart';
export 'vendor_notification_type.dart';
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
export 'vendor_review_summary.dart';
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
      name: 'admin_audit_log',
      dartName: 'AdminAuditLog',
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
          name: 'actorAdminId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'actionType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:AdminActionType',
        ),
        _i2.ColumnDefinition(
          name: 'targetUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'targetVendorId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'targetProductId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'targetComplaintId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'targetPayoutId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'targetRefundId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'previousStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'newStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'reason',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'admin_audit_log_fk_0',
          columns: ['actorAdminId'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'admin_audit_log_pkey',
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
          indexName: 'admin_audit_log_created_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'createdAt',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_audit_log_actor_admin_id',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'actorAdminId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'admin_audit_log_action_type',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'actionType',
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
          name: 'assignedToId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'internalNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          columns: ['assignedToId'],
          referenceTable: 'admin',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'complaint_fk_3',
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
      name: 'in_app_notification',
      dartName: 'InAppNotification',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'in_app_notification_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:InAppNotificationType',
        ),
        _i2.ColumnDefinition(
          name: 'referenceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'isRead',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
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
          constraintName: 'in_app_notification_fk_0',
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
          indexName: 'in_app_notification_pkey',
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
          indexName: 'in_app_notification_user_id',
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
          indexName: 'in_app_notification_user_unread',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isRead',
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
          name: 'deliveryStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:OrderDeliveryStatus?',
        ),
        _i2.ColumnDefinition(
          name: 'paymentStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:OrderPaymentStatus',
          columnDefault: '\'unpaid\'::text',
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
          name: 'autoExpiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '1',
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
        _i2.IndexDefinition(
          indexName: 'order_auto_expires_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'autoExpiresAt',
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
      name: 'order_status_history',
      dartName: 'OrderStatusHistory',
      schema: 'public',
      module: 'placeify',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'order_status_history_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'previousStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'newStatus',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'statusType',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:OrderStatusHistoryType',
        ),
        _i2.ColumnDefinition(
          name: 'changedById',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'changedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'note',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_status_history_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'order_status_history_fk_1',
          columns: ['changedById'],
          referenceTable: 'user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_status_history_pkey',
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
          indexName: 'order_status_history_order_id',
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
          name: 'paymentMethod',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PaymentMethod',
          columnDefault: '\'mockOnline\'::text',
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
          name: 'discountPrice',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'discountPercentage',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'featured',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'isOffer',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
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
          name: 'model3dStatus',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'none\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'model3dError',
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
          name: 'viewImageUrls',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<String>?',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ProductStatus',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'isDeleted',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
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
          name: 'moderationNote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'moderatedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'appealMessage',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'appealSubmittedAt',
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
    if (t == _i6.AdminActionType) {
      return _i6.AdminActionType.fromJson(data) as T;
    }
    if (t == _i7.AdminAuditLog) {
      return _i7.AdminAuditLog.fromJson(data) as T;
    }
    if (t == _i8.AdminAuditLogSummary) {
      return _i8.AdminAuditLogSummary.fromJson(data) as T;
    }
    if (t == _i9.AdminPlatformStats) {
      return _i9.AdminPlatformStats.fromJson(data) as T;
    }
    if (t == _i10.AdminProductComplaintSummary) {
      return _i10.AdminProductComplaintSummary.fromJson(data) as T;
    }
    if (t == _i11.AdminProductDetail) {
      return _i11.AdminProductDetail.fromJson(data) as T;
    }
    if (t == _i12.AdminProductListInput) {
      return _i12.AdminProductListInput.fromJson(data) as T;
    }
    if (t == _i13.AdminProductSummary) {
      return _i13.AdminProductSummary.fromJson(data) as T;
    }
    if (t == _i14.AdminProductVisibilityFilter) {
      return _i14.AdminProductVisibilityFilter.fromJson(data) as T;
    }
    if (t == _i15.AdminRefundRequestSummary) {
      return _i15.AdminRefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i16.AdminType) {
      return _i16.AdminType.fromJson(data) as T;
    }
    if (t == _i17.AdminVendorPayoutSummary) {
      return _i17.AdminVendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i18.ARSession) {
      return _i18.ARSession.fromJson(data) as T;
    }
    if (t == _i19.Cart) {
      return _i19.Cart.fromJson(data) as T;
    }
    if (t == _i20.CartItem) {
      return _i20.CartItem.fromJson(data) as T;
    }
    if (t == _i21.Category) {
      return _i21.Category.fromJson(data) as T;
    }
    if (t == _i22.CheckoutRequest) {
      return _i22.CheckoutRequest.fromJson(data) as T;
    }
    if (t == _i23.CheckoutResult) {
      return _i23.CheckoutResult.fromJson(data) as T;
    }
    if (t == _i24.Complaint) {
      return _i24.Complaint.fromJson(data) as T;
    }
    if (t == _i25.ComplaintStatus) {
      return _i25.ComplaintStatus.fromJson(data) as T;
    }
    if (t == _i26.CustomizationRequest) {
      return _i26.CustomizationRequest.fromJson(data) as T;
    }
    if (t == _i27.DeliveryStage) {
      return _i27.DeliveryStage.fromJson(data) as T;
    }
    if (t == _i28.Greeting) {
      return _i28.Greeting.fromJson(data) as T;
    }
    if (t == _i29.InAppNotification) {
      return _i29.InAppNotification.fromJson(data) as T;
    }
    if (t == _i30.InAppNotificationSummary) {
      return _i30.InAppNotificationSummary.fromJson(data) as T;
    }
    if (t == _i31.InAppNotificationType) {
      return _i31.InAppNotificationType.fromJson(data) as T;
    }
    if (t == _i32.MarketplaceHighlights) {
      return _i32.MarketplaceHighlights.fromJson(data) as T;
    }
    if (t == _i33.NotificationPreference) {
      return _i33.NotificationPreference.fromJson(data) as T;
    }
    if (t == _i34.Order) {
      return _i34.Order.fromJson(data) as T;
    }
    if (t == _i35.OrderAutoCancelTrigger) {
      return _i35.OrderAutoCancelTrigger.fromJson(data) as T;
    }
    if (t == _i36.OrderDeliveryStatus) {
      return _i36.OrderDeliveryStatus.fromJson(data) as T;
    }
    if (t == _i37.OrderDeliveryUpdate) {
      return _i37.OrderDeliveryUpdate.fromJson(data) as T;
    }
    if (t == _i38.OrderItem) {
      return _i38.OrderItem.fromJson(data) as T;
    }
    if (t == _i39.OrderPage) {
      return _i39.OrderPage.fromJson(data) as T;
    }
    if (t == _i40.OrderPaymentStatus) {
      return _i40.OrderPaymentStatus.fromJson(data) as T;
    }
    if (t == _i41.OrderStatus) {
      return _i41.OrderStatus.fromJson(data) as T;
    }
    if (t == _i42.OrderStatusHistory) {
      return _i42.OrderStatusHistory.fromJson(data) as T;
    }
    if (t == _i43.OrderStatusHistoryType) {
      return _i43.OrderStatusHistoryType.fromJson(data) as T;
    }
    if (t == _i44.OrderVendorPayment) {
      return _i44.OrderVendorPayment.fromJson(data) as T;
    }
    if (t == _i45.PaginationInput) {
      return _i45.PaginationInput.fromJson(data) as T;
    }
    if (t == _i46.PaymentMethod) {
      return _i46.PaymentMethod.fromJson(data) as T;
    }
    if (t == _i47.PaymentTransaction) {
      return _i47.PaymentTransaction.fromJson(data) as T;
    }
    if (t == _i48.PaymentTransactionStatus) {
      return _i48.PaymentTransactionStatus.fromJson(data) as T;
    }
    if (t == _i49.PaymentUpdateSummary) {
      return _i49.PaymentUpdateSummary.fromJson(data) as T;
    }
    if (t == _i50.PlaceifyException) {
      return _i50.PlaceifyException.fromJson(data) as T;
    }
    if (t == _i51.PlatformUserDetail) {
      return _i51.PlatformUserDetail.fromJson(data) as T;
    }
    if (t == _i52.PlatformUserSummary) {
      return _i52.PlatformUserSummary.fromJson(data) as T;
    }
    if (t == _i53.Product) {
      return _i53.Product.fromJson(data) as T;
    }
    if (t == _i54.Product3dGenerationTrigger) {
      return _i54.Product3dGenerationTrigger.fromJson(data) as T;
    }
    if (t == _i55.ProductPage) {
      return _i55.ProductPage.fromJson(data) as T;
    }
    if (t == _i56.ProductSearchInput) {
      return _i56.ProductSearchInput.fromJson(data) as T;
    }
    if (t == _i57.ProductStatus) {
      return _i57.ProductStatus.fromJson(data) as T;
    }
    if (t == _i58.RefundRequest) {
      return _i58.RefundRequest.fromJson(data) as T;
    }
    if (t == _i59.RefundRequestSummary) {
      return _i59.RefundRequestSummary.fromJson(data) as T;
    }
    if (t == _i60.RequestStatus) {
      return _i60.RequestStatus.fromJson(data) as T;
    }
    if (t == _i61.Review) {
      return _i61.Review.fromJson(data) as T;
    }
    if (t == _i62.ShopListingSummary) {
      return _i62.ShopListingSummary.fromJson(data) as T;
    }
    if (t == _i63.User) {
      return _i63.User.fromJson(data) as T;
    }
    if (t == _i64.UserAccountStatus) {
      return _i64.UserAccountStatus.fromJson(data) as T;
    }
    if (t == _i65.UserArSessionSummary) {
      return _i65.UserArSessionSummary.fromJson(data) as T;
    }
    if (t == _i66.UserDashboard) {
      return _i66.UserDashboard.fromJson(data) as T;
    }
    if (t == _i67.UserOrderDeliveryEvent) {
      return _i67.UserOrderDeliveryEvent.fromJson(data) as T;
    }
    if (t == _i68.UserOrderDetail) {
      return _i68.UserOrderDetail.fromJson(data) as T;
    }
    if (t == _i69.UserOrderLineItem) {
      return _i69.UserOrderLineItem.fromJson(data) as T;
    }
    if (t == _i70.UserOrderPaymentEvent) {
      return _i70.UserOrderPaymentEvent.fromJson(data) as T;
    }
    if (t == _i71.UserOrderPaymentSummary) {
      return _i71.UserOrderPaymentSummary.fromJson(data) as T;
    }
    if (t == _i72.UserOrderSummary) {
      return _i72.UserOrderSummary.fromJson(data) as T;
    }
    if (t == _i73.UserRole) {
      return _i73.UserRole.fromJson(data) as T;
    }
    if (t == _i74.Vendor) {
      return _i74.Vendor.fromJson(data) as T;
    }
    if (t == _i75.VendorApplicationDetail) {
      return _i75.VendorApplicationDetail.fromJson(data) as T;
    }
    if (t == _i76.VendorApplicationSummary) {
      return _i76.VendorApplicationSummary.fromJson(data) as T;
    }
    if (t == _i77.VendorBankDetails) {
      return _i77.VendorBankDetails.fromJson(data) as T;
    }
    if (t == _i78.VendorBankDetailsInput) {
      return _i78.VendorBankDetailsInput.fromJson(data) as T;
    }
    if (t == _i79.VendorDashboard) {
      return _i79.VendorDashboard.fromJson(data) as T;
    }
    if (t == _i80.VendorDocument) {
      return _i80.VendorDocument.fromJson(data) as T;
    }
    if (t == _i81.VendorDocumentType) {
      return _i81.VendorDocumentType.fromJson(data) as T;
    }
    if (t == _i82.VendorModerationResult) {
      return _i82.VendorModerationResult.fromJson(data) as T;
    }
    if (t == _i83.VendorNotificationSummary) {
      return _i83.VendorNotificationSummary.fromJson(data) as T;
    }
    if (t == _i84.VendorNotificationType) {
      return _i84.VendorNotificationType.fromJson(data) as T;
    }
    if (t == _i85.VendorOrderLineItem) {
      return _i85.VendorOrderLineItem.fromJson(data) as T;
    }
    if (t == _i86.VendorOrderSummary) {
      return _i86.VendorOrderSummary.fromJson(data) as T;
    }
    if (t == _i87.VendorPaymentsOverview) {
      return _i87.VendorPaymentsOverview.fromJson(data) as T;
    }
    if (t == _i88.VendorPayout) {
      return _i88.VendorPayout.fromJson(data) as T;
    }
    if (t == _i89.VendorPayoutStatus) {
      return _i89.VendorPayoutStatus.fromJson(data) as T;
    }
    if (t == _i90.VendorPayoutSummary) {
      return _i90.VendorPayoutSummary.fromJson(data) as T;
    }
    if (t == _i91.VendorProductStat) {
      return _i91.VendorProductStat.fromJson(data) as T;
    }
    if (t == _i92.VendorProductUploadInput) {
      return _i92.VendorProductUploadInput.fromJson(data) as T;
    }
    if (t == _i93.VendorProfileDetail) {
      return _i93.VendorProfileDetail.fromJson(data) as T;
    }
    if (t == _i94.VendorProfileUpdateInput) {
      return _i94.VendorProfileUpdateInput.fromJson(data) as T;
    }
    if (t == _i95.VendorReviewSummary) {
      return _i95.VendorReviewSummary.fromJson(data) as T;
    }
    if (t == _i96.VendorShopOrder) {
      return _i96.VendorShopOrder.fromJson(data) as T;
    }
    if (t == _i97.WishlistItem) {
      return _i97.WishlistItem.fromJson(data) as T;
    }
    if (t == _i98.WishlistPage) {
      return _i98.WishlistPage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.Admin?>()) {
      return (data != null ? _i5.Admin.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AdminActionType?>()) {
      return (data != null ? _i6.AdminActionType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.AdminAuditLog?>()) {
      return (data != null ? _i7.AdminAuditLog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.AdminAuditLogSummary?>()) {
      return (data != null ? _i8.AdminAuditLogSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.AdminPlatformStats?>()) {
      return (data != null ? _i9.AdminPlatformStats.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.AdminProductComplaintSummary?>()) {
      return (data != null
              ? _i10.AdminProductComplaintSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i11.AdminProductDetail?>()) {
      return (data != null ? _i11.AdminProductDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.AdminProductListInput?>()) {
      return (data != null ? _i12.AdminProductListInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.AdminProductSummary?>()) {
      return (data != null ? _i13.AdminProductSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.AdminProductVisibilityFilter?>()) {
      return (data != null
              ? _i14.AdminProductVisibilityFilter.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i15.AdminRefundRequestSummary?>()) {
      return (data != null
              ? _i15.AdminRefundRequestSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i16.AdminType?>()) {
      return (data != null ? _i16.AdminType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.AdminVendorPayoutSummary?>()) {
      return (data != null
              ? _i17.AdminVendorPayoutSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i18.ARSession?>()) {
      return (data != null ? _i18.ARSession.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Cart?>()) {
      return (data != null ? _i19.Cart.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.CartItem?>()) {
      return (data != null ? _i20.CartItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Category?>()) {
      return (data != null ? _i21.Category.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.CheckoutRequest?>()) {
      return (data != null ? _i22.CheckoutRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.CheckoutResult?>()) {
      return (data != null ? _i23.CheckoutResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Complaint?>()) {
      return (data != null ? _i24.Complaint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ComplaintStatus?>()) {
      return (data != null ? _i25.ComplaintStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.CustomizationRequest?>()) {
      return (data != null ? _i26.CustomizationRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.DeliveryStage?>()) {
      return (data != null ? _i27.DeliveryStage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Greeting?>()) {
      return (data != null ? _i28.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.InAppNotification?>()) {
      return (data != null ? _i29.InAppNotification.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.InAppNotificationSummary?>()) {
      return (data != null
              ? _i30.InAppNotificationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i31.InAppNotificationType?>()) {
      return (data != null ? _i31.InAppNotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.MarketplaceHighlights?>()) {
      return (data != null ? _i32.MarketplaceHighlights.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.NotificationPreference?>()) {
      return (data != null ? _i33.NotificationPreference.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.Order?>()) {
      return (data != null ? _i34.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.OrderAutoCancelTrigger?>()) {
      return (data != null ? _i35.OrderAutoCancelTrigger.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.OrderDeliveryStatus?>()) {
      return (data != null ? _i36.OrderDeliveryStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.OrderDeliveryUpdate?>()) {
      return (data != null ? _i37.OrderDeliveryUpdate.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.OrderItem?>()) {
      return (data != null ? _i38.OrderItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.OrderPage?>()) {
      return (data != null ? _i39.OrderPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.OrderPaymentStatus?>()) {
      return (data != null ? _i40.OrderPaymentStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.OrderStatus?>()) {
      return (data != null ? _i41.OrderStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.OrderStatusHistory?>()) {
      return (data != null ? _i42.OrderStatusHistory.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.OrderStatusHistoryType?>()) {
      return (data != null ? _i43.OrderStatusHistoryType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.OrderVendorPayment?>()) {
      return (data != null ? _i44.OrderVendorPayment.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.PaginationInput?>()) {
      return (data != null ? _i45.PaginationInput.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.PaymentMethod?>()) {
      return (data != null ? _i46.PaymentMethod.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.PaymentTransaction?>()) {
      return (data != null ? _i47.PaymentTransaction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.PaymentTransactionStatus?>()) {
      return (data != null
              ? _i48.PaymentTransactionStatus.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i49.PaymentUpdateSummary?>()) {
      return (data != null ? _i49.PaymentUpdateSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.PlaceifyException?>()) {
      return (data != null ? _i50.PlaceifyException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.PlatformUserDetail?>()) {
      return (data != null ? _i51.PlatformUserDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.PlatformUserSummary?>()) {
      return (data != null ? _i52.PlatformUserSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.Product?>()) {
      return (data != null ? _i53.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.Product3dGenerationTrigger?>()) {
      return (data != null
              ? _i54.Product3dGenerationTrigger.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i55.ProductPage?>()) {
      return (data != null ? _i55.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.ProductSearchInput?>()) {
      return (data != null ? _i56.ProductSearchInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.ProductStatus?>()) {
      return (data != null ? _i57.ProductStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.RefundRequest?>()) {
      return (data != null ? _i58.RefundRequest.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.RefundRequestSummary?>()) {
      return (data != null ? _i59.RefundRequestSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.RequestStatus?>()) {
      return (data != null ? _i60.RequestStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.Review?>()) {
      return (data != null ? _i61.Review.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.ShopListingSummary?>()) {
      return (data != null ? _i62.ShopListingSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.User?>()) {
      return (data != null ? _i63.User.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.UserAccountStatus?>()) {
      return (data != null ? _i64.UserAccountStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.UserArSessionSummary?>()) {
      return (data != null ? _i65.UserArSessionSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.UserDashboard?>()) {
      return (data != null ? _i66.UserDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.UserOrderDeliveryEvent?>()) {
      return (data != null ? _i67.UserOrderDeliveryEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.UserOrderDetail?>()) {
      return (data != null ? _i68.UserOrderDetail.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.UserOrderLineItem?>()) {
      return (data != null ? _i69.UserOrderLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.UserOrderPaymentEvent?>()) {
      return (data != null ? _i70.UserOrderPaymentEvent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.UserOrderPaymentSummary?>()) {
      return (data != null ? _i71.UserOrderPaymentSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.UserOrderSummary?>()) {
      return (data != null ? _i72.UserOrderSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.UserRole?>()) {
      return (data != null ? _i73.UserRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.Vendor?>()) {
      return (data != null ? _i74.Vendor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.VendorApplicationDetail?>()) {
      return (data != null ? _i75.VendorApplicationDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i76.VendorApplicationSummary?>()) {
      return (data != null
              ? _i76.VendorApplicationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i77.VendorBankDetails?>()) {
      return (data != null ? _i77.VendorBankDetails.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.VendorBankDetailsInput?>()) {
      return (data != null ? _i78.VendorBankDetailsInput.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i79.VendorDashboard?>()) {
      return (data != null ? _i79.VendorDashboard.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.VendorDocument?>()) {
      return (data != null ? _i80.VendorDocument.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.VendorDocumentType?>()) {
      return (data != null ? _i81.VendorDocumentType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.VendorModerationResult?>()) {
      return (data != null ? _i82.VendorModerationResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i83.VendorNotificationSummary?>()) {
      return (data != null
              ? _i83.VendorNotificationSummary.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i84.VendorNotificationType?>()) {
      return (data != null ? _i84.VendorNotificationType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i85.VendorOrderLineItem?>()) {
      return (data != null ? _i85.VendorOrderLineItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i86.VendorOrderSummary?>()) {
      return (data != null ? _i86.VendorOrderSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.VendorPaymentsOverview?>()) {
      return (data != null ? _i87.VendorPaymentsOverview.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.VendorPayout?>()) {
      return (data != null ? _i88.VendorPayout.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.VendorPayoutStatus?>()) {
      return (data != null ? _i89.VendorPayoutStatus.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i90.VendorPayoutSummary?>()) {
      return (data != null ? _i90.VendorPayoutSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i91.VendorProductStat?>()) {
      return (data != null ? _i91.VendorProductStat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.VendorProductUploadInput?>()) {
      return (data != null
              ? _i92.VendorProductUploadInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i93.VendorProfileDetail?>()) {
      return (data != null ? _i93.VendorProfileDetail.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i94.VendorProfileUpdateInput?>()) {
      return (data != null
              ? _i94.VendorProfileUpdateInput.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i95.VendorReviewSummary?>()) {
      return (data != null ? _i95.VendorReviewSummary.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.VendorShopOrder?>()) {
      return (data != null ? _i96.VendorShopOrder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.WishlistItem?>()) {
      return (data != null ? _i97.WishlistItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.WishlistPage?>()) {
      return (data != null ? _i98.WishlistPage.fromJson(data) : null) as T;
    }
    if (t == List<_i8.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i8.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<_i76.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i76.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i10.AdminProductComplaintSummary>) {
      return (data as List)
              .map((e) => deserialize<_i10.AdminProductComplaintSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i53.Product>) {
      return (data as List).map((e) => deserialize<_i53.Product>(e)).toList()
          as T;
    }
    if (t == List<_i34.Order>) {
      return (data as List).map((e) => deserialize<_i34.Order>(e)).toList()
          as T;
    }
    if (t == List<_i69.UserOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i69.UserOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i67.UserOrderDeliveryEvent>) {
      return (data as List)
              .map((e) => deserialize<_i67.UserOrderDeliveryEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i70.UserOrderPaymentEvent>) {
      return (data as List)
              .map((e) => deserialize<_i70.UserOrderPaymentEvent>(e))
              .toList()
          as T;
    }
    if (t == List<_i86.VendorOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i86.VendorOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i91.VendorProductStat>) {
      return (data as List)
              .map((e) => deserialize<_i91.VendorProductStat>(e))
              .toList()
          as T;
    }
    if (t == List<_i90.VendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i90.VendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i85.VendorOrderLineItem>) {
      return (data as List)
              .map((e) => deserialize<_i85.VendorOrderLineItem>(e))
              .toList()
          as T;
    }
    if (t == List<_i97.WishlistItem>) {
      return (data as List)
              .map((e) => deserialize<_i97.WishlistItem>(e))
              .toList()
          as T;
    }
    if (t == Set<_i99.UserRole>) {
      return (data as List).map((e) => deserialize<_i99.UserRole>(e)).toSet()
          as T;
    }
    if (t == List<_i100.UserOrderSummary>) {
      return (data as List)
              .map((e) => deserialize<_i100.UserOrderSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i101.UserArSessionSummary>) {
      return (data as List)
              .map((e) => deserialize<_i101.UserArSessionSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i102.Complaint>) {
      return (data as List).map((e) => deserialize<_i102.Complaint>(e)).toList()
          as T;
    }
    if (t == List<_i103.PlatformUserSummary>) {
      return (data as List)
              .map((e) => deserialize<_i103.PlatformUserSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i104.VendorApplicationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i104.VendorApplicationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i105.AdminAuditLogSummary>) {
      return (data as List)
              .map((e) => deserialize<_i105.AdminAuditLogSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i106.AdminVendorPayoutSummary>) {
      return (data as List)
              .map((e) => deserialize<_i106.AdminVendorPayoutSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i107.AdminRefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i107.AdminRefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i108.AdminProductSummary>) {
      return (data as List)
              .map((e) => deserialize<_i108.AdminProductSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i109.ARSession>) {
      return (data as List).map((e) => deserialize<_i109.ARSession>(e)).toList()
          as T;
    }
    if (t == List<_i110.CartItem>) {
      return (data as List).map((e) => deserialize<_i110.CartItem>(e)).toList()
          as T;
    }
    if (t == List<_i111.InAppNotificationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i111.InAppNotificationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i112.OrderDeliveryUpdate>) {
      return (data as List)
              .map((e) => deserialize<_i112.OrderDeliveryUpdate>(e))
              .toList()
          as T;
    }
    if (t == List<_i113.PaymentUpdateSummary>) {
      return (data as List)
              .map((e) => deserialize<_i113.PaymentUpdateSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i114.Category>) {
      return (data as List).map((e) => deserialize<_i114.Category>(e)).toList()
          as T;
    }
    if (t == List<_i115.ShopListingSummary>) {
      return (data as List)
              .map((e) => deserialize<_i115.ShopListingSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i116.Product>) {
      return (data as List).map((e) => deserialize<_i116.Product>(e)).toList()
          as T;
    }
    if (t == List<_i117.RefundRequestSummary>) {
      return (data as List)
              .map((e) => deserialize<_i117.RefundRequestSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i118.Review>) {
      return (data as List).map((e) => deserialize<_i118.Review>(e)).toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i119.VendorShopOrder>) {
      return (data as List)
              .map((e) => deserialize<_i119.VendorShopOrder>(e))
              .toList()
          as T;
    }
    if (t == List<_i120.VendorNotificationSummary>) {
      return (data as List)
              .map((e) => deserialize<_i120.VendorNotificationSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i121.VendorReviewSummary>) {
      return (data as List)
              .map((e) => deserialize<_i121.VendorReviewSummary>(e))
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
      _i6.AdminActionType => 'AdminActionType',
      _i7.AdminAuditLog => 'AdminAuditLog',
      _i8.AdminAuditLogSummary => 'AdminAuditLogSummary',
      _i9.AdminPlatformStats => 'AdminPlatformStats',
      _i10.AdminProductComplaintSummary => 'AdminProductComplaintSummary',
      _i11.AdminProductDetail => 'AdminProductDetail',
      _i12.AdminProductListInput => 'AdminProductListInput',
      _i13.AdminProductSummary => 'AdminProductSummary',
      _i14.AdminProductVisibilityFilter => 'AdminProductVisibilityFilter',
      _i15.AdminRefundRequestSummary => 'AdminRefundRequestSummary',
      _i16.AdminType => 'AdminType',
      _i17.AdminVendorPayoutSummary => 'AdminVendorPayoutSummary',
      _i18.ARSession => 'ARSession',
      _i19.Cart => 'Cart',
      _i20.CartItem => 'CartItem',
      _i21.Category => 'Category',
      _i22.CheckoutRequest => 'CheckoutRequest',
      _i23.CheckoutResult => 'CheckoutResult',
      _i24.Complaint => 'Complaint',
      _i25.ComplaintStatus => 'ComplaintStatus',
      _i26.CustomizationRequest => 'CustomizationRequest',
      _i27.DeliveryStage => 'DeliveryStage',
      _i28.Greeting => 'Greeting',
      _i29.InAppNotification => 'InAppNotification',
      _i30.InAppNotificationSummary => 'InAppNotificationSummary',
      _i31.InAppNotificationType => 'InAppNotificationType',
      _i32.MarketplaceHighlights => 'MarketplaceHighlights',
      _i33.NotificationPreference => 'NotificationPreference',
      _i34.Order => 'Order',
      _i35.OrderAutoCancelTrigger => 'OrderAutoCancelTrigger',
      _i36.OrderDeliveryStatus => 'OrderDeliveryStatus',
      _i37.OrderDeliveryUpdate => 'OrderDeliveryUpdate',
      _i38.OrderItem => 'OrderItem',
      _i39.OrderPage => 'OrderPage',
      _i40.OrderPaymentStatus => 'OrderPaymentStatus',
      _i41.OrderStatus => 'OrderStatus',
      _i42.OrderStatusHistory => 'OrderStatusHistory',
      _i43.OrderStatusHistoryType => 'OrderStatusHistoryType',
      _i44.OrderVendorPayment => 'OrderVendorPayment',
      _i45.PaginationInput => 'PaginationInput',
      _i46.PaymentMethod => 'PaymentMethod',
      _i47.PaymentTransaction => 'PaymentTransaction',
      _i48.PaymentTransactionStatus => 'PaymentTransactionStatus',
      _i49.PaymentUpdateSummary => 'PaymentUpdateSummary',
      _i50.PlaceifyException => 'PlaceifyException',
      _i51.PlatformUserDetail => 'PlatformUserDetail',
      _i52.PlatformUserSummary => 'PlatformUserSummary',
      _i53.Product => 'Product',
      _i54.Product3dGenerationTrigger => 'Product3dGenerationTrigger',
      _i55.ProductPage => 'ProductPage',
      _i56.ProductSearchInput => 'ProductSearchInput',
      _i57.ProductStatus => 'ProductStatus',
      _i58.RefundRequest => 'RefundRequest',
      _i59.RefundRequestSummary => 'RefundRequestSummary',
      _i60.RequestStatus => 'RequestStatus',
      _i61.Review => 'Review',
      _i62.ShopListingSummary => 'ShopListingSummary',
      _i63.User => 'User',
      _i64.UserAccountStatus => 'UserAccountStatus',
      _i65.UserArSessionSummary => 'UserArSessionSummary',
      _i66.UserDashboard => 'UserDashboard',
      _i67.UserOrderDeliveryEvent => 'UserOrderDeliveryEvent',
      _i68.UserOrderDetail => 'UserOrderDetail',
      _i69.UserOrderLineItem => 'UserOrderLineItem',
      _i70.UserOrderPaymentEvent => 'UserOrderPaymentEvent',
      _i71.UserOrderPaymentSummary => 'UserOrderPaymentSummary',
      _i72.UserOrderSummary => 'UserOrderSummary',
      _i73.UserRole => 'UserRole',
      _i74.Vendor => 'Vendor',
      _i75.VendorApplicationDetail => 'VendorApplicationDetail',
      _i76.VendorApplicationSummary => 'VendorApplicationSummary',
      _i77.VendorBankDetails => 'VendorBankDetails',
      _i78.VendorBankDetailsInput => 'VendorBankDetailsInput',
      _i79.VendorDashboard => 'VendorDashboard',
      _i80.VendorDocument => 'VendorDocument',
      _i81.VendorDocumentType => 'VendorDocumentType',
      _i82.VendorModerationResult => 'VendorModerationResult',
      _i83.VendorNotificationSummary => 'VendorNotificationSummary',
      _i84.VendorNotificationType => 'VendorNotificationType',
      _i85.VendorOrderLineItem => 'VendorOrderLineItem',
      _i86.VendorOrderSummary => 'VendorOrderSummary',
      _i87.VendorPaymentsOverview => 'VendorPaymentsOverview',
      _i88.VendorPayout => 'VendorPayout',
      _i89.VendorPayoutStatus => 'VendorPayoutStatus',
      _i90.VendorPayoutSummary => 'VendorPayoutSummary',
      _i91.VendorProductStat => 'VendorProductStat',
      _i92.VendorProductUploadInput => 'VendorProductUploadInput',
      _i93.VendorProfileDetail => 'VendorProfileDetail',
      _i94.VendorProfileUpdateInput => 'VendorProfileUpdateInput',
      _i95.VendorReviewSummary => 'VendorReviewSummary',
      _i96.VendorShopOrder => 'VendorShopOrder',
      _i97.WishlistItem => 'WishlistItem',
      _i98.WishlistPage => 'WishlistPage',
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
      case _i6.AdminActionType():
        return 'AdminActionType';
      case _i7.AdminAuditLog():
        return 'AdminAuditLog';
      case _i8.AdminAuditLogSummary():
        return 'AdminAuditLogSummary';
      case _i9.AdminPlatformStats():
        return 'AdminPlatformStats';
      case _i10.AdminProductComplaintSummary():
        return 'AdminProductComplaintSummary';
      case _i11.AdminProductDetail():
        return 'AdminProductDetail';
      case _i12.AdminProductListInput():
        return 'AdminProductListInput';
      case _i13.AdminProductSummary():
        return 'AdminProductSummary';
      case _i14.AdminProductVisibilityFilter():
        return 'AdminProductVisibilityFilter';
      case _i15.AdminRefundRequestSummary():
        return 'AdminRefundRequestSummary';
      case _i16.AdminType():
        return 'AdminType';
      case _i17.AdminVendorPayoutSummary():
        return 'AdminVendorPayoutSummary';
      case _i18.ARSession():
        return 'ARSession';
      case _i19.Cart():
        return 'Cart';
      case _i20.CartItem():
        return 'CartItem';
      case _i21.Category():
        return 'Category';
      case _i22.CheckoutRequest():
        return 'CheckoutRequest';
      case _i23.CheckoutResult():
        return 'CheckoutResult';
      case _i24.Complaint():
        return 'Complaint';
      case _i25.ComplaintStatus():
        return 'ComplaintStatus';
      case _i26.CustomizationRequest():
        return 'CustomizationRequest';
      case _i27.DeliveryStage():
        return 'DeliveryStage';
      case _i28.Greeting():
        return 'Greeting';
      case _i29.InAppNotification():
        return 'InAppNotification';
      case _i30.InAppNotificationSummary():
        return 'InAppNotificationSummary';
      case _i31.InAppNotificationType():
        return 'InAppNotificationType';
      case _i32.MarketplaceHighlights():
        return 'MarketplaceHighlights';
      case _i33.NotificationPreference():
        return 'NotificationPreference';
      case _i34.Order():
        return 'Order';
      case _i35.OrderAutoCancelTrigger():
        return 'OrderAutoCancelTrigger';
      case _i36.OrderDeliveryStatus():
        return 'OrderDeliveryStatus';
      case _i37.OrderDeliveryUpdate():
        return 'OrderDeliveryUpdate';
      case _i38.OrderItem():
        return 'OrderItem';
      case _i39.OrderPage():
        return 'OrderPage';
      case _i40.OrderPaymentStatus():
        return 'OrderPaymentStatus';
      case _i41.OrderStatus():
        return 'OrderStatus';
      case _i42.OrderStatusHistory():
        return 'OrderStatusHistory';
      case _i43.OrderStatusHistoryType():
        return 'OrderStatusHistoryType';
      case _i44.OrderVendorPayment():
        return 'OrderVendorPayment';
      case _i45.PaginationInput():
        return 'PaginationInput';
      case _i46.PaymentMethod():
        return 'PaymentMethod';
      case _i47.PaymentTransaction():
        return 'PaymentTransaction';
      case _i48.PaymentTransactionStatus():
        return 'PaymentTransactionStatus';
      case _i49.PaymentUpdateSummary():
        return 'PaymentUpdateSummary';
      case _i50.PlaceifyException():
        return 'PlaceifyException';
      case _i51.PlatformUserDetail():
        return 'PlatformUserDetail';
      case _i52.PlatformUserSummary():
        return 'PlatformUserSummary';
      case _i53.Product():
        return 'Product';
      case _i54.Product3dGenerationTrigger():
        return 'Product3dGenerationTrigger';
      case _i55.ProductPage():
        return 'ProductPage';
      case _i56.ProductSearchInput():
        return 'ProductSearchInput';
      case _i57.ProductStatus():
        return 'ProductStatus';
      case _i58.RefundRequest():
        return 'RefundRequest';
      case _i59.RefundRequestSummary():
        return 'RefundRequestSummary';
      case _i60.RequestStatus():
        return 'RequestStatus';
      case _i61.Review():
        return 'Review';
      case _i62.ShopListingSummary():
        return 'ShopListingSummary';
      case _i63.User():
        return 'User';
      case _i64.UserAccountStatus():
        return 'UserAccountStatus';
      case _i65.UserArSessionSummary():
        return 'UserArSessionSummary';
      case _i66.UserDashboard():
        return 'UserDashboard';
      case _i67.UserOrderDeliveryEvent():
        return 'UserOrderDeliveryEvent';
      case _i68.UserOrderDetail():
        return 'UserOrderDetail';
      case _i69.UserOrderLineItem():
        return 'UserOrderLineItem';
      case _i70.UserOrderPaymentEvent():
        return 'UserOrderPaymentEvent';
      case _i71.UserOrderPaymentSummary():
        return 'UserOrderPaymentSummary';
      case _i72.UserOrderSummary():
        return 'UserOrderSummary';
      case _i73.UserRole():
        return 'UserRole';
      case _i74.Vendor():
        return 'Vendor';
      case _i75.VendorApplicationDetail():
        return 'VendorApplicationDetail';
      case _i76.VendorApplicationSummary():
        return 'VendorApplicationSummary';
      case _i77.VendorBankDetails():
        return 'VendorBankDetails';
      case _i78.VendorBankDetailsInput():
        return 'VendorBankDetailsInput';
      case _i79.VendorDashboard():
        return 'VendorDashboard';
      case _i80.VendorDocument():
        return 'VendorDocument';
      case _i81.VendorDocumentType():
        return 'VendorDocumentType';
      case _i82.VendorModerationResult():
        return 'VendorModerationResult';
      case _i83.VendorNotificationSummary():
        return 'VendorNotificationSummary';
      case _i84.VendorNotificationType():
        return 'VendorNotificationType';
      case _i85.VendorOrderLineItem():
        return 'VendorOrderLineItem';
      case _i86.VendorOrderSummary():
        return 'VendorOrderSummary';
      case _i87.VendorPaymentsOverview():
        return 'VendorPaymentsOverview';
      case _i88.VendorPayout():
        return 'VendorPayout';
      case _i89.VendorPayoutStatus():
        return 'VendorPayoutStatus';
      case _i90.VendorPayoutSummary():
        return 'VendorPayoutSummary';
      case _i91.VendorProductStat():
        return 'VendorProductStat';
      case _i92.VendorProductUploadInput():
        return 'VendorProductUploadInput';
      case _i93.VendorProfileDetail():
        return 'VendorProfileDetail';
      case _i94.VendorProfileUpdateInput():
        return 'VendorProfileUpdateInput';
      case _i95.VendorReviewSummary():
        return 'VendorReviewSummary';
      case _i96.VendorShopOrder():
        return 'VendorShopOrder';
      case _i97.WishlistItem():
        return 'WishlistItem';
      case _i98.WishlistPage():
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
    if (dataClassName == 'AdminActionType') {
      return deserialize<_i6.AdminActionType>(data['data']);
    }
    if (dataClassName == 'AdminAuditLog') {
      return deserialize<_i7.AdminAuditLog>(data['data']);
    }
    if (dataClassName == 'AdminAuditLogSummary') {
      return deserialize<_i8.AdminAuditLogSummary>(data['data']);
    }
    if (dataClassName == 'AdminPlatformStats') {
      return deserialize<_i9.AdminPlatformStats>(data['data']);
    }
    if (dataClassName == 'AdminProductComplaintSummary') {
      return deserialize<_i10.AdminProductComplaintSummary>(data['data']);
    }
    if (dataClassName == 'AdminProductDetail') {
      return deserialize<_i11.AdminProductDetail>(data['data']);
    }
    if (dataClassName == 'AdminProductListInput') {
      return deserialize<_i12.AdminProductListInput>(data['data']);
    }
    if (dataClassName == 'AdminProductSummary') {
      return deserialize<_i13.AdminProductSummary>(data['data']);
    }
    if (dataClassName == 'AdminProductVisibilityFilter') {
      return deserialize<_i14.AdminProductVisibilityFilter>(data['data']);
    }
    if (dataClassName == 'AdminRefundRequestSummary') {
      return deserialize<_i15.AdminRefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'AdminType') {
      return deserialize<_i16.AdminType>(data['data']);
    }
    if (dataClassName == 'AdminVendorPayoutSummary') {
      return deserialize<_i17.AdminVendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'ARSession') {
      return deserialize<_i18.ARSession>(data['data']);
    }
    if (dataClassName == 'Cart') {
      return deserialize<_i19.Cart>(data['data']);
    }
    if (dataClassName == 'CartItem') {
      return deserialize<_i20.CartItem>(data['data']);
    }
    if (dataClassName == 'Category') {
      return deserialize<_i21.Category>(data['data']);
    }
    if (dataClassName == 'CheckoutRequest') {
      return deserialize<_i22.CheckoutRequest>(data['data']);
    }
    if (dataClassName == 'CheckoutResult') {
      return deserialize<_i23.CheckoutResult>(data['data']);
    }
    if (dataClassName == 'Complaint') {
      return deserialize<_i24.Complaint>(data['data']);
    }
    if (dataClassName == 'ComplaintStatus') {
      return deserialize<_i25.ComplaintStatus>(data['data']);
    }
    if (dataClassName == 'CustomizationRequest') {
      return deserialize<_i26.CustomizationRequest>(data['data']);
    }
    if (dataClassName == 'DeliveryStage') {
      return deserialize<_i27.DeliveryStage>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i28.Greeting>(data['data']);
    }
    if (dataClassName == 'InAppNotification') {
      return deserialize<_i29.InAppNotification>(data['data']);
    }
    if (dataClassName == 'InAppNotificationSummary') {
      return deserialize<_i30.InAppNotificationSummary>(data['data']);
    }
    if (dataClassName == 'InAppNotificationType') {
      return deserialize<_i31.InAppNotificationType>(data['data']);
    }
    if (dataClassName == 'MarketplaceHighlights') {
      return deserialize<_i32.MarketplaceHighlights>(data['data']);
    }
    if (dataClassName == 'NotificationPreference') {
      return deserialize<_i33.NotificationPreference>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i34.Order>(data['data']);
    }
    if (dataClassName == 'OrderAutoCancelTrigger') {
      return deserialize<_i35.OrderAutoCancelTrigger>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryStatus') {
      return deserialize<_i36.OrderDeliveryStatus>(data['data']);
    }
    if (dataClassName == 'OrderDeliveryUpdate') {
      return deserialize<_i37.OrderDeliveryUpdate>(data['data']);
    }
    if (dataClassName == 'OrderItem') {
      return deserialize<_i38.OrderItem>(data['data']);
    }
    if (dataClassName == 'OrderPage') {
      return deserialize<_i39.OrderPage>(data['data']);
    }
    if (dataClassName == 'OrderPaymentStatus') {
      return deserialize<_i40.OrderPaymentStatus>(data['data']);
    }
    if (dataClassName == 'OrderStatus') {
      return deserialize<_i41.OrderStatus>(data['data']);
    }
    if (dataClassName == 'OrderStatusHistory') {
      return deserialize<_i42.OrderStatusHistory>(data['data']);
    }
    if (dataClassName == 'OrderStatusHistoryType') {
      return deserialize<_i43.OrderStatusHistoryType>(data['data']);
    }
    if (dataClassName == 'OrderVendorPayment') {
      return deserialize<_i44.OrderVendorPayment>(data['data']);
    }
    if (dataClassName == 'PaginationInput') {
      return deserialize<_i45.PaginationInput>(data['data']);
    }
    if (dataClassName == 'PaymentMethod') {
      return deserialize<_i46.PaymentMethod>(data['data']);
    }
    if (dataClassName == 'PaymentTransaction') {
      return deserialize<_i47.PaymentTransaction>(data['data']);
    }
    if (dataClassName == 'PaymentTransactionStatus') {
      return deserialize<_i48.PaymentTransactionStatus>(data['data']);
    }
    if (dataClassName == 'PaymentUpdateSummary') {
      return deserialize<_i49.PaymentUpdateSummary>(data['data']);
    }
    if (dataClassName == 'PlaceifyException') {
      return deserialize<_i50.PlaceifyException>(data['data']);
    }
    if (dataClassName == 'PlatformUserDetail') {
      return deserialize<_i51.PlatformUserDetail>(data['data']);
    }
    if (dataClassName == 'PlatformUserSummary') {
      return deserialize<_i52.PlatformUserSummary>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i53.Product>(data['data']);
    }
    if (dataClassName == 'Product3dGenerationTrigger') {
      return deserialize<_i54.Product3dGenerationTrigger>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_i55.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductSearchInput') {
      return deserialize<_i56.ProductSearchInput>(data['data']);
    }
    if (dataClassName == 'ProductStatus') {
      return deserialize<_i57.ProductStatus>(data['data']);
    }
    if (dataClassName == 'RefundRequest') {
      return deserialize<_i58.RefundRequest>(data['data']);
    }
    if (dataClassName == 'RefundRequestSummary') {
      return deserialize<_i59.RefundRequestSummary>(data['data']);
    }
    if (dataClassName == 'RequestStatus') {
      return deserialize<_i60.RequestStatus>(data['data']);
    }
    if (dataClassName == 'Review') {
      return deserialize<_i61.Review>(data['data']);
    }
    if (dataClassName == 'ShopListingSummary') {
      return deserialize<_i62.ShopListingSummary>(data['data']);
    }
    if (dataClassName == 'User') {
      return deserialize<_i63.User>(data['data']);
    }
    if (dataClassName == 'UserAccountStatus') {
      return deserialize<_i64.UserAccountStatus>(data['data']);
    }
    if (dataClassName == 'UserArSessionSummary') {
      return deserialize<_i65.UserArSessionSummary>(data['data']);
    }
    if (dataClassName == 'UserDashboard') {
      return deserialize<_i66.UserDashboard>(data['data']);
    }
    if (dataClassName == 'UserOrderDeliveryEvent') {
      return deserialize<_i67.UserOrderDeliveryEvent>(data['data']);
    }
    if (dataClassName == 'UserOrderDetail') {
      return deserialize<_i68.UserOrderDetail>(data['data']);
    }
    if (dataClassName == 'UserOrderLineItem') {
      return deserialize<_i69.UserOrderLineItem>(data['data']);
    }
    if (dataClassName == 'UserOrderPaymentEvent') {
      return deserialize<_i70.UserOrderPaymentEvent>(data['data']);
    }
    if (dataClassName == 'UserOrderPaymentSummary') {
      return deserialize<_i71.UserOrderPaymentSummary>(data['data']);
    }
    if (dataClassName == 'UserOrderSummary') {
      return deserialize<_i72.UserOrderSummary>(data['data']);
    }
    if (dataClassName == 'UserRole') {
      return deserialize<_i73.UserRole>(data['data']);
    }
    if (dataClassName == 'Vendor') {
      return deserialize<_i74.Vendor>(data['data']);
    }
    if (dataClassName == 'VendorApplicationDetail') {
      return deserialize<_i75.VendorApplicationDetail>(data['data']);
    }
    if (dataClassName == 'VendorApplicationSummary') {
      return deserialize<_i76.VendorApplicationSummary>(data['data']);
    }
    if (dataClassName == 'VendorBankDetails') {
      return deserialize<_i77.VendorBankDetails>(data['data']);
    }
    if (dataClassName == 'VendorBankDetailsInput') {
      return deserialize<_i78.VendorBankDetailsInput>(data['data']);
    }
    if (dataClassName == 'VendorDashboard') {
      return deserialize<_i79.VendorDashboard>(data['data']);
    }
    if (dataClassName == 'VendorDocument') {
      return deserialize<_i80.VendorDocument>(data['data']);
    }
    if (dataClassName == 'VendorDocumentType') {
      return deserialize<_i81.VendorDocumentType>(data['data']);
    }
    if (dataClassName == 'VendorModerationResult') {
      return deserialize<_i82.VendorModerationResult>(data['data']);
    }
    if (dataClassName == 'VendorNotificationSummary') {
      return deserialize<_i83.VendorNotificationSummary>(data['data']);
    }
    if (dataClassName == 'VendorNotificationType') {
      return deserialize<_i84.VendorNotificationType>(data['data']);
    }
    if (dataClassName == 'VendorOrderLineItem') {
      return deserialize<_i85.VendorOrderLineItem>(data['data']);
    }
    if (dataClassName == 'VendorOrderSummary') {
      return deserialize<_i86.VendorOrderSummary>(data['data']);
    }
    if (dataClassName == 'VendorPaymentsOverview') {
      return deserialize<_i87.VendorPaymentsOverview>(data['data']);
    }
    if (dataClassName == 'VendorPayout') {
      return deserialize<_i88.VendorPayout>(data['data']);
    }
    if (dataClassName == 'VendorPayoutStatus') {
      return deserialize<_i89.VendorPayoutStatus>(data['data']);
    }
    if (dataClassName == 'VendorPayoutSummary') {
      return deserialize<_i90.VendorPayoutSummary>(data['data']);
    }
    if (dataClassName == 'VendorProductStat') {
      return deserialize<_i91.VendorProductStat>(data['data']);
    }
    if (dataClassName == 'VendorProductUploadInput') {
      return deserialize<_i92.VendorProductUploadInput>(data['data']);
    }
    if (dataClassName == 'VendorProfileDetail') {
      return deserialize<_i93.VendorProfileDetail>(data['data']);
    }
    if (dataClassName == 'VendorProfileUpdateInput') {
      return deserialize<_i94.VendorProfileUpdateInput>(data['data']);
    }
    if (dataClassName == 'VendorReviewSummary') {
      return deserialize<_i95.VendorReviewSummary>(data['data']);
    }
    if (dataClassName == 'VendorShopOrder') {
      return deserialize<_i96.VendorShopOrder>(data['data']);
    }
    if (dataClassName == 'WishlistItem') {
      return deserialize<_i97.WishlistItem>(data['data']);
    }
    if (dataClassName == 'WishlistPage') {
      return deserialize<_i98.WishlistPage>(data['data']);
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
      case _i7.AdminAuditLog:
        return _i7.AdminAuditLog.t;
      case _i18.ARSession:
        return _i18.ARSession.t;
      case _i19.Cart:
        return _i19.Cart.t;
      case _i20.CartItem:
        return _i20.CartItem.t;
      case _i21.Category:
        return _i21.Category.t;
      case _i24.Complaint:
        return _i24.Complaint.t;
      case _i26.CustomizationRequest:
        return _i26.CustomizationRequest.t;
      case _i29.InAppNotification:
        return _i29.InAppNotification.t;
      case _i33.NotificationPreference:
        return _i33.NotificationPreference.t;
      case _i34.Order:
        return _i34.Order.t;
      case _i37.OrderDeliveryUpdate:
        return _i37.OrderDeliveryUpdate.t;
      case _i38.OrderItem:
        return _i38.OrderItem.t;
      case _i42.OrderStatusHistory:
        return _i42.OrderStatusHistory.t;
      case _i44.OrderVendorPayment:
        return _i44.OrderVendorPayment.t;
      case _i47.PaymentTransaction:
        return _i47.PaymentTransaction.t;
      case _i53.Product:
        return _i53.Product.t;
      case _i58.RefundRequest:
        return _i58.RefundRequest.t;
      case _i61.Review:
        return _i61.Review.t;
      case _i63.User:
        return _i63.User.t;
      case _i74.Vendor:
        return _i74.Vendor.t;
      case _i77.VendorBankDetails:
        return _i77.VendorBankDetails.t;
      case _i80.VendorDocument:
        return _i80.VendorDocument.t;
      case _i88.VendorPayout:
        return _i88.VendorPayout.t;
      case _i97.WishlistItem:
        return _i97.WishlistItem.t;
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
