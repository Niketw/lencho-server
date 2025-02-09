import 'package:flutter/material.dart';
import 'package:lencho/widgets/home/section_widgets.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Community Updates Section
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
                  onTap: () => Navigator.pushNamed(context, '/dashboard/disease'),
                ),
                SectionItem(
                  title: 'Irrigation Plan',
                  onTap: () => Navigator.pushNamed(context, '/dashboard/irrigation'),
                ),
              ],
            ),
            
            // Campaigns Section
            ScrollableSection(
              title: 'Campaigns',
              items: [
                SectionItem(
                  title: 'Spring Campaign',
                  onTap: () => Navigator.pushNamed(context, '/campaigns/spring'),
                ),
                SectionItem(
                  title: 'Summer Campaign',
                  onTap: () => Navigator.pushNamed(context, '/campaigns/summer'),
                ),
              ],
            ),
            
            // News Section
            ScrollableSection(
              title: 'News',
              items: [
                SectionItem(
                  title: 'Market Updates',
                  onTap: () => Navigator.pushNamed(context, '/news/market'),
                ),
                SectionItem(
                  title: 'Weather Forecast',
                  onTap: () => Navigator.pushNamed(context, '/news/weather'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
