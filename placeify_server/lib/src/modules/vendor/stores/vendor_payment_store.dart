/// Vendor-facing payment and payout operations.
///
/// Implemented in the payment module; this alias keeps the vendor domain
/// surface consistent with other `Vendor*Store` types.
import '../../payment/payment_repository.dart';

typedef VendorPaymentStore = PaymentStore;
