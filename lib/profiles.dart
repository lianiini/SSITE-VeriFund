import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> officers = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOfficers();
  }

  Future<void> fetchOfficers() async {

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {

      // Fetch users with the officer role only.
      // Admin accounts are automatically excluded.

      final response = await supabase
          .from('users')
          .select()
          .eq('role', 'officer')
          .order('id', ascending: true);

      officers = List<Map<String, dynamic>>.from(response);

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

    } catch (error) {

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = error.toString();
        });
      }
    }
  }

  Widget profileImage(String? avatar) {
    const String serverUrl = 'http://10.0.2.2:8000';

    final String? imageUrl =
    avatar != null && avatar.trim().isNotEmpty
        ? '$serverUrl/storage/${avatar.trim()}'
        : null;

    return SizedBox(
      width: 106,
      height: 106,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Solid black shadow
          Positioned(
            top: 4,
            left: 4,
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),

          // Profile image
          ClipOval(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: beige,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
              ),

              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: darkBlue,
                  );
                },
              )
                  : const Icon(
                Icons.person,
                size: 50,
                color: darkBlue,
              ),
            ),
          ),

          // Black border on top
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black,
                width: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusBadge(String? status) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 5,
      ),

      decoration: BoxDecoration(
        color: beige,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        status ?? 'Unknown',

        style: const TextStyle(
          fontFamily: 'Space',
          color: darkBlue,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget positionBadge(String? position) {

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 7,
      ),

      decoration: BoxDecoration(
        color: darkBlue,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(25),
      ),

      child: Text(
        position ?? 'Officer',
        textAlign: TextAlign.center,

        style: const TextStyle(
          fontFamily: 'Space',
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ======================================================
  // OFFICER CARD
  // ======================================================

  Widget officerCard(Map<String, dynamic> officer) {

    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(bottom: 20),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: mediumBlue,

        border: Border.all(
          color: Colors.black,
          width: 4,
        ),

        borderRadius: BorderRadius.circular(22),

        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          ),
        ],
      ),

      child: Row(
        children: [

          // Officer profile picture

          profileImage(
            officer['avatar']?.toString(),
          ),

          const SizedBox(width: 5),

          // Officer information

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Approval status

                Align(
                  alignment: Alignment.centerRight,

                  child: statusBadge(
                    officer['status']?.toString(),
                  ),
                ),

                const SizedBox(height: 8),

                // Officer name

                Text(
                  officer['name'] ?? 'No Name',
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontFamily: 'Pixelify',
                    color: darkBlue,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                // Officer position

                positionBadge(
                  officer['position']?.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // BACKGROUND CIRCLES
  // ======================================================

  Widget backgroundCircle(double size, Color color) {

    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // ======================================================
  // MAIN BUILD
  // ======================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: beige,

      // ======================================================
      // BODY
      // ======================================================

      body: Stack(
        children: [

          // Decorative circles matching the dashboard background

          Positioned(
            top: -10,
            left: -30,
            child: backgroundCircle(
              110,
              paleBlue,
            ),
          ),

          Positioned(
            top: 200,
            right: -30,
            child: backgroundCircle(
              96,
              mediumBlue,
            ),
          ),

          Positioned(
            top: 280,
            right: -10,
            child: backgroundCircle(
              38,
              paleBlue,
            ),
          ),

          Positioned(
            top: 420,
            left: -20,
            child: backgroundCircle(
              69,
              mediumBlue,
            ),
          ),

          Positioned(
            top: 387,
            left: -10,
            child: backgroundCircle(
              38,
              paleBlue,
            ),
          ),

          Positioned(
            bottom: 125,
            right: 10,
            child: backgroundCircle(
              30,
              paleBlue,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),

                  child: Row(
                    children: [

                      // Back button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),

                        child: Container(
                          width: 42,
                          height: 42,

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(
                              color: Colors.black,
                              width: 2.5,
                            ),

                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),

                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: darkBlue,
                            size: 22,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      // Screen title

                      const Text(
                        'SSITE OFFICERS',

                        style: TextStyle(
                          fontFamily: 'Pixelify',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: darkBlue,
                        ),
                      ),
                    ],
                  ),
                ),

                // ======================================================
                // SCROLLABLE OFFICER LIST
                // ======================================================

                Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchOfficers,

                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),

                      padding: const EdgeInsets.fromLTRB(
                        20, 25, 20, 30,
                      ),

                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 750,
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              // Section title

                              const Text(
                                'SSITE Officers:',

                                style: TextStyle(
                                  fontFamily: 'Pixelify',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),

                              const SizedBox(height: 25),

                              // Loading state

                              if (isLoading)

                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40),

                                    child: CircularProgressIndicator(
                                      color: darkBlue,
                                    ),
                                  ),
                                )

                              // Error state

                              else if (errorMessage != null)

                                Center(
                                  child: Column(
                                    children: [

                                      const Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                        size: 45,
                                      ),

                                      const SizedBox(height: 10),

                                      Text(
                                        errorMessage!,
                                        textAlign: TextAlign.center,

                                        style: const TextStyle(
                                          color: darkBlue,
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      ElevatedButton(
                                        onPressed: fetchOfficers,
                                        child: const Text('Try Again'),
                                      ),
                                    ],
                                  ),
                                )

                              // Empty state

                              else if (officers.isEmpty)

                                  const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(30),

                                      child: Text(
                                        'No officers found.',

                                        style: TextStyle(
                                          color: darkBlue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  )

                                // Display officer cards

                                else

                                  ...officers.map(
                                        (officer) => officerCard(officer),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ======================================================
      // BOTTOM NAVIGATION BAR
      // ======================================================

      bottomNavigationBar: const BottomNavBar(
        selectedIndex: 2,
      ),
    );
  }
}
