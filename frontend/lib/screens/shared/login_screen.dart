import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:gazlink_app/providers/auth_provider.dart';
import 'package:gazlink_app/theme/glass/glass_components.dart';
import 'package:gazlink_app/theme/glass/glass_constants.dart';
import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _phoneFocused = false;
  bool _passwordFocused = false;
  String _selectedRole = 'CLIENT'; // CLIENT or DELIVERER

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    final success = await context.read<AuthProvider>().login(
      phone: _phoneController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );
    
    if (!mounted) return;
    
    setState(() => _isLoading = false);
    
    if (success) {
      // Navigate to appropriate home screen based on role
      if (_selectedRole == 'CLIENT') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.clientHome);
      } else if (_selectedRole == 'DELIVERER') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.delivererHome);
      }
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur de connexion. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required IconData icon,
    required bool isFocused,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    final brightness = Theme.of(context).brightness;
    
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: GlassConstants.fontSizePlaceholder,
        color: GlassConstants.mutedColor(brightness).withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(
        icon,
        size: GlassConstants.inputIconSize,
        color: isFocused
            ? GlassConstants.accent
            : GlassConstants.mutedColor(brightness).withValues(alpha: 0.7),
      ),
      prefixText: prefixText,
      prefixStyle: TextStyle(
        fontSize: GlassConstants.fontSizePlaceholder,
        color: GlassConstants.titleColor(brightness),
        fontWeight: FontWeight.w600,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: GlassConstants.inputBackgroundColor(brightness),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: GlassConstants.inputPaddingHorizontal,
        vertical: GlassConstants.inputPaddingVertical,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
        borderSide: BorderSide(
          color: GlassConstants.inputBorderColor(brightness),
          width: GlassConstants.inputBorderWidth,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
        borderSide: const BorderSide(
          color: GlassConstants.accent,
          width: GlassConstants.inputBorderWidthFocused,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
        borderSide: BorderSide(
          color: GlassConstants.errorColor(brightness),
          width: GlassConstants.inputBorderWidthFocused,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GlassConstants.radiusS),
        borderSide: BorderSide(
          color: GlassConstants.errorColor(brightness),
          width: GlassConstants.inputBorderWidthFocused,
        ),
      ),
      errorStyle: TextStyle(
        fontSize: GlassConstants.fontSizeError,
        fontWeight: GlassConstants.fontWeightError,
        color: GlassConstants.errorColor(brightness),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return GlassScaffold(
      statusBarStyle: SystemUiOverlayStyle.light,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      GlassCard(
                        radius: 28,
                        padding: const EdgeInsets.all(20),
                        child: const Icon(
                          Icons.local_fire_department_rounded,
                          color: Colors.white,
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'GAZLINK',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: GlassConstants.fontSizeTitle,
                              fontWeight: GlassConstants.fontWeightTitle,
                              color: GlassConstants.titleColor(brightness),
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Votre gaz. Notre mission.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: GlassConstants.fontSizeSubtitle,
                              color: GlassConstants.mutedColor(brightness),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: GlassConstants.spacingXXXL + 33), // 65px total
                GlassCard(
                  radius: 28,
                  padding: const EdgeInsets.all(GlassConstants.spacingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role selector
                      Text(
                        'Je suis',
                        style: TextStyle(
                          fontSize: GlassConstants.fontSizeLabel,
                          fontWeight: GlassConstants.fontWeightLabel,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingS),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'CLIENT'),
                              child: AnimatedContainer(
                                duration: GlassConstants.motionFast,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'CLIENT'
                                      ? GlassConstants.accent.withValues(alpha: 0.15)
                                      : GlassConstants.surfaceColor(brightness),
                                  borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                                  border: Border.all(
                                    color: _selectedRole == 'CLIENT'
                                        ? GlassConstants.accent
                                        : GlassConstants.borderColor(brightness),
                                    width: _selectedRole == 'CLIENT' ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: 20,
                                      color: _selectedRole == 'CLIENT'
                                          ? GlassConstants.accent
                                          : GlassConstants.mutedColor(brightness),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Client',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _selectedRole == 'CLIENT'
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: _selectedRole == 'CLIENT'
                                            ? GlassConstants.accent
                                            : GlassConstants.bodyColor(brightness),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRole = 'DELIVERER'),
                              child: AnimatedContainer(
                                duration: GlassConstants.motionFast,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'DELIVERER'
                                      ? GlassConstants.accent.withValues(alpha: 0.15)
                                      : GlassConstants.surfaceColor(brightness),
                                  borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                                  border: Border.all(
                                    color: _selectedRole == 'DELIVERER'
                                        ? GlassConstants.accent
                                        : GlassConstants.borderColor(brightness),
                                    width: _selectedRole == 'DELIVERER' ? 2 : 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.local_shipping_outlined,
                                      size: 20,
                                      color: _selectedRole == 'DELIVERER'
                                          ? GlassConstants.accent
                                          : GlassConstants.mutedColor(brightness),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Livreur',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: _selectedRole == 'DELIVERER'
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: _selectedRole == 'DELIVERER'
                                            ? GlassConstants.accent
                                            : GlassConstants.bodyColor(brightness),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Phone field
                      Text(
                        'Numéro de téléphone',
                        style: TextStyle(
                          fontSize: GlassConstants.fontSizeLabel,
                          fontWeight: GlassConstants.fontWeightLabel,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingS),
                      Focus(
                        onFocusChange: (focused) => setState(() => _phoneFocused = focused),
                        child: AnimatedContainer(
                          duration: GlassConstants.motionFast,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                            boxShadow: _phoneFocused
                                ? [
                                    BoxShadow(
                                      color: GlassConstants.accent.withValues(alpha: 0.2),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: _buildInputDecoration(
                              hintText: 'Ex: 6 90 35 12 78',
                              icon: Icons.phone_outlined,
                              isFocused: _phoneFocused,
                              prefixText: '+237  ',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le numéro de téléphone est requis';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Password field
                      Text(
                        'Mot de passe',
                        style: TextStyle(
                          fontSize: GlassConstants.fontSizeLabel,
                          fontWeight: GlassConstants.fontWeightLabel,
                          color: GlassConstants.titleColor(brightness),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingS),
                      Focus(
                        onFocusChange: (focused) => setState(() => _passwordFocused = focused),
                        child: AnimatedContainer(
                          duration: GlassConstants.motionFast,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(GlassConstants.radiusS),
                            boxShadow: _passwordFocused
                                ? [
                                    BoxShadow(
                                      color: GlassConstants.accent.withValues(alpha: 0.2),
                                      blurRadius: 12,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _buildInputDecoration(
                              hintText: 'Entrez votre mot de passe',
                              icon: Icons.lock_outline_rounded,
                              isFocused: _passwordFocused,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: GlassConstants.inputIconSize,
                                  color: _passwordFocused
                                      ? GlassConstants.accent
                                      : GlassConstants.mutedColor(brightness).withValues(alpha: 0.7),
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Le mot de passe est requis';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingXXL),
                      
                      // Login button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: GlassButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Se connecter'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      
                      // Divider
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'OU',
                              style:
                                  Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 14),
                      
                      // Signup link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.signup),
                          child: RichText(
                            text: TextSpan(
                              text: 'Pas de compte ?  ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Créer un compte',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: GlassConstants.accent,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
