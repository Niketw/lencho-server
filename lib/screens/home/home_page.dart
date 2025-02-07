import 'package:flutter/material.dart';
import 'package:lencho/widgets/BushCloudRotated.dart';
import 'package:lencho/widgets/home/section_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with BushCloud
          Stack(
            children: [
              const SizedBox(
                height: 60,
                width: double.infinity,
                child: BushCloudRotated(),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.location_on, color: Color(0xFF2D5A27)),
                      Row(
                        children: [
                          Image.asset('assets/images/logo.png', height: 24),
                          const SizedBox(width: 8),
                          const Text(
                            'Lencho Inc.',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFF2D5A27),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.person, color: Color(0xFF2D5A27)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Community Updates
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/community');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2D5A27),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Community Updates',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.chat_bubble_outline),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Dashboard Section
                  ScrollableSection(
                    title: 'DASHBOARD',
                    items: [
                      SectionItem(
                        title: 'Disease Detection',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/dashboard/disease',
                        ),
                      ),
                      SectionItem(
                        title: 'Irrigation Plan',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/dashboard/irrigation',
                        ),
                      ),
                    ],
                  ),

                  // Campaigns Section
                  ScrollableSection(
                    title: 'Campaigns',
                    items: [
                      SectionItem(
                        title: 'Spring Campaign',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/campaigns/spring',
                        ),
                      ),
                      SectionItem(
                        title: 'Summer Campaign',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/campaigns/summer',
                        ),
                      ),
                    ],
                  ),

                  // News Section
                  ScrollableSection(
                    title: 'News',
                    items: [
                      SectionItem(
                        title: 'Market Updates',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/news/market',
                        ),
                      ),
                      SectionItem(
                        title: 'Weather Forecast',
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/news/weather',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}