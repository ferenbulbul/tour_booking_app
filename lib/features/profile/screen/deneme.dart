import 'package:flutter/material.dart';

class StitchHomeScreen extends StatelessWidget {
  const StitchHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(
            color: Color(0xFF0D171B),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.settings, color: Color(0xFF0D171B)),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF0D171B),
        unselectedItemColor: const Color(0xFF4C809A),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favorites",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search destinations or tours",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF4C809A),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFE7EFF3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 🔘 Button
            Center(
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFE7EFF3),
                  foregroundColor: const Color(0xFF0D171B),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "View Nearby Places",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // 🌍 Featured Tours
            const SectionTitle("Featured Tours"),
            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  FeaturedCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuByokpAuiPPEiovlKiBC3Vdo8fRhSbybxt3skNJN0I7-qj0A8Wg2OCrtNsTPXW7AFH65GkQDmgKcJSGcrXSOPcV3WzEol7ZnfgY1RjF671R1E1KA301YMuRZhuqZHKp37FchIlNdJaEEwM9KehWd8kFwP8WdsBTah1cCkwQNzGOuAElLdIPtw0Lp8JgW2Iw7siYaBe81VKYvJ9Khqp92YUts2BjSWGaghs1OCmKN1HWWqBDRcQTy2rwZX1ktjfPSEnXF7s8cUh3jz8",
                    title: "Explore the Alps",
                    subtitle: "Switzerland",
                  ),
                  FeaturedCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCFvUS01P2j5w-ZSpYayxIKQs4nG9gMfez0jihlrxVu67p8HTRNXN7EG5l5A2TZ0m-VtMMairJgRl_u7V1EL8sY0YBEJHFEAsKh2Dg8fGXzVlKY1awcJbV3fBPOr19rWvZG40b4V9-VqoitX2H6QiJzoo3iKL1XGhe4uUoWfS6nLmZiJ25374rHj2-bIlGxydR9CBnsdmh39OIF471tXyelA0lyXg2V1-ya0tdUd1btcKMUcKWgRVn8WNAV80G8keW5oQYXL5PKsXM",
                    title: "Tropical Getaway",
                    subtitle: "Maldives",
                  ),
                  FeaturedCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCpJVMQ0jcKJjJxhWF8sq4_BvfCnC0LdL_qoXdo23MvntbwyE0Muk5jwcpTPLI7m3bttX06yepKd6T6h8uAwul_04HAcikqr2Y1z0OZKexwVDxA6VrGaoBx7_Te83YFQ6FTvX_nETpVbna7tPR1gvIGkigryaoPvmMm4unM5IR5Kj_Ox5MlFD9Jy98ttqiiQaaNIwhmxbdpq_ge0Zk-2xKss49BKn26DEI7g56GOygsJaNcnLOnkBIZNHcoBYpNRIEz5N5prMV6Bjg",
                    title: "Urban Adventures",
                    subtitle: "New York",
                  ),
                ],
              ),
            ),

            // 🏔 Categories
            const SectionTitle("Categories"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: const [
                  CategoryCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuCLfB4um_Da75bOX38iuVks-XXX05BSpKleo2m1lrqzviSIzKfHepqZLjei2noZPdlaYUA8v46xnq78KAzdZgWdUa04UAJabYDyNr8bbRU8viRGQw8cTgT6H0Lr9sG6G4K2E1dRun5IkuXGxLbFYuIPIr8QsUXqkY7CPXiG-LQF6ayy2WRmTPnGKewjwZKCpAHSmJ0afQ3Pc4ywuuXJDrCpJeeMyVAAiiSLfcz4CrjAKGDjjpkGGzHRqwuvW9yNuABml1lSjDyagYY",
                    title: "Adventure",
                    subtitle: "Thrilling experiences",
                  ),
                  CategoryCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuDPfGLFN3WCCNX1BtUz7__JQYynE50IpatjY67RkW7GdxVmOS_MvehdLcinXJhciGnJgFQl_9Fi5cvNO0Qk3NQKmUFgqNkWbMBy7-HkqnlBgm3KEwMHRSM3yS3cxrg2xGB4e_HuTACKdHOjaCAO68CPGUEtWaaox-vLGraFtdXxyTXzmugvBf-NMhP5vEEItwNMTLTPNE09-EWSjdl68sv5yLIGulW34ZrwYF6AhoRYT2P8Byx7LKR_MIhwTXbXNmB5gt41Wq_EgN0",
                    title: "Relaxation",
                    subtitle: "Unwind and recharge",
                  ),
                  CategoryCard(
                    imageUrl:
                        "https://lh3.googleusercontent.com/aida-public/AB6AXuBwaX_2Omr_aLl5Zw5Wq3UKvw2-FeD0-iocW1GDACPeSFS0DQm8-JBKCsBbrYl5nRQF1xNJScWVNKmQy9AmYeE1ol1WJgLAqKXcXBbTWEx63OnI_esmuyV2bjbRpVW-kO2HY8YO0coje2w8v7Zx2dr_mZw2C9li-zogAR8rvXO9kiRW2twZQUWW6_es2ck0clCwi6tCoZGKMLuv53zKgHo6oYXHvuxpJ6epno_tby-0pcoIgkR2RN-GXfkjFRy3ZClkpTphTt5JHmQ",
                    title: "Culture",
                    subtitle: "Discover local heritage",
                  ),
                ],
              ),
            ),

            // 🧭 Why TourBooking
            const SectionTitle("Why TourBooking"),
            const WhyItem(
              icon: Icons.star_rounded,
              title: "Quality",
              subtitle: "Expertly curated tours",
            ),
            const WhyItem(
              icon: Icons.headset_mic_rounded,
              title: "Support",
              subtitle: "24/7 support",
            ),
            const WhyItem(
              icon: Icons.attach_money_rounded,
              title: "Value",
              subtitle: "Best price guarantee",
            ),
            const WhyItem(
              icon: Icons.security_rounded,
              title: "Safety",
              subtitle: "Secure and reliable",
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Components

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0D171B),
      ),
    ),
  );
}

class FeaturedCard extends StatelessWidget {
  final String imageUrl, title, subtitle;
  const FeaturedCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: 180,
    margin: const EdgeInsets.only(right: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(subtitle, style: const TextStyle(color: Color(0xFF4C809A))),
      ],
    ),
  );
}

class CategoryCard extends StatelessWidget {
  final String imageUrl, title, subtitle;
  const CategoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(imageUrl, fit: BoxFit.cover),
      ),
      const SizedBox(height: 8),
      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      Text(subtitle, style: const TextStyle(color: Color(0xFF4C809A))),
    ],
  );
}

class WhyItem extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const WhyItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE7EFF3),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Icon(icon, color: const Color(0xFF0D171B)),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF4C809A))),
  );
}
