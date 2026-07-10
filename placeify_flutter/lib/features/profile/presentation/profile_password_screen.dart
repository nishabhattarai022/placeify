import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_nav/bottom_nav_tokens.dart';
import '../../../core/widgets/toast_overlay.dart';
import 'widgets/profile_sub_hero.dart';
import 'widgets/shared/password_strength_panel.dart';
import 'widgets/shared/profile_form_field.dart';
import 'widgets/shared/profile_submit_button.dart';

class ProfilePasswordScreen extends StatefulWidget {
  const ProfilePasswordScreen({super.key});

  @override
  State<ProfilePasswordScreen> createState() => _ProfilePasswordScreenState();
}

class _ProfilePasswordScreenState extends State<ProfilePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  String _matchLabel = '';
  Color _matchColor = AppColors.textMuted;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _checkMatch(String value) {
    if (value.isEmpty) {
      setState(() {
        _matchLabel = '';
        _matchColor = AppColors.textMuted;
      });
      return;
    }
    if (value == _newController.text) {
      setState(() {
        _matchLabel = '✓ Passwords match';
        _matchColor = AppColors.teal;
      });
    } else {
      setState(() {
        _matchLabel = '✗ Passwords do not match';
        _matchColor = AppColors.rust;
      });
    }
  }

  void _submit() {
    final cur = _currentController.text;
    final nw = _newController.text;
    final con = _confirmController.text;
    if (cur.isEmpty || nw.isEmpty || con.isEmpty) {
      PlaceifyToast.show(context, 'Please fill all fields');
      return;
    }
    if (nw != con) {
      PlaceifyToast.show(context, 'Passwords do not match');
      return;
    }
    if (nw.length < 8) {
      PlaceifyToast.show(context, 'Password too short');
      return;
    }
    PlaceifyToast.show(context, 'Password updated successfully ✓');
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          const ProfileSubHero(title: 'Change Password'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                18,
                20,
                18,
                BottomNavTokens.scrollBottomPadding,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.espresso, Color(0xFF3D2215)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: AppColors.accentLight,
                        size: 28,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keep your account safe',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "Use a strong unique password you don't use anywhere else. We'll never ask for it via email.",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0x80FFFFFF),
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ProfileFormField(
                  label: 'Current Password',
                  child: ProfileTextInput(
                    controller: _currentController,
                    hint: 'Enter current password',
                    obscureText: !_showCurrent,
                    suffix: IconButton(
                      icon: Icon(
                        _showCurrent
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textMuted,
                      ),
                      onPressed: () =>
                          setState(() => _showCurrent = !_showCurrent),
                    ),
                  ),
                ),
                ProfileFormField(
                  label: 'New Password',
                  child: Column(
                    children: [
                      ProfileTextInput(
                        controller: _newController,
                        hint: 'Enter new password',
                        obscureText: !_showNew,
                        onChanged: (_) => setState(() {}),
                        suffix: IconButton(
                          icon: Icon(
                            _showNew
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () =>
                              setState(() => _showNew = !_showNew),
                        ),
                      ),
                      PasswordStrengthPanel(password: _newController.text),
                    ],
                  ),
                ),
                ProfileFormField(
                  label: 'Confirm New Password',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfileTextInput(
                        controller: _confirmController,
                        hint: 'Repeat new password',
                        obscureText: !_showConfirm,
                        onChanged: _checkMatch,
                        suffix: IconButton(
                          icon: Icon(
                            _showConfirm
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () =>
                              setState(() => _showConfirm = !_showConfirm),
                        ),
                      ),
                      if (_matchLabel.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(
                          _matchLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: _matchColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                ProfileSubmitButton(
                  label: 'Update Password',
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
