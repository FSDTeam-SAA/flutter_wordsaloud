import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_wordsaloud/features/auth/controller/signup_controller.dart';
import 'package:flutter_wordsaloud/features/home/controller/home_controller.dart';
import 'package:flutter_wordsaloud/features/home/screens/category_details_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    // Get the signed-in user's first name initial for the avatar
    String userInitial = 'K';
    if (Get.isRegistered<SignupController>()) {
      final name = Get.find<SignupController>().firstName.value.trim();
      if (name.isNotEmpty) userInitial = name[0].toUpperCase();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6),
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            color: const Color(0xFFAE3F30),
            padding: const EdgeInsets.only(
                left: 18, right: 18, top: 52, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo + Avatar row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo circle
                    Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8B04B),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/images/aturservicett-logo-full-512px 2.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // User initial avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8B04B),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          userInitial,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Title
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.25,
                    ),
                    children: const [
                      TextSpan(text: 'Find a good\n'),
                      TextSpan(
                        text: 'tradesman ',
                        style: TextStyle(color: Color(0xFFEAAE4B)),
                      ),
                      TextSpan(text: 'today.'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Obx(() => TextField(
                        onChanged: (v) => controller.searchQuery.value = v,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search ...',
                          hintStyle: GoogleFonts.outfit(
                            color: const Color(0xFF9E9E9E),
                            fontSize: 15,
                          ),
                          prefixIcon: const Icon(Icons.search,
                              color: Color(0xFF9E9E9E), size: 22),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 4),
                          suffixIcon: controller.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Color(0xFF9E9E9E), size: 18),
                                  onPressed: () =>
                                      controller.searchQuery.value = '',
                                )
                              : null,
                        ),
                      )),
                ),
              ],
            ),
          ),

          // ── Categories Grid ─────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              final items = controller.filteredCategories;
              if (items.isEmpty) {
                return Center(
                  child: Text(
                    'No matches found.',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: const Color(0xFF6D6D6D),
                    ),
                  ),
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.only(left:18, top: 16, bottom: 18),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1,
                  crossAxisSpacing: .2,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final cat = items[index];
                  final bool hasRedBorder = index == 0;
                  final bool hasTealBorder = cat.isNew && index != 0;

                  Color borderColor = const Color(0xFFF3E5CF);

                  if (hasRedBorder) borderColor = const Color(0xFFA83F2D);
                  if (hasTealBorder) borderColor = const Color(0xFF22707F);

                  // Subtitle color matches the border (teal for new/teal cards, red-brown for others)
                  final Color subLabelColor =
                      hasTealBorder ? const Color(0xFF22707F) : const Color(0xFFA83F2D);

                  // Colors for the circular background of icons (matching mockup diversity)
                  final List<Color> circleColors = [
                    const Color(0xFFFDE8E8), // light red/pink
                    const Color(0xFFE3F2FD), // light blue
                    const Color(0xFFFFF9C4), // light yellow
                    const Color(0xFFE8F5E9), // light green
                    const Color(0xFFFCE4EC), // light pink
                    const Color(0xFFFFE0B2), // light orange
                  ];
                  final Color iconBgColor = circleColors[index % circleColors.length];

                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      GestureDetector(
                        onTap: () => Get.to(() => CategoryDetailsScreen(category: cat)),
                        child: Container(width: 128, height: 128,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: borderColor,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.only(
                              top: 20, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon rounded container
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: iconBgColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Image.asset(
                                    cat.image,
                                    width: 18,
                                    height: 18,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Name
                              Text(
                                cat.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  height: 1.15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Listed count
                              Text(
                                '${cat.listed} Listed',
                                style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: subLabelColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // "New" badge (shifted to top-left overlapping top border)
                      if (cat.isNew)
                        Positioned(
                          top: -10,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: index == 0
                                    ? const Color(0xFFA83F2D)
                                    : const Color(0xFF22707F),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              'New',
                              style: GoogleFonts.outfit(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: index == 0
                                      ? const Color(0xFFA83F2D)
                                      : const Color(0xFF22707F),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
