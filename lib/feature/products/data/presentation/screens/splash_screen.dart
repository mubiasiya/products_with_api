import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

   
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.bounceOut),
    );

    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _animationController.forward();
    }

   
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        widget.isLoggedIn ? '/home' : '/login',
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
       
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFAFAFA), 
                  Color(0xFFF0F5F2), 
                  Color(0xFFE8EFEA), 
                ],
              ),
            ),
          ),

         
          Positioned(
            top: -screenSize.height * 0.15,
            right: -screenSize.width * 0.2,
            child: Container(
              width: screenSize.width * 0.8,
              height: screenSize.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(255, 147, 170, 159).withOpacity(0.04), // Whispering green glow
              ),
            ),
          ),

       
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1B4D3E).withOpacity(0.05),
                            blurRadius: 25,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo_shopping.webp',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.local_mall_rounded,
                            size: 70,
                            color: Color(
                              0xFF198754,
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                 
                    Text(
                      'BOUTIQUE',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(
                          0xFF1C2824,
                        ),
                        letterSpacing: 6.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Premium Shopping Experience',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1C2824).withOpacity(0.45),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

         
          Positioned(
            bottom: screenSize.height * 0.08,
            left: screenSize.width * 0.35,
            right: screenSize.width * 0.35,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 3.5,
                  backgroundColor: const Color.fromARGB(255, 224, 230, 227).withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 34, 35, 34),
                  ), 
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
