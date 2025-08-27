  import 'package:flutter/material.dart';
  import 'package:get/get.dart';

  class ResultsScreenView extends StatefulWidget {
    const ResultsScreenView({super.key});

    @override
    State<ResultsScreenView> createState() => _ResultsScreenViewState();
  }

  class _ResultsScreenViewState extends State<ResultsScreenView>
      with TickerProviderStateMixin {
    late AnimationController _mainController;
    late AnimationController _checkController;
    late Animation<double> _fadeAnimation;
    late Animation<double> _slideAnimation;
    late Animation<double> _scaleAnimation;
    late Animation<double> _checkAnimation;

    @override
    void initState() {
      super.initState();

      // Main animation controller untuk card dan konten
      _mainController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      );

      // Check animation controller untuk icon sukses
      _checkController = AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      );

      // Fade animation untuk keseluruhan konten
      _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      );

      // Slide animation untuk card dari bawah
      _slideAnimation = Tween<double>(begin: 100.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
        ),
      );

      // Scale animation untuk card
      _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
        CurvedAnimation(
          parent: _mainController,
          curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
        ),
      );

      // Check mark animation
      _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _checkController, curve: Curves.elasticOut),
      );

      // Mulai animasi
      _startAnimations();
    }

    void _startAnimations() async {
      await Future.delayed(const Duration(milliseconds: 300));
      _mainController.forward();
      await Future.delayed(const Duration(milliseconds: 600));
      _checkController.forward();
    }

    @override
    void dispose() {
      _mainController.dispose();
      _checkController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final arguments = Get.arguments as Map<String, dynamic>;

      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Hasil Pendaftaran",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: AnimatedBuilder(
          animation: _mainController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: SafeArea(
                  // Tambahkan SafeArea
                  child: SingleChildScrollView(
                    // Bungkus Column
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        // Success Icon dengan animasi
                        ScaleTransition(
                          scale: _checkAnimation,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.shade200,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Status Text
                        const Text(
                          "Pendaftaran Berhasil!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Data Anda telah berhasil disimpan",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // Data Card dengan animasi
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.blue.shade600,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        "Detail Pendaftaran",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Data Items
                                  ...List.generate(4, (index) {
                                    final items = [
                                      {
                                        'icon': Icons.person_outline,
                                        'label': 'Nama',
                                        'value': arguments['name'],
                                      },
                                      {
                                        'icon': Icons.wc,
                                        'label': 'Jenis Kelamin',
                                        'value': arguments['gender'],
                                      },
                                      {
                                        'icon': Icons.calendar_today,
                                        'label': 'Tanggal Lahir',
                                        'value': arguments['dob'],
                                      },
                                      {
                                        'icon': Icons.phone,
                                        'label': 'Telepon',
                                        'value': arguments['phone'],
                                      },
                                    ];

                                    return TweenAnimationBuilder(
                                      duration: Duration(
                                        milliseconds: 300 + (index * 100),
                                      ),
                                      tween: Tween<double>(begin: 0.0, end: 1.0),
                                      builder: (context, value, child) {
                                        return Transform.translate(
                                          offset: Offset(20 * (1 - value), 0),
                                          child: Opacity(
                                            opacity: value,
                                            child: _buildDataItem(
                                              items[index]['icon'] as IconData,
                                              items[index]['label'] as String,
                                              items[index]['value'] as String,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Get.offAllNamed('/home');
          },
          icon: const Icon(Icons.home),
          label: const Text("Home"),
        ),
      );
    }

    Widget _buildDataItem(IconData icon, String label, String value) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: Colors.grey.shade600),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
