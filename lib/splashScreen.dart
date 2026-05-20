import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Timer _progressTimer;
  int _progress = 0;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: 0.95,
      upperBound: 1.05,
    )..repeat(reverse: true);

    _progressTimer = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (!mounted) return;
      setState(() {
        _progress = (_progress + 4).clamp(0, 100);
      });
      if (_progress >= 100) {
        timer.cancel();
        // Do not auto-navigate when loading completes; require user tap to continue.
      }
    });
  }

  void _goToHome() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _goToHome,
      child: Scaffold(
        backgroundColor: const Color(0xFF001A2E),
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-0.9, -0.8),
                    radius: 1.6,
                    colors: [Color(0xFF071233), Color(0xFF001A2E)],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -80,
              left: -60,
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0x2E0077CC),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0x2E004E92),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/BonfigliolilogoWhite.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stack) => Image.asset(
                                'assets/images/inline.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bonfiglioli ',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 14,
                                  letterSpacing: 1.8,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Smart AR Viewer',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ScaleTransition(
                              scale: _pulseController,
                              child: Container(
                                width: 210,
                                height: 210,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF0077CC),
                                      Color(0xFF004E92),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x3D0077CC),
                                      blurRadius: 42,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    width: 156,
                                    height: 156,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF071233),
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: Colors.white12,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(18),
                                      child: Image.asset(
                                        'assets/images/BonfigliolilogoWhite.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stack) =>
                                            Image.asset(
                                          'assets/images/inline.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 26),
                            Text(
                              'Reimagining industrial controls with precision AR and premium visual systems.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FlutterLogo(
                                  size: 32,
                                  style: FlutterLogoStyle.markOnly,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Powered by Flutter',
                                  style: GoogleFonts.inter(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x0DFFFFFF),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0x14FFFFFF),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: LinearProgressIndicator(
                              value: _progress / 100,
                              minHeight: 8,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF0077CC),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'LOADING PLATFORM',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  letterSpacing: 1.8,
                                ),
                              ),
                              Text(
                                '$_progress%',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Tap anywhere to continue',
                            style: GoogleFonts.inter(
                              color: Colors.white38,
                              fontSize: 11,
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
          ],
        ),
      ),
    );
  }
}
