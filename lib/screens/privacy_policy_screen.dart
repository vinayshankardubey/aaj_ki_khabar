import 'package:flutter/material.dart';

import '../utils/Colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        iconTheme: IconThemeData(color: Colors.white),
        toolbarHeight: 64,
        title: Text("Privacy Policy",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
        centerTitle: true,

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle('Privacy Policy'),
            SectionText(
              'This Privacy Policy governs the manner in which aajkikhabar.com collects, uses, '
                  'maintains and discloses information collected from users (each, a User) of the '
                  'aajkikhabar.com website (Site). This privacy policy applies to the Site, all products '
                  'and services offered by aajkikhabar.com.',
            ),
            SectionTitle('Personal Identification Information'),
            SectionText(
              'We may collect personal identification information from Users in a variety of ways, '
                  'including, but not limited to, when Users visit our site, subscribe to the newsletter, and in connection '
                  'with other activities, services, features or resources we make available on our Site. '
                  'Users may be asked for, as appropriate, name, email address. Users may, however, visit our Site anonymously. '
                  'We will collect personal identification information from Users only if they voluntarily submit such information to us.',
            ),
            SectionTitle('Non-personal Identification Information'),
            SectionText(
              'We may collect non-personal identification information about Users whenever they interact with our Site. '
                  'Non-personal identification information may include the browser name, the type of computer and technical information '
                  'about Users means of connection to our Site, such as the operating system and the Internet service providers utilized.',
            ),
            SectionTitle('Web Browser Cookies'),
            SectionText(
              'Our Site may use “cookies” to enhance User experience. User’s web browser places cookies on their hard drive for '
                  'record-keeping purposes and sometimes to track information about them. If they do so, some parts of the Site may not function properly.',
            ),
            SectionTitle('How We Use Collected Information?'),
            SectionText(
              'aajkikhabar.com collects and uses Users personal information for the following purposes:\n'
                  '– To improve our Site\n'
                  '– To improve customer service',
            ),
            SectionTitle('How We Protect Your Information?'),
            SectionText(
              'We adopt appropriate data collection, storage and processing practices and security measures to protect against unauthorized access. '
                  'Sensitive and private data exchange happens over a SSL secured communication channel and is encrypted.',
            ),
            SectionTitle('Sharing Your Personal Information'),
            SectionText(
              'We do not sell, trade, or rent Users personal identification information to others. '
                  'We may share generic aggregated demographic information not linked to any personal identification information.',
            ),
            SectionTitle('Compliance With Children’s Online Privacy Protection Act'),
            SectionText(
              'We never collect or maintain information at our Site from those we actually know are under 13.',
            ),
            SectionTitle('Changes To This Privacy Policy'),
            SectionText(
              'aajkikhabar.com has the discretion to update this privacy policy at any time. '
                  'We encourage Users to frequently check this page for any changes.',
            ),
            SectionTitle('Your Acceptance Of These Terms'),
            SectionText(
              'By using this Site, you signify your acceptance of this policy. Continued use of the Site means acceptance of changes.',
            ),
            SectionTitle('Your Consent'),
            SectionText('By using our site, you consent to our privacy policy.'),
            SectionTitle('Contacting Us'),
            SectionText('If you have any questions, contact us at info@aajkikhbar.com.'),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: colorPrimary),
      ),
    );
  }
}

class SectionText extends StatelessWidget {
  final String text;
  const SectionText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 16),
      textAlign: TextAlign.justify,
    );
  }
}

