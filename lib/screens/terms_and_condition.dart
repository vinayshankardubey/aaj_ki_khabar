import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class TermsAndConditionScreen extends StatelessWidget {
  const TermsAndConditionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: AppColors.redColor,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.whiteColor),
        toolbarHeight: 64,
        title: Text("Terms & Condition",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor),),


      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle('Terms & Conditions'),
            SectionText(
              'By accessing this web site, you are agreeing to be bound by these web site Terms and Conditions of Use, '
                  'all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws. '
                  'If you do not agree with any of these terms, you are prohibited from using or accessing this site. The materials contained '
                  'in this web site are protected by applicable copyright and trade mark law.',
            ),
            SectionTitle('Third Party Cookies'),
            SectionText(
              'Third parties may be placing and reading cookies on your users’ browsers, or using web beacons to collect '
                  'information as a result of ad serving on your website.',
            ),
            SectionTitle('Usage License'),
            SectionText(
              'Permission is granted to temporarily download one copy of the materials (information or software) on liveuttarpradesh.com’s '
                  'web site for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n'
                  '- Modify or copy the materials;\n'
                  '- Use the materials for any commercial purpose, or for any public display (commercial or non-commercial);\n'
                  '- Attempt to decompile or reverse engineer any software contained on liveuttarpradesh.com’s web site;\n'
                  '- Remove any copyright or other proprietary notations from the materials; or\n'
                  '- Transfer the materials to another person or “mirror” the materials on any other server.\n\n'
                  'This license shall automatically terminate if you violate any of these restrictions and may be terminated by liveuttarpradesh.com at any time.',
            ),
            SectionText(
              'Upon terminating your viewing of these materials or upon the termination of this license, you must destroy any downloaded materials '
                  'in your possession whether in electronic or printed format.',
            ),
            SectionTitle('Revisions and Errata'),
            SectionText(
              'The materials appearing on liveuttarpradesh.com’s web site could include technical, typographical, or photographic errors. '
                  'liveuttarpradesh.com does not warrant that any of the materials on its web site are accurate, complete, or current. '
                  'liveuttarpradesh.com may make changes to the materials contained on its web site at any time without notice. However, it does not make any commitment to update the materials.',
            ),
            SectionTitle('Links'),
            SectionText(
              'liveuttarpradesh.com has not reviewed all of the sites linked to its Internet web site and is not responsible for the contents of any such linked site. '
                  'The inclusion of any link does not imply endorsement by liveuttarpradesh.com. Use of any such linked web site is at the user’s own risk.',
            ),
            SectionTitle('Site Terms of Use Modifications'),
            SectionText(
              'liveuttarpradesh.com may revise these terms of use for its web site at any time without notice. By using this web site you are agreeing '
                  'to be bound by the then current version of these Terms and Conditions of Use.',
            ),
            SectionTitle('Governing Law'),
            SectionText(
              'Any claim relating to liveuttarpradesh.com’s web site shall be governed by the laws of the State ‘Uttar Pradesh’, India, jurisdiction Lucknow, '
                  'without regard to its conflict of law provisions.',
            ),
            SectionTitle('General Terms'),
            SectionText(
              'We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of '
                  'personal information is protected and maintained.',
            ),
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
        style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: AppColors.greenColor)),
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
