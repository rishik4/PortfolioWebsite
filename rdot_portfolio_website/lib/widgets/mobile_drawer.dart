import 'package:flutter/material.dart';
import '../utils/url_launcher_utils.dart';
import '../widgets/glitch_text.dart';

class MobileDrawer extends StatelessWidget {
  final List<String> sectionTitles;
  final int currentSection;
  final Function(int) onSectionSelected;
  final bool showGlitch;

  const MobileDrawer({
    super.key,
    required this.sectionTitles,
    required this.currentSection,
    required this.onSectionSelected,
    this.showGlitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border(
                  bottom: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
              ),
              child: Column(
                children: [
                  GlitchText(
                    text: 'RDOT',
                    glitchEnabled: showGlitch,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.email, color: Colors.cyanAccent),
                        onPressed: () =>
                            launchUrlExternal('mailto:rishikb@utexas.edu'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.code, color: Colors.cyanAccent),
                        onPressed: () =>
                            launchUrlExternal('https://github.com/rishik4'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.link, color: Colors.cyanAccent),
                        onPressed: () => launchUrlExternal(
                            'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: sectionTitles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      sectionTitles[index],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: currentSection == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                        letterSpacing: 2,
                        color: currentSection == index
                            ? Colors.cyanAccent
                            : Colors.cyanAccent.withOpacity(0.7),
                      ),
                    ),
                    leading: Icon(
                      _getIconForSection(index),
                      color: currentSection == index
                          ? Colors.cyanAccent
                          : Colors.cyanAccent.withOpacity(0.7),
                    ),
                    selected: currentSection == index,
                    selectedTileColor: Colors.cyanAccent.withOpacity(0.1),
                    onTap: () {
                      onSectionSelected(index);
                      Navigator.pop(context); // Close drawer after selection
                    },
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.copyright, color: Colors.cyanAccent, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "2024 RISHIK BODDETI",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.cyanAccent,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSection(int index) {
    switch (index) {
      case 0:
        return Icons.home;
      case 1:
        return Icons.person;
      case 2:
        return Icons.code;
      case 3:
        return Icons.work;
      case 4:
        return Icons.engineering;
      case 5:
        return Icons.email;
      default:
        return Icons.circle;
    }
  }
}
