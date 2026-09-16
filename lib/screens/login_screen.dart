import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Color primaryBlue = Color(0xFF0164B1);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    await auth.login(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 10),
                    _buildMessage(l10n.loginWelcomeTitle, l10n.loginWelcomeSubtitle),
                    const SizedBox(height: 40),
                    _buildEmailField(l10n),
                    const SizedBox(height: 20),
                    _buildPasswordField(auth, l10n),
                    if (auth.errorMessage != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        auth.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 40),
                    _buildLoginButton(auth),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Image.asset('assets/demo.png', height: 150),
    );
  }

  Widget _buildMessage(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: LoginScreen.primaryBlue,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildEmailField(AppLocalizations l10n) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: l10n.loginEmailHint,
        labelText: l10n.loginEmailLabel,
        prefixIcon: const Icon(Icons.alternate_email_outlined),
      ),
      validator: (v) =>
          (v == null || v.trim().isEmpty) ? l10n.loginEmailValidatorEmpty : null,
    );
  }

  Widget _buildPasswordField(AuthProvider auth, AppLocalizations l10n) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onFieldSubmitted: (_) => _submit(auth),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: l10n.loginPasswordHint,
        labelText: l10n.loginPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      validator: (v) =>
          (v == null || v.isEmpty) ? l10n.loginPasswordValidatorEmpty : null,
    );
  }

  Widget _buildLoginButton(AuthProvider auth) {
    return Align(
      alignment: Alignment.center,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : () => _submit(auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: LoginScreen.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 18),
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                AppLocalizations.of(context)!.loginButton,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
