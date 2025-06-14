import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../utils/extension.dart';
import 'package:nb_utils/nb_utils.dart';


import '../AppLocalizations.dart';

class AboutAppScreen extends StatelessWidget {
  static String tag = '/AboutAppScreen';

  @override
  Widget build(BuildContext context) {
    var appLocalization = AppLocalizations.of(context)!;

    return SafeArea(
      top: !isIOS ? true : false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          iconTheme: IconThemeData(color: Colors.white),
          toolbarHeight: 64,
          title: Text("About us",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500),),
          centerTitle: true,

        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(mAppName, style: primaryTextStyle(size: 30)),
              16.height,
              Text(appLocalization.translate('version'), style: secondaryTextStyle()),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snap) {
                  if (snap.hasData) {
                    return Text('${snap.data!.version.validate()}', style: primaryTextStyle());
                  }
                  return SizedBox();
                },
              ),
              16.height.visible(getStringAsync(LAST_UPDATE_DATE).isNotEmpty),

              16.height,
              Text('News Source', style: secondaryTextStyle()),
              Text("https://aajkikhabar.com/", style: primaryTextStyle(color: colorPrimary)).onTap(() {
                launchUrls("https://aajkikhabar.com/", forceWebView: true);
              }),
              16.height,
              Text( "A venture of Swastik Transmedia Services Pvt. Ltd., Aajkikhabar.com is a hugely popular English and Hindi News Portal and Internet Video Channel. Based in Lucknow, Aajkikhabar is the best destination for news and updates and aims to provide its readers unbiased and authentic news and updates."
                    "Through its network of reporters and tie-ups with credible news agencies, aajkikhabar.com publishes news that ranges from International to local level with constant updates that keep the readers truly informed. Catering to various sections of readers, aajkikhabar.com provides news to which different generations can relate and find useful.\n"
                    "Aajkikhabar.com has a team of journalists with proven credentials and takes utmost care that the readers get the real news and updates about events and happenings that influence our lives."
                    "Aajkikhabar.com provides news both in English and Hindi under various sections like International, National, Regional, Entertainment, Sports, Health, Science and Technology, Gadgets, and Human Interest.",
                    style: TextStyle(fontSize: 16)
              ),
                16.height,
              GestureDetector(
                onTap: () async {
                  await launchUrls('mailto:${getStringAsync(CONTACT_PREF)}');
                },
                child: Text('Reach us: ${getStringAsync(CONTACT_PREF)}', style: primaryTextStyle(color: colorPrimary)),
              ),
              16.height,
              GestureDetector(
                onTap: () async {
                  await launchUrls('tel:$contactUS');
                },
                child: Text('Call us: $contactUS', style: primaryTextStyle(color: colorPrimary)),
              ),
              16.height,
            ],
          ),
        ),
      ),
    );
  }
}
