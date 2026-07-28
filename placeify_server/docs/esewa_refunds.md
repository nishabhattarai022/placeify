# eSewa refunds (Mode B)

Placeify settles eSewa refunds using **Mode B**: no inventing a merchant
“create refund” HTTP API. Completion happens only when eSewa’s existing
transaction status enquiry reports `FULL_REFUND`.

## Flow

1. Customer requests a refund → order `returnRequested`, refund `pending`.
2. Admin or vendor **approves** an eSewa refund:
   - `EsewaRefundService.initiateRefund` is called (Mode A seam).
   - Today it returns **unavailable** unless/until an official API is wired.
   - Payment → `refundPending`, refund → `inProgress`, order stays
     `returnRequested`, `settlementMode=manual_portal`.
3. Merchant completes the refund in the **eSewa merchant portal** (outside the app).
4. Confirmation:
   - Background poller `esewaRefundStatus` (every ~15 minutes), or
   - Admin **Check status** / **Retry check** / **Complete manual**.
5. When status is `FULL_REFUND`:
   - Payment → `refunded`
   - Refund → `completed` (+ `refundCompletedAt`, gateway fields)
   - Order → `refunded`
   - Customer is notified.

If status is still `COMPLETE` (or anything other than `FULL_REFUND`), the
refund stays in progress; gateway fields are updated for audit.

**Complete Manual Settlement** re-checks the status API and completes **only**
if `FULL_REFUND` is returned. It never fakes a completed refund.

## Secrets (Serverpod passwords only)

Never send these to Flutter. Configure in `config/passwords.yaml` (local) /
deployment secrets:

| Key | Purpose |
|-----|---------|
| `esewaProductCode` | ePay merchant product code |
| `esewaSecretKey` | ePay signing secret |
| `esewaRefundEndpoint` | **Placeholder** for future Mode A create-refund URL |
| `esewaRefundSecretKey` | **Placeholder** for future Mode A secret |

`isInitiateConfigured` is true only when `esewaRefundEndpoint` is non-empty.
Even then, `initiateRefund` stays unavailable until a real initiator is
implemented from **official** eSewa docs. Do not invent request bodies.

## Admin UI

`/admin/refunds` lists refunds with gateway status. For in-progress eSewa rows:

- Check status
- Retry check
- Complete manual (requires `FULL_REFUND`)

## Out of scope

- Fabricated create-refund HTTP
- Refund webhooks (ePay has no documented refund webhook for this flow)
- Demo shortcuts that mark refunds completed without gateway confirmation
