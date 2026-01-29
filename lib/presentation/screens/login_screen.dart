import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() async {
    setState(() {
      _emailError = null;
      _passwordError = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    bool hasError = false;

    if (email.isEmpty || !email.contains('@')) {
      setState(() => _emailError = 'Please enter a valid email address');
      hasError = true;
    }

    if (password.isEmpty || password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    // Call real API via AuthProvider
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(email, password);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      _showToast('Login successful!');
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      _showToast(authProvider.error ?? 'Login failed. Please try again.');
    }
  }

  void _handleSocialLogin(String provider) {
    _showToast('$provider login coming soon!');
  }

  void _handleForgotPassword() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && email.contains('@')) {
      _showToast('Password reset link sent to $email');
    } else {
      _showToast('Please enter your email first');
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: r.w(20)),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: r.h(60)),
                _buildLogo(r),
                SizedBox(height: r.h(24)),
                Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.sp(28),
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(height: r.h(8)),
                Text(
                  'Sign in to continue with CheckFlow',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: r.sp(15),
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                SizedBox(height: r.h(40)),
                _buildLabel('Email', isDark, r),
                SizedBox(height: r.h(8)),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  error: _emailError,
                  isDark: isDark,
                  r: r,
                ),
                SizedBox(height: r.h(20)),
                _buildLabel('Password', isDark, r),
                SizedBox(height: r.h(8)),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Enter your password',
                  obscureText: _obscurePassword,
                  error: _passwordError,
                  isDark: isDark,
                  r: r,
                  suffixIcon: IconButton(
                    onPressed: _togglePasswordVisibility,
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      size: r.w(20),
                    ),
                  ),
                ),
                SizedBox(height: r.h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: r.w(20),
                          height: r.w(20),
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (value) => setState(() => _rememberMe = value ?? false),
                            activeColor: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: r.w(8)),
                        Text(
                          'Remember me',
                          style: TextStyle(
                            fontSize: r.sp(14),
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _handleForgotPassword,
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontSize: r.sp(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.h(24)),
                _buildPrimaryButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  isLoading: _isLoading,
                  label: 'Sign In',
                  r: r,
                ),
                SizedBox(height: r.h(32)),
                _buildDivider(isDark, r),
                SizedBox(height: r.h(32)),
                _buildSocialButton(
                  onPressed: () => _handleSocialLogin('Google'),
                  icon: _buildGoogleIcon(r),
                  label: 'Continue with Google',
                  isDark: isDark,
                  r: r,
                ),
                SizedBox(height: r.h(12)),
                _buildSocialButton(
                  onPressed: () => _handleSocialLogin('Apple'),
                  icon: Icon(Icons.apple, color: isDark ? Colors.white : Colors.black, size: r.w(20)),
                  label: 'Continue with Apple',
                  isDark: isDark,
                  r: r,
                ),
                SizedBox(height: r.h(32)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: r.sp(14),
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed('/register'),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: r.sp(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: r.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(Responsive r) {
    return Center(
      child: Container(
        width: r.w(80),
        height: r.w(80),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(r.r(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: r.w(32),
              offset: Offset(0, r.h(8)),
            ),
          ],
        ),
        child: Icon(
          Icons.check_box_outlined,
          size: r.w(44),
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark, Responsive r) {
    return Text(
      text,
      style: TextStyle(
        fontSize: r.sp(14),
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    required Responsive r,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? error,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: r.h(52),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.gray100,
            borderRadius: BorderRadius.circular(r.r(12)),
            border: error != null ? Border.all(color: AppColors.error, width: 2) : null,
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: TextStyle(
              fontSize: r.sp(16),
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                fontSize: r.sp(16),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: r.w(16), vertical: r.h(14)),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        if (error != null) ...[
          SizedBox(height: r.h(6)),
          Text(
            error,
            style: TextStyle(fontSize: r.sp(13), color: AppColors.terracotta),
          ),
        ],
      ],
    );
  }

  Widget _buildPrimaryButton({
    required VoidCallback? onPressed,
    required String label,
    required Responsive r,
    bool isLoading = false,
  }) {
    return Container(
      height: r.h(56),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(r.r(14)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: r.w(16),
            offset: Offset(0, r.h(4)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(r.r(14)),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: r.w(20),
                    height: r.w(20),
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: r.sp(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark, Responsive r) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: r.w(16)),
          child: Text(
            'or continue with',
            style: TextStyle(
              fontSize: r.sp(13),
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
    required bool isDark,
    required Responsive r,
  }) {
    return Container(
      height: r.h(52),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(r.r(12)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(r.r(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              SizedBox(width: r.w(12)),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.sp(15),
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleIcon(Responsive r) {
    return SizedBox(
      width: r.w(20),
      height: r.w(20),
      child: Stack(
        children: [
          Icon(Icons.g_mobiledata, size: r.w(24), color: Colors.blue[600]),
        ],
      ),
    );
  }
}
