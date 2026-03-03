import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, size: 18),
        ),
        backgroundColor: AppColors.electricTeal,
        foregroundColor: AppColors.pureWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            // TOP ILLUSTRATION
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.electricTeal.withOpacity(0.8),
                    AppColors.electricTeal.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.support_agent, color: Colors.white, size: 80),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "We're Here to Help",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "This delivery driver app is designed to make your work easier. If you face any issue with navigation, delivery updates, or login, feel free to reach out to us.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 25),

            _buildInfoCard(
              icon: Icons.local_shipping_outlined,
              title: "Delivery Assistance",
              subtitle:
                  "Help with pickup, drop-off, and delivery flow inside the app.",
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.map_outlined,
              title: "Map & Navigation",
              subtitle:
                  "Facing map issues? Location not updating? We can help you fix it.",
            ),

            const SizedBox(height: 16),

            _buildInfoCard(
              icon: Icons.person_outline,
              title: "Account Support",
              subtitle:
                  "Login, password, or profile issues? Contact our support team.",
            ),

            const SizedBox(height: 30),

            // CONTACT BOX
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.electricTeal.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Contact Us",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _contactButton(Icons.email_outlined, "Email"),
                      _contactButton(Icons.call_outlined, "Call"),
                      _contactButton(Icons.chat_bubble_outline, "Chat"),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Available Mon–Sat, 9:00 AM to 8:00 PM",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // INFO CARD
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.electricTeal.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.electricTeal.withOpacity(0.15),
            child: Icon(icon, color: AppColors.electricTeal, size: 28),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CONTACT BUTTON
  Widget _contactButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.electricTeal.withOpacity(0.15),
          child: Icon(icon, color: AppColors.electricTeal, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}
