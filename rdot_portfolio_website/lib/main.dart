import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RDOT Portfolio',
      debugShowCheckedModeBanner: false,
      // Added smooth scrolling behavior here:
      scrollBehavior: const SmoothScrollBehavior(),
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Color(0xFF666666),
          background: Colors.black,
          surface: Color(0xFF1A1A1A),
        ),
        textTheme: GoogleFonts.spaceMonoTextTheme().copyWith(
          bodyLarge: const TextStyle(
            letterSpacing: 0.5,
            height: 1.2,
            color: Colors.cyanAccent,
          ),
        ),
        useMaterial3: true,
      ),
      home: const PortfolioHome(),
    );
  }
}

// Custom scroll behavior to enable smooth scrolling on web and desktop
class SmoothScrollBehavior extends MaterialScrollBehavior {
  const SmoothScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with TickerProviderStateMixin {
  late AnimationController _terminalController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _backgroundAnimationController;
  late AnimationController _glitchController;
  final ScrollController _scrollController = ScrollController();
  int _currentSection = 0;
  bool _showGlitch = false;
  bool _showMainContent = false;

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  final List<String> _sectionTitles = [
    'HOME',
    'ABOUT',
    'PROJECTS',
    'EXPERIENCES',
    'SKILLS',
    'CONTACT'
  ];

  final List<GlobalKey> _sectionKeys = List.generate(6, (_) => GlobalKey());

  @override
  void initState() {
    super.initState();

    _terminalController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward().then((_) {
        setState(() {
          _showMainContent = true;
        });
        _fadeController.forward();
      });

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _backgroundAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _triggerRandomGlitch();
    });

    _scrollController.addListener(_updateCurrentSection);
  }

  void _triggerRandomGlitch() {
    if (!mounted) return;

    Future.delayed(Duration(milliseconds: math.Random().nextInt(5000) + 1000),
        () {
      if (!mounted) return;

      setState(() {
        _showGlitch = true;
      });

      _glitchController.forward(from: 0).then((_) {
        if (!mounted) return;
        setState(() {
          _showGlitch = false;
        });
        _triggerRandomGlitch();
      });
    });
  }

  void _updateCurrentSection() {
    double offset = _scrollController.offset;
    for (int i = 0; i < _sectionKeys.length; i++) {
      final context = _sectionKeys[i].currentContext;
      if (context != null) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final position = box.localToGlobal(Offset.zero);
        if (position.dy <= 100 && position.dy + box.size.height > 0) {
          if (_currentSection != i) {
            setState(() {
              _currentSection = i;
            });
          }
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _terminalController.dispose();
    _fadeController.dispose();
    _backgroundAnimationController.dispose();
    _glitchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundAnimationController,
            builder: (context, child) {
              return CustomPaint(
                painter:
                    TechBackgroundPainter(_backgroundAnimationController.value),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://i.imgur.com/vzePCxZ.png'),
                    repeat: ImageRepeat.repeat,
                    fit: BoxFit.none,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _terminalController,
              builder: (context, child) {
                return Opacity(
                  opacity: _terminalController.value < 0.8
                      ? 1.0
                      : 1.0 - (_terminalController.value - 0.8) * 5,
                  child: const Terminal(
                    prompt: '~/user >',
                    command: 'load user.profile',
                    response: 'Profile loaded successfully',
                  ),
                );
              },
            ),
          ),
          if (_showMainContent)
            FadeTransition(
              opacity: _fadeAnimation,
              child: Row(
                children: [
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                      border: Border(
                          right: BorderSide(
                              color: Colors.cyanAccent.withOpacity(0.3))),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              GlitchText(
                                text: 'RDOT',
                                style: GoogleFonts.spaceMono(
                                  textStyle: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.cyanAccent,
                                  ),
                                ),
                                glitchEnabled: _showGlitch,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.email,
                                        color: Colors.cyanAccent),
                                    onPressed: () =>
                                        _launchUrl('mailto:rishikb@utexas.edu'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.code,
                                        color: Colors.cyanAccent),
                                    onPressed: () => _launchUrl(
                                        'https://github.com/rishik4'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.link,
                                        color: Colors.cyanAccent),
                                    onPressed: () => _launchUrl(
                                        'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _sectionTitles.length,
                              (index) => NavButton(
                                title: _sectionTitles[index],
                                isSelected: _currentSection == index,
                                onTap: () {
                                  final context =
                                      _sectionKeys[index].currentContext;
                                  if (context != null) {
                                    Scrollable.ensureVisible(
                                      context,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(
                        decelerationRate: ScrollDecelerationRate.fast,
                      ),
                      child: Column(
                        children: [
                          Container(
                            key: _sectionKeys[0],
                            height: MediaQuery.of(context).size.height,
                            child: HomePage(showGlitch: _showGlitch),
                          ),
                          const SizedBox(height: 150),
                          Container(
                            key: _sectionKeys[1],
                            height: MediaQuery.of(context).size.height,
                            child: const AboutPage(),
                          ),
                          const SizedBox(height: 150),
                          Container(
                            key: _sectionKeys[2],
                            height: MediaQuery.of(context).size.height,
                            child: const ProjectsPage(),
                          ),
                          const SizedBox(height: 150),
                          Container(
                            key: _sectionKeys[3],
                            height: MediaQuery.of(context).size.height + 200,
                            child: const ExperiencesPage(),
                          ),
                          const SizedBox(height: 150),
                          Container(
                            key: _sectionKeys[4],
                            height: MediaQuery.of(context).size.height,
                            child: const SkillsPage(),
                          ),
                          const SizedBox(height: 150),
                          Container(
                            key: _sectionKeys[5],
                            height: MediaQuery.of(context).size.height,
                            child: const ContactPage(),
                          ),
                          const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (_showGlitch)
            Positioned.fill(
              child: AnimatedBuilder(
                  animation: _glitchController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: GlitchPainter(_glitchController.value),
                      size: Size.infinite,
                    );
                  }),
            ),
        ],
      ),
    );
  }
}

class GlitchText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final bool glitchEnabled;

  const GlitchText({
    super.key,
    required this.text,
    this.style,
    this.glitchEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!glitchEnabled) {
      return Text(text, style: style);
    }

    return Stack(
      children: [
        Opacity(
          opacity: 0.8,
          child: Transform.translate(
            offset: const Offset(2, 0),
            child: Text(
              text,
              style: style?.copyWith(
                color: Colors.redAccent.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.8,
          child: Transform.translate(
            offset: const Offset(-2, 0),
            child: Text(
              text,
              style: style?.copyWith(
                color: Colors.blueAccent.withOpacity(0.5),
              ),
            ),
          ),
        ),
        Text(text, style: style),
      ],
    );
  }
}

class GlitchPainter extends CustomPainter {
  final double animationValue;
  final math.Random random = math.Random();

  GlitchPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final int glitchCount = (10 * animationValue).ceil();

    for (int i = 0; i < glitchCount; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double width = random.nextDouble() * 100 + 50;
      final double height = random.nextDouble() * 10 + 5;

      final Paint paint = Paint()
        ..color = Colors.cyanAccent.withOpacity(random.nextDouble() * 0.2);

      canvas.drawRect(
        Rect.fromLTWH(x, y, width, height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TechBackgroundPainter extends CustomPainter {
  final double animationValue;

  TechBackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.05)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final spacing = 30.0;
    final hCount = (size.height / spacing).ceil();
    final wCount = (size.width / spacing).ceil();

    for (int i = 0; i < hCount; i++) {
      final y = i * spacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    for (int i = 0; i < wCount; i++) {
      final x = i * spacing;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    final particlePaint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 1.0;

    final particleCount = 50;
    for (int i = 0; i < particleCount; i++) {
      final offset = animationValue * math.pi * 2;
      final phase = i / particleCount * math.pi * 2;
      final x = (i % wCount) * spacing + math.sin(phase + offset) * 10;
      final y =
          (i ~/ wCount % hCount) * spacing + math.cos(phase + offset) * 10;

      final size = 1.0 + math.sin(phase + offset).abs() * 1.5;
      canvas.drawCircle(Offset(x, y), size, particlePaint);
    }

    final textStyle = TextStyle(
      color: Colors.cyanAccent.withOpacity(0.1),
      fontSize: 12,
    );

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final random = math.Random(animationValue.toInt() * 1000);
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;

      String binaryText = '';
      for (int j = 0; j < 8; j++) {
        binaryText += random.nextBool() ? '1' : '0';
      }

      textPainter.text = TextSpan(
        text: binaryText,
        style: textStyle,
      );

      textPainter.layout();
      textPainter.paint(canvas, Offset(x, y));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class NavButton extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: widget.isSelected
                    ? Colors.cyanAccent
                    : _isHovering
                        ? Colors.cyanAccent.withOpacity(0.5)
                        : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.normal,
              letterSpacing: 2,
              color: widget.isSelected || _isHovering
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class Terminal extends StatelessWidget {
  final String prompt;
  final String command;
  final String response;

  const Terminal({
    super.key,
    required this.prompt,
    required this.command,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText(
            '$prompt $command',
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.cyanAccent,
            ),
            speed: const Duration(milliseconds: 100),
          ),
          TypewriterAnimatedText(
            '$prompt $command\n$response',
            textStyle: const TextStyle(
              fontSize: 14,
              color: Colors.cyanAccent,
            ),
            speed: const Duration(milliseconds: 50),
          ),
        ],
        totalRepeatCount: 1,
        pause: const Duration(milliseconds: 500),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final bool showGlitch;

  const HomePage({
    super.key,
    this.showGlitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "HELLO WORLD",
              style: TextStyle(
                fontSize: 16,
                color: Colors.cyanAccent.withOpacity(0.7),
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 15),
            GlitchText(
              text: "RISHIK BODDETI",
              glitchEnabled: showGlitch,
              style: const TextStyle(
                fontSize: 60,
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
            SizedBox(
              width: 600,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    '01010011 01001111 01000110 01010100 01010111 01000001 01010010 01000101 \n01000100 01000101 01010110 01000101 01001100 01001111 01010000 01000101 01010010',
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      fontFamily: 'monospace',
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                  TypewriterAnimatedText(
                    'ELECTRICAL & COMPUTER ENGINEERING STUDENT | APP DEVELOPER | INNOVATOR',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.cyanAccent,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 2000),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
            const SizedBox(height: 50),
            TechButton(
              onPressed: () {
                final targetContext = context
                    .findAncestorStateOfType<_PortfolioHomeState>()
                    ?._sectionKeys[3]
                    .currentContext;
                if (targetContext != null) {
                  Scrollable.ensureVisible(
                    targetContext,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOutCubic,
                  );
                }
              },
              label: "VIEW PROJECTS",
            ),
          ],
        ),
      ),
    );
  }
}

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
            const Row(
              children: [
                TechInfoCard(
                  title: "EDUCATION",
                  content:
                      "B.S. Electrical and Computer Engineering\nUniversity of Texas at Austin, Austin, TX\n(Expected May 2027)",
                  icon: Icons.school,
                ),
                const SizedBox(width: 20),
                TechInfoCard(
                  title: "EXPERIENCES",
                  content:
                      "Creator of award-winning projects including the iCog Dementia Screening App, innovative Passion Projects, and founder of Rdot Apps. Recognized in national competitions and featured in news.",
                  icon: Icons.work,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TechInfoCard extends StatefulWidget {
  final String title;
  final String content;
  final IconData icon;

  const TechInfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  State<TechInfoCard> createState() => _TechInfoCardState();
}

class _TechInfoCardState extends State<TechInfoCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        width: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(
            color: _isHovering
                ? Colors.cyanAccent
                : Colors.cyanAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.icon, color: Colors.cyanAccent, size: 20),
                const SizedBox(width: 10),
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: Colors.cyanAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: 30,
              height: 1,
              color: Colors.cyanAccent.withOpacity(0.5),
            ),
            const SizedBox(height: 15),
            Text(
              widget.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.cyanAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final Widget content;

  const DetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return CustomPaint(
                painter: TechBackgroundPainter(0),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.cyanAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  content,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExperienceDetailContent extends StatelessWidget {
  final Map<String, dynamic> experience;

  const ExperienceDetailContent({
    super.key,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.work, color: Colors.cyanAccent, size: 24),
              const SizedBox(width: 15),
              Text(
                experience['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            experience['organization'],
            style: TextStyle(
              fontSize: 20,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            experience['duration'],
            style: TextStyle(
              fontSize: 16,
              color: Colors.cyanAccent.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 30),
          ...experience['responsibilities'].map<Widget>((responsibility) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "•",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      responsibility,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (experience['technologies'] != null) ...[
            const SizedBox(height: 30),
            const Text(
              "Technologies Used",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children:
                  (experience['technologies'] as List<String>).map((tech) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                  ),
                  child: Text(
                    tech,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.cyanAccent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class ExperiencesPage extends StatelessWidget {
  const ExperiencesPage({super.key});

  static final List<Map<String, dynamic>> experiences = [
    {
      'title': 'Hardware-Software Integration Engineer',
      'organization': 'Longhorn Neurotech',
      'duration': 'Aug 2024 – Present',
      'responsibilities': [
        'Developed wireless communication protocols (Wi-Fi, BLE, Radio) to integrate EEG and EMG signals with ESP32 microcontrollers for controlling a robotic rover',
        'Implemented UDP communication to ensure real-time command transmission with minimal latency',
        'Collaborated across interdisciplinary teams (EEG/EMG, Electrical, Mechanical) to design, build, and troubleshoot the rover, addressing technical issues such as signal drift and connectivity'
      ],
      'technologies': ['ESP32', 'Wi-Fi', 'BLE', 'Radio', 'UDP', 'EEG/EMG'],
    },
    {
      'title': 'Polaris Flight Controller Designer',
      'organization': 'Longhorn Rocketry Association',
      'duration': 'Aug 2024 – Present',
      'responsibilities': [
        'Designed, prototyped, and manufactured the Polaris Flight Controller PCB for high-powered rocketry, prioritizing cost-efficiency, reliability, and compact design',
        'Created detailed schematics and performed component sourcing to ensure affordability and reliability',
        'Collaborated with interdisciplinary teams to integrate the flight controller seamlessly into rocket systems, significantly enhancing mission reliability and data acquisition capabilities'
      ],
      'technologies': [
        'PCB Design',
        'Hardware Design',
        'Component Sourcing',
        'Flight Systems'
      ],
    },
    {
      'title': 'Programming Lead',
      'organization': 'FIRST Robotics (Howdy Bots)',
      'duration': 'Jan 2015 – Aug 2024',
      'responsibilities': [
        'Divided up tasks and led sub-teams in a community robotics group, achieving division finalist at the World Championship',
        'Programmed and developed the smallest competition legal FRC robot (Short Stack)',
        'Created a custom FRC Dashboard using LabVIEW, to clean up the driver interface; showing only relevant and important information to monitor and control the robot\'s motors and sensors',
        'Helped organize fundraising efforts (\$250k+) with events and found sponsors to sufficiently self-raise the operations of a robotics team without any school funding',
        'Designed and built various prototypes including a shooter prototype to eject balls with a high arc over 25 meters'
      ],
      'technologies': [
        'LabVIEW',
        'FRC',
        'Robotics',
        'Project Management',
        'Fundraising'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "EXPERIENCES",
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
            const SizedBox(height: 50),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: experiences.take(3).length,
              itemBuilder: (context, index) {
                final experience = experiences[index];
                return TimelineExperienceCard(
                  experience: experience,
                  isLast: index == 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            DetailPage(
                          title: experience['title'],
                          content:
                              ExperienceDetailContent(experience: experience),
                        ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                              opacity: animation, child: child);
                        },
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 60),
            Center(
              child: TechButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllExperiencesPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                label: "VIEW FULL TIMELINE",
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TimelineExperienceCard extends StatefulWidget {
  final Map<String, dynamic> experience;
  final bool isLast;
  final VoidCallback onTap;

  const TimelineExperienceCard({
    super.key,
    required this.experience,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<TimelineExperienceCard> createState() => _TimelineExperienceCardState();
}

class _TimelineExperienceCardState extends State<TimelineExperienceCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.cyanAccent.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 30.0),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovering = true),
                onExit: (_) => setState(() => _isHovering = false),
                child: GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: _isHovering
                            ? Colors.cyanAccent
                            : Colors.cyanAccent.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.work,
                                color: Colors.cyanAccent, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.experience['title'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward,
                                color: Colors.cyanAccent, size: 20),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.experience['organization'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.experience['duration'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.cyanAccent.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          widget.experience['responsibilities'][0],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
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
    );
  }
}

class AllExperiencesPage extends StatelessWidget {
  const AllExperiencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return CustomPaint(
                painter: TechBackgroundPainter(0),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.cyanAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "FULL TIMELINE",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ExperiencesPage.experiences.length,
                    itemBuilder: (context, index) {
                      final experience = ExperiencesPage.experiences[index];
                      return TimelineExperienceCard(
                        experience: experience,
                        isLast: index == ExperiencesPage.experiences.length - 1,
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DetailPage(
                                title: experience['title'],
                                content: ExperienceDetailContent(
                                    experience: experience),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  static final List<Map<String, dynamic>> projects = [
    {
      'title': 'iCog Dementia Screening App',
      'description':
          'Online app for early-stage dementia screening used by over 13k users in 83 countries. Partnered with Mini-Cog and recognized in national competitions; research publication in progress.',
      'longDescription':
          'An innovative mobile application designed to provide early-stage dementia screening, making healthcare more accessible to people worldwide. The app has been successfully adopted by over 13,000 users across 83 countries, demonstrating its global impact and usability.',
      'achievements': [
        'Developed a user-friendly interface for conducting cognitive assessments',
        'Implemented secure data storage and analysis systems',
        'Established partnership with Mini-Cog for validated screening methods',
        'Achieved recognition in national competitions',
        'Currently working on research publication'
      ],
      'technologies': ['Flutter', 'Firebase', 'Google Cloud'],
      'imageUrl': 'https://via.placeholder.com/300x150',
    },
    {
      'title': 'Smart Energy Monitor & Light Switch',
      'description':
          'SCADA system measuring household appliance energy consumption with a custom PCB prototype and plans for large-scale production.',
      'longDescription':
          'A comprehensive SCADA (Supervisory Control and Data Acquisition) system designed to monitor and analyze energy consumption of household appliances. The project includes custom PCB design and prototyping, with scalability in mind for potential mass production.',
      'achievements': [
        'Designed and manufactured custom PCB for energy monitoring',
        'Implemented real-time data collection and analysis',
        'Developed user interface for monitoring energy consumption',
        'Created scalable architecture for future production'
      ],
      'technologies': ['IoT', 'PCB Design', 'Embedded Systems'],
      'imageUrl': 'https://via.placeholder.com/300x150',
    },
    {
      'title': 'WakeSense Smart Pillow Alarm',
      'description':
          'Smart pillow alarm using pressure sensors to track sleep quality and wake individuals with hearing impairments, connected via Flutter app.',
      'longDescription':
          'An innovative smart pillow system designed to assist individuals with hearing impairments. The system uses pressure sensors to monitor sleep patterns and provides tactile wake-up alerts, all managed through a custom Flutter application.',
      'achievements': [
        'Integrated pressure sensors for sleep tracking',
        'Developed Flutter app for alarm control and sleep analysis',
        'Implemented Bluetooth connectivity for device communication',
        'Created adaptive wake-up algorithms based on sleep patterns'
      ],
      'technologies': ['Flutter', 'Firebase', 'IoT'],
      'imageUrl': 'https://via.placeholder.com/300x150',
    },
    {
      'title': 'Debate Timer App',
      'description':
          'App to time, record, and improve debater performances, part of Rdot Apps with over 9k users across 5 apps.',
      'longDescription':
          'A specialized timing application designed for debate competitions, featuring performance recording and analysis tools. Part of the successful Rdot Apps suite, which has garnered over 9,000 users across its various applications.',
      'achievements': [
        'Created intuitive timing interface for debate rounds',
        'Implemented performance recording and playback features',
        'Developed analytics for speech improvement',
        'Achieved significant user adoption within debate community'
      ],
      'technologies': ['Flutter', 'Dart', 'Firebase'],
      'imageUrl': 'https://via.placeholder.com/300x150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "PROJECTS",
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
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: projects
                  .take(4)
                  .map((project) => TechProjectCard(
                        title: project['title'],
                        description: project['description'],
                        technologies: project['technologies'],
                        imageUrl: project['imageUrl'],
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      DetailPage(
                                title: project['title'],
                                content: ProjectDetailContent(project: project),
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 40),
            Center(
              child: TechButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const AllProjectsPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                label: "VIEW ALL PROJECTS",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailContent extends StatelessWidget {
  final Map<String, dynamic> project;

  const ProjectDetailContent({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
              image: DecorationImage(
                image: NetworkImage(project['imageUrl']),
                fit: BoxFit.cover,
                opacity: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            project['longDescription'],
            style: TextStyle(
              fontSize: 18,
              height: 1.6,
              color: Colors.cyanAccent.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "Key Achievements",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          ...project['achievements'].map<Widget>((achievement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "•",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.cyanAccent.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      achievement,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.cyanAccent.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 30),
          const Text(
            "Technologies Used",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: (project['technologies'] as List<String>).map((tech) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                ),
                child: Text(
                  tech,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.cyanAccent,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TechProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final List<String> technologies;
  final String imageUrl;
  final VoidCallback onTap;

  const TechProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.technologies,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  State<TechProjectCard> createState() => _TechProjectCardState();
}

class _TechProjectCardState extends State<TechProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: _isHovering
                  ? Colors.cyanAccent
                  : Colors.cyanAccent.withOpacity(0.3),
            ),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 150,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.cover,
                            color: Colors.cyanAccent.withOpacity(0.1),
                            colorBlendMode: BlendMode.darken,
                          ),
                        ),
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(
                                      'https://i.imgur.com/vzePCxZ.png'),
                                  repeat: ImageRepeat.repeat,
                                  fit: BoxFit.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code,
                                size: 16, color: Colors.cyanAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.cyanAccent,
                                ),
                              ),
                            ),
                            const Icon(Icons.arrow_forward,
                                size: 16, color: Colors.cyanAccent),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: Colors.cyanAccent.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.technologies
                              .map((tech) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Colors.cyanAccent.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        letterSpacing: 1,
                                        color: Colors.cyanAccent,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isHovering)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.visibility,
                              color: Colors.cyanAccent),
                          const SizedBox(width: 8),
                          const Text(
                            "VIEW DETAILS",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final skills = {
      "PROGRAMMING_LANGUAGES": [
        "Dart",
        "Python",
        "Java",
        "C/C++",
        "C#",
        "LabVIEW",
        "ARM Assembly"
      ],
      "FRAMEWORKS_LIBRARIES": ["Flutter", "Angular"],
      "TOOLS_PLATFORMS": ["Git", "VS Code", "Eclipse", "Figma", "Adobe XD"],
      "DATABASES": ["Firebase Firestore"],
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 900),
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "SKILLS",
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              itemBuilder: (context, index) {
                final category = skills.keys.elementAt(index);
                final skillsList = skills[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.cyanAccent,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: 50,
                      height: 1,
                      color: Colors.cyanAccent.withOpacity(0.5),
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 15,
                      runSpacing: 15,
                      children: skillsList
                          .map((skill) => TechSkillBadge(skill: skill))
                          .toList(),
                    ),
                    const SizedBox(height: 30),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TechSkillBadge extends StatefulWidget {
  final String skill;

  const TechSkillBadge({super.key, required this.skill});

  @override
  State<TechSkillBadge> createState() => _TechSkillBadgeState();
}

class _TechSkillBadgeState extends State<TechSkillBadge> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: _isHovering ? Colors.cyanAccent : Colors.transparent,
          border: Border.all(color: Colors.cyanAccent),
        ),
        child: Text(
          widget.skill,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: _isHovering ? Colors.black : Colors.cyanAccent,
          ),
        ),
      ),
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

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
            const SizedBox(height: 30),
            const Text(
              "I'm always open to new opportunities and collaborations. Feel free to reach out to me if you want to work together or just want to say hi!",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                letterSpacing: 1,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TechContactButton(
                  icon: Icons.email,
                  label: "EMAIL",
                  onTap: () => _launchUrl('mailto:rishikb@utexas.edu'),
                ),
                TechContactButton(
                  icon: Icons.code,
                  label: "GITHUB",
                  onTap: () => _launchUrl('https://github.com/rishik4'),
                ),
                TechContactButton(
                  icon: Icons.link,
                  label: "LINKEDIN",
                  onTap: () => _launchUrl(
                      'https://www.linkedin.com/in/rishik-boddeti-9773b5239/'),
                ),
                TechContactButton(
                  icon: Icons.article,
                  label: "RESUME",
                  onTap: () => _launchUrl(
                      'https://drive.google.com/file/d/1EOm_7cDInpJut7-bUdAPiLElzXW3wrZF/view?usp=sharing'),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const TechContactForm(),
          ],
        ),
      ),
    );
  }
}

class TechContactForm extends StatefulWidget {
  const TechContactForm({super.key});

  @override
  State<TechContactForm> createState() => _TechContactFormState();
}

class _TechContactFormState extends State<TechContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "EXECUTE MESSAGE",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Colors.cyanAccent,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: TechTextField(
                  controller: _nameController,
                  label: "NAME",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TechTextField(
                  controller: _emailController,
                  label: "EMAIL",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Invalid format';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TechTextField(
            controller: _messageController,
            label: "MESSAGE",
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TechButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Message sent successfully.'),
                    backgroundColor: Colors.black,
                  ),
                );
                _nameController.clear();
                _emailController.clear();
                _messageController.clear();
              }
            },
            label: "EXECUTE",
          ),
        ],
      ),
    );
  }
}

class TechTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final String? Function(String?)? validator;

  const TechTextField({
    super.key,
    required this.controller,
    required this.label,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<TechTextField> createState() => _TechTextFieldState();
}

class _TechTextFieldState extends State<TechTextField> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: 1,
            color: Colors.cyanAccent.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 5),
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _hasFocus = hasFocus;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: _hasFocus
                    ? Colors.cyanAccent
                    : Colors.cyanAccent.withOpacity(0.3),
              ),
            ),
            child: TextFormField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              style: const TextStyle(
                fontSize: 14,
                letterSpacing: 1,
                color: Colors.cyanAccent,
              ),
              cursorColor: Colors.cyanAccent,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                border: InputBorder.none,
                errorStyle: const TextStyle(
                  fontSize: 12,
                  letterSpacing: 0.5,
                  color: Colors.redAccent,
                ),
              ),
              validator: widget.validator,
            ),
          ),
        ),
      ],
    );
  }
}

class TechButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const TechButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<TechButton> createState() => _TechButtonState();
}

class _TechButtonState extends State<TechButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.cyanAccent : Colors.transparent,
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code,
                size: 18,
                color: _isHovering ? Colors.black : Colors.cyanAccent,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: _isHovering ? Colors.black : Colors.cyanAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TechContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const TechContactButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<TechContactButton> createState() => _TechContactButtonState();
}

class _TechContactButtonState extends State<TechContactButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: _isHovering ? Colors.cyanAccent : Colors.transparent,
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            children: [
              Icon(
                widget.icon,
                size: 24,
                color: _isHovering ? Colors.black : Colors.cyanAccent,
              ),
              const SizedBox(height: 10),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2,
                  color: _isHovering ? Colors.black : Colors.cyanAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AllProjectsPage extends StatelessWidget {
  const AllProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: const AlwaysStoppedAnimation(0),
            builder: (context, child) {
              return CustomPaint(
                painter: TechBackgroundPainter(0),
                child: Container(),
                size: Size.infinite,
              );
            },
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.cyanAccent),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 20),
                      const Text(
                        "ALL PROJECTS",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          color: Colors.cyanAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: ProjectsPage.projects
                        .map((project) => TechProjectCard(
                              title: project['title'],
                              description: project['description'],
                              technologies: project['technologies'],
                              imageUrl: project['imageUrl'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        DetailPage(
                                      title: project['title'],
                                      content: ProjectDetailContent(
                                          project: project),
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
                                      return FadeTransition(
                                          opacity: animation, child: child);
                                    },
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
