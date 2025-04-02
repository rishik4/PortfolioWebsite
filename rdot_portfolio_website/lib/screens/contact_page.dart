import 'package:flutter/material.dart';
import '../utils/url_launcher_utils.dart';
import '../utils/responsive_layout.dart';
import '../widgets/tech_contact_button.dart';
import '../widgets/tech_contact_form.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "CONTACT",
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
            const SizedBox(height: 40), // Increased spacing
            const Text(
              "I'm always open to new opportunities and collaborations. Feel free to reach out to me if you want to work together or just want to say hi!",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 1,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 60), // Increased spacing
            ResponsiveWidget(
              mobile: Wrap(
                spacing: 20, // Increased spacing
                runSpacing: 20, // Increased spacing
                alignment: WrapAlignment.center,
                children: [
                  TechContactButton(
                    icon: Icons.email,
                    label: "EMAIL",
                    onTap: () => launchUrlExternal('mailto:rishikb@utexas.edu'),
                  ),
                  TechContactButton(
                    icon: Icons.code,
                    label: "GITHUB",
                    onTap: () =>
                        launchUrlExternal('https://github.com/rishik4'),
                  ),
                  TechContactButton(
                    icon: Icons.link,
                    label: "LINKEDIN",
                    onTap: () => launchUrlExternal(
                        'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                  ),
                  TechContactButton(
                    icon: Icons.article,
                    label: "RESUME",
                    onTap: () => launchUrlExternal(
                        'https://drive.google.com/file/d/1EOm_7cDInpJut7-bUdAPiLElzXW3wrZF/view?usp=sharing'),
                  ),
                ],
              ),
              desktop: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TechContactButton(
                    icon: Icons.email,
                    label: "EMAIL",
                    onTap: () => launchUrlExternal('mailto:rishikb@utexas.edu'),
                  ),
                  TechContactButton(
                    icon: Icons.code,
                    label: "GITHUB",
                    onTap: () =>
                        launchUrlExternal('https://github.com/rishik4'),
                  ),
                  TechContactButton(
                    icon: Icons.link,
                    label: "LINKEDIN",
                    onTap: () => launchUrlExternal(
                        'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                  ),
                  TechContactButton(
                    icon: Icons.article,
                    label: "RESUME",
                    onTap: () => launchUrlExternal(
                        'https://drive.google.com/file/d/1EOm_7cDInpJut7-bUdAPiLElzXW3wrZF/view?usp=sharing'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Increased spacing
            const TechContactForm(),
            const SizedBox(height: 60), // Added bottom padding
          ],
        ),
      ),
    );
  }
}
