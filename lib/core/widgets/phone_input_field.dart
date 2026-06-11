import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/country_phone_codes.dart';
import '../services/haptic_service.dart';
import 'placeify_bottom_sheet.dart';

/// Composite phone field: country dial-code picker + local digits input.
///
/// Emits full numbers as `"+977 980823094"` (dial code, space, local digits).
class PhoneInputField extends StatefulWidget {
  const PhoneInputField({
    this.initialPhone,
    this.onChanged,
    super.key,
  });

  final String? initialPhone;
  final ValueChanged<String>? onChanged;

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  late CountryPhoneCode _selectedCountry;
  late final TextEditingController _localController;
  String? _lastEmitted;

  @override
  void initState() {
    super.initState();
    final parsed = _parsePhone(widget.initialPhone);
    _selectedCountry = parsed.country;
    _localController = TextEditingController(text: parsed.local);
    _lastEmitted = _formatFull(_selectedCountry, parsed.local);
  }

  @override
  void didUpdateWidget(PhoneInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPhone != oldWidget.initialPhone &&
        widget.initialPhone != _lastEmitted) {
      _applyParsed(_parsePhone(widget.initialPhone));
    }
  }

  @override
  void dispose() {
    _localController.dispose();
    super.dispose();
  }

  void _applyParsed(({CountryPhoneCode country, String local}) parsed) {
    setState(() => _selectedCountry = parsed.country);
    if (_localController.text != parsed.local) {
      _localController.text = parsed.local;
      _localController.selection = TextSelection.collapsed(
        offset: parsed.local.length,
      );
    }
    _lastEmitted = _formatFull(parsed.country, parsed.local);
  }

  void _emit() {
    final full = _formatFull(_selectedCountry, _localController.text);
    _lastEmitted = full;
    widget.onChanged?.call(full);
  }

  Future<void> _openCountrySheet() async {
    await HapticService.light();
    if (!mounted) return;

    await PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PlaceifyBottomSheetHeader(
              title: 'Country code',
              subtitle: 'Select your phone country',
            ),
            const SizedBox(height: AppSpacing.lg),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final country in CountryPhoneCodes.all)
                      PlaceifySelectTile(
                        label:
                            '${country.isoCode}  ${country.name}  ${country.dialCode}',
                        selected: _selectedCountry.isoCode == country.isoCode &&
                            _selectedCountry.dialCode == country.dialCode,
                        semanticsLabel:
                            '${country.name}, ${country.dialCode}',
                        onTap: () => _selectCountry(sheetContext, country),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _selectCountry(BuildContext sheetContext, CountryPhoneCode country) {
    if (_selectedCountry.isoCode != country.isoCode ||
        _selectedCountry.dialCode != country.dialCode) {
      HapticService.selection();
      setState(() => _selectedCountry = country);
      _emit();
    }
    Navigator.pop(sheetContext);
  }

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(14));
    const borderSide = BorderSide(color: AppColors.creamDark, width: 1.5);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: borderRadius,
        border: const Border.fromBorderSide(borderSide),
      ),
      child: Row(
        children: [
          _CountryChip(
            dialCode: _selectedCountry.dialCode,
            onTap: _openCountrySheet,
          ),
          Container(
            width: 1,
            height: 28,
            color: AppColors.creamDark,
          ),
          Expanded(
            child: TextField(
              controller: _localController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(_selectedCountry.localMaxLength),
              ],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.espresso,
              ),
              decoration: InputDecoration(
                hintText: _selectedCountry.localPlaceholder,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                filled: true,
                fillColor: AppColors.cream,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 13,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (_) => _emit(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryChip extends StatelessWidget {
  const _CountryChip({
    required this.dialCode,
    required this.onTap,
  });

  final String dialCode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dialCode,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColors.espresso,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Longest-match dial-code scan; falls back to [CountryPhoneCodes.defaultCountry].
({CountryPhoneCode country, String local}) _parsePhone(String? raw) {
  if (raw == null || raw.trim().isEmpty) {
    return (country: CountryPhoneCodes.defaultCountry, local: '');
  }

  final normalized = raw.replaceAll(RegExp(r'[\s\-().]'), '');
  if (!normalized.startsWith('+')) {
    final digits = normalized.replaceAll(RegExp(r'\D'), '');
    return (country: CountryPhoneCodes.defaultCountry, local: digits);
  }

  final byDialLength = [...CountryPhoneCodes.all]
    ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

  for (final country in byDialLength) {
    if (normalized.startsWith(country.dialCode)) {
      final local = normalized
          .substring(country.dialCode.length)
          .replaceAll(RegExp(r'\D'), '');
      return (country: country, local: local);
    }
  }

  final fallbackLocal = normalized.replaceAll(RegExp(r'\D'), '');
  return (country: CountryPhoneCodes.defaultCountry, local: fallbackLocal);
}

String _formatFull(CountryPhoneCode country, String local) {
  final digits = local.trim();
  if (digits.isEmpty) return country.dialCode;
  return '${country.dialCode} $digits';
}
