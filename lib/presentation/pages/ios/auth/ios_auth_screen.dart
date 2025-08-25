import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/ios18_theme.dart';
import '../../../../services/auth_service.dart';
import '../../../../core/utils/helpers.dart';

class IOSAuthScreen extends StatefulWidget {
  const IOSAuthScreen({super.key});
  
  @override
  State<IOSAuthScreen> createState() => _IOSAuthScreenState();
}

class _IOSAuthScreenState extends State<IOSAuthScreen> {
  final AuthService _authService = Get.find<AuthService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  
  bool _isSignUp = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: iOS18Theme.background,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              _buildHeader(),
              const SizedBox(height: 48),
              _buildForm(),
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 16),
              _buildToggleButton(),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iOS18Theme.accentBlue,
                iOS18Theme.accentPurple,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(
            CupertinoIcons.chart_bar_square_fill,
            size: 40,
            color: CupertinoColors.white,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _isSignUp ? 'Create Account' : 'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: iOS18Theme.primaryLabel,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _isSignUp 
              ? 'Sign up to start analyzing markets'
              : 'Sign in to continue',
          style: TextStyle(
            fontSize: 16,
            color: iOS18Theme.secondaryLabel,
          ),
        ),
      ],
    );
  }
  
  Widget _buildForm() {
    return Column(
      children: [
        if (_isSignUp) ...[
          CupertinoTextField(
            controller: _nameController,
            placeholder: 'Full Name',
            prefix: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Icon(
                CupertinoIcons.person,
                color: iOS18Theme.secondaryLabel,
                size: 20,
              ),
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iOS18Theme.secondaryFill,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: iOS18Theme.separator,
                width: 0.5,
              ),
            ),
            style: TextStyle(
              color: iOS18Theme.primaryLabel,
              fontSize: 16,
            ),
            placeholderStyle: TextStyle(
              color: iOS18Theme.tertiaryLabel,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
        ],
        CupertinoTextField(
          controller: _emailController,
          placeholder: 'Email',
          keyboardType: TextInputType.emailAddress,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              CupertinoIcons.mail,
              color: iOS18Theme.secondaryLabel,
              size: 20,
            ),
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: iOS18Theme.secondaryFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: iOS18Theme.separator,
              width: 0.5,
            ),
          ),
          style: TextStyle(
            color: iOS18Theme.primaryLabel,
            fontSize: 16,
          ),
          placeholderStyle: TextStyle(
            color: iOS18Theme.tertiaryLabel,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        CupertinoTextField(
          controller: _passwordController,
          placeholder: 'Password',
          obscureText: _obscurePassword,
          prefix: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Icon(
              CupertinoIcons.lock,
              color: iOS18Theme.secondaryLabel,
              size: 20,
            ),
          ),
          suffix: CupertinoButton(
            padding: const EdgeInsets.only(right: 8),
            child: Icon(
              _obscurePassword
                  ? CupertinoIcons.eye
                  : CupertinoIcons.eye_slash,
              color: iOS18Theme.secondaryLabel,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: iOS18Theme.secondaryFill,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: iOS18Theme.separator,
              width: 0.5,
            ),
          ),
          style: TextStyle(
            color: iOS18Theme.primaryLabel,
            fontSize: 16,
          ),
          placeholderStyle: TextStyle(
            color: iOS18Theme.tertiaryLabel,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSubmitButton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              iOS18Theme.accentBlue,
              iOS18Theme.accentPurple,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: _isLoading
              ? const CupertinoActivityIndicator(
                  color: CupertinoColors.white,
                )
              : Text(
                  _isSignUp ? 'Sign Up' : 'Sign In',
                  style: const TextStyle(
                    color: CupertinoColors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
      onPressed: _isLoading ? null : _handleSubmit,
    );
  }
  
  Widget _buildToggleButton() {
    return CupertinoButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _isSignUp
                ? 'Already have an account? '
                : 'Don\'t have an account? ',
            style: TextStyle(
              color: iOS18Theme.secondaryLabel,
              fontSize: 15,
            ),
          ),
          Text(
            _isSignUp ? 'Sign In' : 'Sign Up',
            style: TextStyle(
              color: iOS18Theme.accentBlue,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      onPressed: () {
        iOS18Theme.selectionClick();
        setState(() {
          _isSignUp = !_isSignUp;
        });
      },
    );
  }
  
  Future<void> _handleSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    
    if (email.isEmpty || password.isEmpty) {
      showToast('Please fill in all fields', isError: true);
      return;
    }
    
    if (_isSignUp && name.isEmpty) {
      showToast('Please enter your name', isError: true);
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    bool success;
    if (_isSignUp) {
      success = await _authService.signUp(email, password, name);
    } else {
      success = await _authService.signIn(email, password);
    }
    
    setState(() {
      _isLoading = false;
    });
    
    if (success) {
      Get.offAllNamed('/main');
    } else {
      showToast(
        _isSignUp 
            ? 'Failed to create account. Please try again.'
            : 'Invalid email or password',
        isError: true,
      );
    }
  }
}