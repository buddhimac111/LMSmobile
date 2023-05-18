import 'package:flutter/material.dart';
import 'package:lms/main.dart';

class FAQPage extends StatelessWidget {
  final List<FAQItem> faqItems = [
    FAQItem(
      question: 'How do I download and install the mobile LMS app?',
      answer:
      'You can download and install the mobile LMS app (UniLearn) by University Web Site',
    ),
    FAQItem(
      question: 'Can I access the mobile LMS on multiple devices?',
      answer:
      'Yes, you can access the mobile LMS on multiple devices. Simply install the LMS app on each device and log in using your account credentials.',
    ),
    FAQItem(
      question: 'What happens if I encounter technical issues while using the mobile LMS?',
      answer:
      'If you encounter any technical issues while using the mobile LMS, you can reach out to the technical support team in the University',
    ),
    FAQItem(
      question: 'Is there a way to change my credentials and details',
      answer:
      'Yes, you can change your credentials and details in the University IT department they will help you to change your credentials and details.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: customColors.primary,
      ),
      body: ListView.builder(
        itemCount: faqItems.length,
        itemBuilder: (context, index) {
          final faqItem = faqItems[index];
          return Column(
            children: [
              ExpansionTile(
                title: Text(
                  faqItem.question,
                  style: TextStyle(color: customColors.black), // Set the title color to red
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(faqItem.answer),
                  ),
                ],
              ),
              SizedBox(height: 16.0), // Add a gap between each question
            ],
          );
        },
      )

    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({
    required this.question,
    required this.answer,
  });
}