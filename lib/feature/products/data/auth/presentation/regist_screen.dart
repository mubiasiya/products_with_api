import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:with_api/feature/products/data/auth/logic/bloc/auth_bloc.dart';
import 'package:with_api/feature/products/data/auth/logic/bloc/auth_event.dart';
import 'package:with_api/feature/products/data/auth/logic/bloc/auth_state.dart';
import 'package:with_api/feature/products/data/presentation/widgets/loading_screen.dart';
import 'package:with_api/feature/products/data/presentation/widgets/scaff_msg.dart'; // Ensure AuthState is imported

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
    
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              scaff_msg(state.message.toString(), context);
            }
            if (state is AuthAuthenticated) {
              scaff_msg('Account successfully created!', context);

              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),

                    Text(
                      'Create Account',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onBackground,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Sign up to get started on your journey!',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: theme.colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color:
                              isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : const Color(0xFFE8E8ED),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              hintText: 'Enter fullname',
                              prefixIcon: Icon(
                                Icons.person_outline_rounded,
                                size: 22,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              hintText: 'name@example.com',
                              prefixIcon: Icon(
                                Icons.mail_outline_rounded,
                                size: 22,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Minimum 6 characters',
                              prefixIcon: Icon(
                                Icons.lock_outline_rounded,
                                size: 22,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.5),
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              hintText: 'Must match password',
                              prefixIcon: Icon(
                                Icons.lock_clock_outlined,
                                size: 22,
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.5),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  size: 20,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.5),
                                ),
                                onPressed:
                                    () => setState(
                                      () =>
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword,
                                    ),
                              ),
                            ),
                            onFieldSubmitted: (_) => _handleRegister(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm your password';
                              }
                              if (value != _passwordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    state is AuthLoading
                        ? Loading()
                        : ElevatedButton(
                          onPressed: _handleRegister,
                          style: theme.elevatedButtonTheme.style,
                          child: const Text('Sign Up'),
                        ),
                    const SizedBox(height: 30),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: theme.colorScheme.onBackground.withOpacity(
                                0.7,
                              ),
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
