# Placeify Auth QA Checklist

Run against **staging** with real email (Resend) configured.

## Prerequisites

- [ ] Backend running with `--mode staging`
- [ ] `SERVERPOD_PASSWORD_emailProvider=resend`
- [ ] Frontend built with `--dart-define=APP_ENV=staging`
- [ ] Fresh test email inbox available

---

## Registration

- [ ] Open app → Create Account
- [ ] Submit name, email, password
- [ ] **Verification email arrives** (not server terminal)
- [ ] Enter code → lands on Home
- [ ] `user.getCurrentUser` returns name + `role: consumer`

## Login

- [ ] Log out from Profile
- [ ] Sign in with same email/password
- [ ] Redirected to Home (not Login)

## Token refresh

- [ ] Leave app open 15+ minutes (or force refresh via debug)
- [ ] Protected screens still work without re-login

## Protected routes

- [ ] Log out → manually navigate to `/home` → redirected to Login
- [ ] `/vendor`, `/category/*`, `/ar/*` also redirect when logged out

## Profile

- [ ] Profile tab shows user name
- [ ] Log out clears session and shows Login

## Password reset (API / future UI)

- [ ] `emailIdp.startPasswordReset` sends email
- [ ] Code from email completes reset
- [ ] Login works with new password

## Vendor role (API)

- [ ] Call `user.becomeVendor` when authenticated → `role: vendor`

---

## Expected automated tests

```bash
cd placeify_server
docker compose up -d
dart test test/integration/
```

All integration tests should pass.
