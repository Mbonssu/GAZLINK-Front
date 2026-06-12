import 'package:flutter/material.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';
import '../../routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _acceptTerms = false;
  
  // Focus states
  bool _nameFocused = false;
  bool _phoneFocused = false;
  bool _emailFocused = false;
  bool _passwordFocused = false;
  bool _confirmPasswordFocused = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }
    if (!RegExp(r'^6\d{8}$').hasMatch(value.replaceAll(' ', ''))) {
      return 'Format invalide (ex: 6 90 35 12 78)';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email invalide';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 8) {
      return 'Minimum 8 caractères';
    }
    if (!RegExp(r'[A-Za-z]').hasMatch(value) || !RegExp(r'[0-9]').hasMatch(value)) {
      return 'Doit contenir lettres et chiffres';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez accepter les conditions d\'utilisation')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Les mots de passe ne correspondent pas')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      Navigator.of(context).pushNamed(AppRoutes.otpVerification, arguments: {
        'phone': _phoneController.text,
        'name': _nameController.text,
        'email': _emailController.text,
        'purpose': 'signup',
      });
      setState(() => _isLoading = false);
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
      errorMaxLines: 2,
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required bool isFocused,
    required Function(bool) onFocusChange,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    String? prefixText,
  }) {
    final brightness = Theme.of(context).brightness;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: GlassConstants.fontSizeLabel,
            fontWeight: GlassConstants.fontWeightLabel,
            color: GlassConstants.titleColor(brightness),
          ),
        ),
        const SizedBox(height: GlassConstants.spacingS),
        Focus(
          onFocusChange: onFocusChange,
          child: AnimatedContainer(
            duration: GlassConstants.motionFast,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(GlassConstants.radiusS),
              boxShadow: isFocused
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
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              validator: validator,
              decoration: _buildInputDecoration(
                hintText: hintText ?? '',
                icon: icon,
                isFocused: isFocused,
                suffixIcon: suffixIcon,
                prefixText: prefixText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Créer un compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Rejoignez GAZLINK',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: GlassConstants.fontSizeTitle,
                        fontWeight: GlassConstants.fontWeightTitle,
                        color: GlassConstants.titleColor(brightness),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Créez votre compte pour commander du gaz en toute simplicité',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: GlassConstants.fontSizeSubtitle,
                        color: GlassConstants.mutedColor(brightness),
                      ),
                ),
                const SizedBox(height: GlassConstants.spacingXXXL),
                GlassCard(
                  radius: 28,
                  padding: const EdgeInsets.all(GlassConstants.spacingXL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name field
                      _buildFormField(
                        label: 'Nom complet',
                        controller: _nameController,
                        icon: Icons.person_outline,
                        isFocused: _nameFocused,
                        onFocusChange: (focused) => setState(() => _nameFocused = focused),
                        hintText: 'Ex: Jean Dupont',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Le nom est requis';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Phone field
                      _buildFormField(
                        label: 'Numéro de téléphone',
                        controller: _phoneController,
                        icon: Icons.phone_outlined,
                        isFocused: _phoneFocused,
                        onFocusChange: (focused) => setState(() => _phoneFocused = focused),
                        keyboardType: TextInputType.phone,
                        hintText: 'Ex: 6 90 35 12 78',
                        prefixText: '+237  ',
                        validator: _validatePhone,
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Email field
                      _buildFormField(
                        label: 'Email',
                        controller: _emailController,
                        icon: Icons.email_outlined,
                        isFocused: _emailFocused,
                        onFocusChange: (focused) => setState(() => _emailFocused = focused),
                        keyboardType: TextInputType.emailAddress,
                        hintText: 'Ex: jean.dupont@email.com',
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Password field
                      _buildFormField(
                        label: 'Mot de passe',
                        controller: _passwordController,
                        icon: Icons.lock_outline_rounded,
                        isFocused: _passwordFocused,
                        onFocusChange: (focused) => setState(() => _passwordFocused = focused),
                        obscureText: _obscurePassword,
                        hintText: 'Minimum 8 caractères',
                        validator: _validatePassword,
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
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Confirm password field
                      _buildFormField(
                        label: 'Confirmer le mot de passe',
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline_rounded,
                        isFocused: _confirmPasswordFocused,
                        onFocusChange: (focused) => setState(() => _confirmPasswordFocused = focused),
                        obscureText: _obscureConfirmPassword,
                        hintText: 'Confirmez votre mot de passe',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez confirmer le mot de passe';
                          }
                          if (value != _passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: GlassConstants.inputIconSize,
                            color: _confirmPasswordFocused
                                ? GlassConstants.accent
                                : GlassConstants.mutedColor(brightness).withValues(alpha: 0.7),
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      const SizedBox(height: GlassConstants.spacingL),
                      
                      // Terms checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                            activeColor: GlassConstants.accent,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => GlassCard(
                                      radius: 28,
                                      margin: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.description_outlined),
                                            title: const Text('Conditions d\'utilisation'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).pushNamed(AppRoutes.terms);
                                            },
                                          ),
                                          const Divider(height: 1),
                                          ListTile(
                                            leading: const Icon(Icons.privacy_tip_outlined),
                                            title: const Text('Politique de confidentialité'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.of(context).pushNamed(AppRoutes.privacyPolicy);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'J\'accepte les ',
                                    style: Theme.of(context).textTheme.bodySmall,
                                    children: [
                                      TextSpan(
                                        text: 'Conditions d\'utilisation',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: GlassConstants.accent,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const TextSpan(text: ' et la '),
                                      TextSpan(
                                        text: 'Politique de confidentialité',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: GlassConstants.accent,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      
                      // Signup button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: GlassButton(
                          onPressed: _isLoading ? null : _handleSignup,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Créer mon compte'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      
                      // Login link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: RichText(
                            text: TextSpan(
                              text: 'Déjà un compte ?  ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'Se connecter',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
