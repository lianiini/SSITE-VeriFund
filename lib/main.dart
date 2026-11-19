
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://qiowgsswotoynbkyurqa.supabase.co',
      publishableKey: 'sb_publishable__Exy8dw1tpZKQJb4CB4S2g_rzLhUaDl',
    );
      debugPrint('Supabase initialized successfully.');
    } catch (error, stackTrace) {
      debugPrint('Supabase initialization failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    runApp(const MyApp());
  }


// ======================================================
// APP
// ======================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: beige,
      ),
      home: const ChoiceScreen(),
    );
  }
}

// ======================================================
// LOADING SCREEN
// ======================================================

class ChoiceScreen extends StatefulWidget {
  const ChoiceScreen({super.key});

  @override
  State<ChoiceScreen> createState() => _ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen> {

  @override
  void initState() {
    super.initState();

    // Automatically navigate to dashboard after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {

      // Check if the screen is still active
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: beige,

      body: SafeArea(
        bottom: false,

        child: LayoutBuilder(
          builder: (context, constraints) {

            return SizedBox(
              width: constraints.maxWidth,
              height: constraints.maxHeight,

              child: Stack(
                children: [

                  // ======================================
                  // BOTTOM DARK BLUE CURVE
                  // ======================================

                  Positioned(
                    top: constraints.maxHeight * 0.8,
                    left: 0,
                    right: 0,
                    bottom: 0,

                    child: ClipPath(
                      clipper: BottomCurveClipper(),

                      child: Container(
                        color: darkBlue,
                      ),
                    ),
                  ),

                  // ======================================
                  // DECORATIVE CIRCLES
                  // ======================================

                  // Top-left medium blue circle
                  Positioned(
                    top: 30,
                    left: 30,

                    child: _buildCircle(
                      size: 60,
                      color: mediumBlue,
                    ),
                  ),

                  // Small top-left pale blue circle
                  Positioned(
                    top: 85,
                    left: 15,

                    child: _buildCircle(
                      size: 30,
                      color: paleBlue,
                    ),
                  ),

                  // Upper-right medium blue circle
                  Positioned(
                    top: 50,
                    right: -30,

                    child: _buildCircle(
                      size: 96,
                      color: mediumBlue,
                    ),
                  ),

                  // Small upper-right pale blue circle
                  Positioned(
                    top: 130,
                    right: -10,

                    child: _buildCircle(
                      size: 38,
                      color: paleBlue,
                    ),
                  ),

                  // Lower-left medium blue circle
                  Positioned(
                    top: 220,
                    left: -20,

                    child: _buildCircle(
                      size: 69,
                      color: mediumBlue,
                    ),
                  ),

                  // Pale blue decorative rectangle
                  Positioned(
                    top: 205,
                    left: 90,

                    child: Container(
                      width: 250,
                      height: 35,

                      decoration: BoxDecoration(
                        color: paleBlue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  // ======================================
                  // SSITE TITLE
                  // ======================================

                  const Positioned(
                    top: 160,
                    left: 30,

                    child: Text(
                      'SSITE',

                      style: TextStyle(
                        fontFamily: 'Space',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                        letterSpacing: 9,

                        shadows: [
                          Shadow(
                            offset: Offset(3, 2),
                            color: lightBlue,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ======================================
                  // VERIFUND TITLE
                  // ======================================

                  const Positioned(
                    top: 195,
                    left: 22,

                    child: Text(
                      'VeriFund',

                      style: TextStyle(
                        fontFamily: 'Press',
                        fontSize: 40,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  // ======================================
                  // LOGOS
                  // ======================================

                  Positioned(
                    top: 155,
                    right: 25,

                    child: Row(
                      children: [

                        _buildCircleIcon(
                          Image.asset(
                            'lib/assets/MCC.png',
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildCircleIcon(
                          Image.asset(
                            'lib/assets/ICS.png',
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                          ),
                        ),

                        const SizedBox(width: 8),

                        _buildCircleIcon(
                          Image.asset(
                            'lib/assets/SSITE.png',
                            width: 38,
                            height: 38,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ======================================
                  // WELCOME TEXT
                  // ======================================

                  const Positioned(
                    top: 285,
                    left: 0,
                    right: 0,

                    child: Center(
                      child: Text(
                        'Verify SSITE Funds?',

                        style: TextStyle(
                          fontFamily: 'Pixelify',
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: darkBlue,

                          shadows: [
                            Shadow(
                              offset: Offset(2, 0),
                              color: lightBlue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ======================================
                  // LOADING INDICATOR
                  // ======================================

                  Positioned(
                    top: 360,
                    left: 0,
                    right: 0,

                    child: Column(
                      children: [

                        // Circular loading animation
                        const SizedBox(
                          width: 45,
                          height: 45,

                          child: CircularProgressIndicator(
                            strokeWidth: 4,

                            valueColor:
                            AlwaysStoppedAnimation<Color>(
                              darkBlue,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Loading text
                        const Text(
                          'Loading VeriFund...',

                          style: TextStyle(
                            fontFamily: 'Pixelify',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: darkBlue,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Loading description
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                          ),

                          child: Text(
                            'Please wait while we prepare your dashboard.',

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontFamily: 'Pixelify',
                              fontSize: 10,
                              color: darkBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ==========================================
  // DECORATIVE CIRCLE
  // ==========================================

  Widget _buildCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // ==========================================
  // LOGO CIRCLE
  // ==========================================

  Widget _buildCircleIcon(Image image) {
    return SizedBox(
      width: 42,
      height: 42,
      child: image,
    );
  }
}

// ======================================================
// BOTTOM CURVE
// ======================================================

class BottomCurveClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, size.height);
    path.lineTo(0, 115);

    path.quadraticBezierTo(
      size.width * 0.38,
      -10,
      size.width,
      35,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
