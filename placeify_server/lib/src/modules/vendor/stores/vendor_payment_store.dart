/// Vendor-facing payment and payout operations.
///
/// Implemented in the payment module; this alias keeps the vendor domain
/// surface consistent with other `Vendor*Store` types.
export '../../payment/payment_repository.dart' show PaymentStore;

typedef VendorPaymentStore = PaymentStore;
