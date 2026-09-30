import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/widgets/pitch_widgets.dart';
import '../../pitches/view/app_shell.dart';
import '../model/user_account.dart';
import '../viewmodel/auth_view_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({
    super.key,
    this.createAccount = false,
    required this.themeViewModel,
  });

  final bool createAccount;
  final AppThemeViewModel themeViewModel;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthViewModel _viewModel;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    if (widget.createAccount) _viewModel.toggleMode();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final account = _viewModel.submit(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (account == null) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (_) =>
            AppShell(account: account, themeViewModel: widget.themeViewModel),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, child) {
            final palette = KickOffPalette.of(context);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const KickOffMark(size: 48),
                  const SizedBox(height: 28),
                  Text(
                    _viewModel.isCreatingAccount
                        ? 'Find your\nplaying field.'
                        : 'Welcome\nback.',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1.06,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _viewModel.isCreatingAccount
                        ? _viewModel.selectedRole == AccountRole.owner
                              ? 'Create an owner account to manage bookings and check in players.'
                              : 'Create an account to book pitches and manage your sessions.'
                        : 'Sign in to manage your upcoming sessions.',
                    style: TextStyle(color: palette.muted, height: 1.4),
                  ),
                  const SizedBox(height: 30),
                  if (_viewModel.isCreatingAccount) ...[
                    _AuthField(
                      label: 'Full name',
                      hint: 'Your name',
                      icon: Icons.person_outline,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    _viewModel.isCreatingAccount
                        ? 'Account type'
                        : 'Sign in as',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 9),
                  SegmentedButton<AccountRole>(
                    segments: const [
                      ButtonSegment(
                        value: AccountRole.player,
                        label: Text('Player'),
                        icon: Icon(Icons.sports_soccer_outlined),
                      ),
                      ButtonSegment(
                        value: AccountRole.owner,
                        label: Text('Pitch owner'),
                        icon: Icon(Icons.storefront_outlined),
                      ),
                    ],
                    selected: {_viewModel.selectedRole},
                    onSelectionChanged: (roles) =>
                        _viewModel.selectRole(roles.first),
                    showSelectedIcon: false,
                  ),
                  const SizedBox(height: 20),
                  _AuthField(
                    label: 'Email address',
                    hint: 'name@example.com',
                    icon: Icons.mail_outline,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _AuthField(
                    label: 'Password',
                    hint: 'At least 6 characters',
                    icon: Icons.lock_outline,
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  if (!_viewModel.isCreatingAccount)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showForgotPassword(context),
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(color: palette.accent),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 23),
                  if (_viewModel.errorMessage != null) ...[
                    Text(
                      _viewModel.errorMessage!,
                      style: const TextStyle(
                        color: Color(0xFFFF8D8D),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  KickOffButton(
                    label: _viewModel.isCreatingAccount
                        ? 'Create account'
                        : 'Sign in',
                    icon: Icons.arrow_forward,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _viewModel.isCreatingAccount
                            ? 'Already a member?'
                            : 'New to Kick Off?',
                        style: TextStyle(color: palette.muted),
                      ),
                      TextButton(
                        onPressed: _viewModel.toggleMode,
                        child: Text(
                          _viewModel.isCreatingAccount
                              ? 'Sign in'
                              : 'Create account',
                          style: TextStyle(
                            color: palette.accent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showForgotPassword(BuildContext context) {
    final palette = KickOffPalette.of(context);
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: palette.surface,
        title: const Text('Reset password'),
        content: const Text(
          'Password reset is not connected yet. Try creating an account or sign in with any valid email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class _AuthField extends StatelessWidget {
  const _AuthField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final palette = KickOffPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 19),
            filled: true,
            fillColor: palette.surface,
            hintStyle: TextStyle(color: palette.muted, fontSize: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: palette.line),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: palette.accent),
            ),
          ),
        ),
      ],
    );
  }
}
