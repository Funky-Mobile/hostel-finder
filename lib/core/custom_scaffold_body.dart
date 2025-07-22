import 'dart:ui';

import 'package:flutter/material.dart';

class CustomScaffoldBody extends StatelessWidget {
  final Widget body;
  final bool showFloatingElements;
  final String? backgroundImage;
  final bool useGlassmorphism;

  const CustomScaffoldBody({
    super.key,
    required this.body,
    this.showFloatingElements = true,
    this.backgroundImage,
    this.useGlassmorphism = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: _buildBackgroundDecoration(),
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              if (showFloatingElements) ..._buildFloatingElements(),

              // Main content area
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: useGlassmorphism
                    ? _buildGlassmorphicContent()
                    : _buildStandardContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    if (backgroundImage != null) {
      return BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage!),
          fit: BoxFit.cover,
        ),
      );
    }

    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: const [0.0, 0.3, 0.7, 1.0],
        colors: [
          const Color(0xFF1E3A8A), // Deep blue
          const Color(0xFF3B82F6), // Bright blue
          const Color(0xFF06B6D4), // Cyan
          const Color(0xFF0D9488), // Teal
        ],
      ),
    );
  }

  Widget _buildStandardContent() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: body,
    );
  }

  Widget _buildGlassmorphicContent() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.2),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ],
              ),
            ),
            child: body,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFloatingElements() {
    return [
      // Top floating element
      Positioned(
        top: -50,
        right: -30,
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.1),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Bottom left floating element
      Positioned(
        bottom: -80,
        left: -40,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                Colors.white.withValues(alpha: 0.08),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Middle right accent
      Positioned(
        top: 200,
        right: -60,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                const Color(0xFF10B981).withValues(alpha: 0.15),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ];
  }
}