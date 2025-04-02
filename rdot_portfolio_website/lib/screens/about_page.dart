import 'package:flutter/material.dart';
import '../utils/responsive_layout.dart';
import '../widgets/tech_info_card.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "ABOUT",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 100,
              height: 2,
              color: Colors.cyanAccent,
            ),
            const SizedBox(height: 30),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "01",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "I'm a passionate Electrical & Computer Engineering student at the University of Texas at Austin, dedicated to creating innovative and user-friendly applications. I thrive on tackling complex challenges and turning ideas into impactful solutions.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "02",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "My journey in tech began early, leading me to found projects such as iCog and Rdot Apps. I continuously learn and apply my skills in both hardware and software, combining creativity with technical excellence.",
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ResponsiveWidget(
              mobile: Column(
                children: const [
                  TechInfoCard(
                    title: "EDUCATION",
                    content:
                        "B.S. Electrical and Computer Engineering\nUniversity of Texas at Austin, Austin, TX\n(Expected May 2027)",
                    icon: Icons.school,
                  ),
                  SizedBox(height: 20),
                  TechInfoCard(
                    title: "INTERESTS",
                    content:
                        "Embedded Systems\nApp Development\nElectronics\nIoT Devices\nHardware Design",
                    icon: Icons.lightbulb,
                  ),
                ],
              ),
              desktop: Row(
                children: const [
                  TechInfoCard(
                    title: "EDUCATION",
                    content:
                        "B.S. Electrical and Computer Engineering\nUniversity of Texas at Austin, Austin, TX\n(Expected May 2027)",
                    icon: Icons.school,
                  ),
                  SizedBox(width: 20),
                  TechInfoCard(
                    title: "INTERESTS",
                    content:
                        "Embedded Systems\nApp Development\nElectronics\nIoT Devices\nHardware Design",
                    icon: Icons.lightbulb,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
