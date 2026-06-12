import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/glass/glass_components.dart';
import '../../theme/glass/glass_constants.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String purpose;

  const OtpVerificationScreen({
    Key? key,
    required this.phone,
    this.purpose = 'verification',
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );
  bool _isLoading = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startCountdown();
      } else if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    
    // Check if all fields are filled
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      _verifyOtp();
    }
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _controllers[index].clear();
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Get arguments to determine flow
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final type = args?['type'] as String?;

      if (type == 'password_reset') {
        // Navigate to reset password screen
        Navigator.of(context).pushReplacementNamed('/reset-password');
      } else {
        // Navigate to role selection or home
        Navigator.of(context).pushReplacementNamed('/role-selection');
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });
    _startCountdown();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Code renvoyé avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final phone = args?['phone'] as String? ?? '';

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text('Vérification'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              
              // Icon
              GlassCard(
                radius: 40,
                padding: const EdgeInsets.all(24),
                color: GlassConstants.accent.withValues(alpha: 0.15),
                child: Icon(
                  Icons.sms_outlined,
                  size: 60,
                  color: GlassConstants.accent,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Vérification du code',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: GlassConstants.titleColor(Theme.of(context).brightness),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Description
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Nous avons envoyé un code à 6 chiffres au\n',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GlassConstants.mutedColor(Theme.of(context).brightness),
                      ),
                  children: [
                    TextSpan(
                      text: '+237 $phone',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: GlassConstants.titleColor(Theme.of(context).brightness),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              
              // OTP Input
              GlassCard(
                radius: 28,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                            decoration: InputDecoration(
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: GlassConstants.borderColor(Theme.of(context).brightness),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: GlassConstants.accent,
                                  width: 2,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onCodeChanged(index, value),
                            onTap: () {
                              if (_controllers[index].text.isNotEmpty) {
                                _controllers[index].clear();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    // Resend code
                    if (_canResend)
                      TextButton(
                        onPressed: _resendCode,
                        child: Text(
                          'Renvoyer le code',
                          style: TextStyle(
                            color: GlassConstants.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Renvoyer le code dans $_resendCountdown s',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: GlassConstants.mutedColor(Theme.of(context).brightness),
                            ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Verify button
              if (_isLoading)
                const CircularProgressIndicator()
              else
                SizedBox(
                  width: double.infinity,
                  child: GlassButton(
                    onPressed: _verifyOtp,
                    child: const Text('Vérifier'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
