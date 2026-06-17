path = './lib/presentation/pages/screens/home/home_screen.dart'
with open(path, 'r') as f:
    content = f.read()

# ── 1. Remove UploadedImage slide from carousel ──────────────────────────────
old_uploaded = '''                                  QuoteImage(
                                      imageUrl: logic
                                          .homePageImages.value.quoteImage),
                                  Obx(() {
                                    return UploadedImage(
                                      uploadedImage:
                                          logic.homePageImages.value.phoneImage,
                                      id: logic.homePageImages.value.id,
                                    );
                                  }),'''

new_uploaded = '''                                  QuoteImage(
                                      imageUrl: logic
                                          .homePageImages.value.quoteImage),'''

if old_uploaded in content:
    content = content.replace(old_uploaded, new_uploaded)
    print('Step 1 done: UploadedImage slide removed')
else:
    print('ERROR step 1: UploadedImage slide not found')

# ── 2. Fix dots to only use 2 items (zingArt + quote) ────────────────────────
old_dots = '''                        children: [
                          logic.homePageImages.value.phoneImage,
                          logic.homePageImages.value.zingArtImage?.image,
                          logic.homePageImages.value.quoteImage,
                        ].asMap().entries.map((entry) {'''

new_dots = '''                        children: [
                          logic.homePageImages.value.zingArtImage?.image,
                          logic.homePageImages.value.quoteImage,
                        ].asMap().entries.map((entry) {'''

if old_dots in content:
    content = content.replace(old_dots, new_dots)
    print('Step 2 done: dots updated to 2 items')
else:
    print('ERROR step 2: dots not found')

# ── 3. Remove social icons row ───────────────────────────────────────────────
old_social = '''              Padding(
                padding: EdgeInsets.only(
                  left: 37,
                  right: 37,
                  bottom: Platform.isAndroid ? 18 : 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.facebook.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_facebook.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.instagram.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                              'assets/icons/ic_instagram.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://twitter.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset(
                            'assets/icons/twitterx.svg',
                            color: isDark ? Colors.white : blackTextColor,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.youtube.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 33,
                          width: 33,
                          child: SvgPicture.asset('assets/icons/youtube.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.tiktok.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_tiktok.svg')),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrlString(
                          'https://www.snapchat.com/',
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child:
                              SvgPicture.asset('assets/icons/ic_snapchat.svg')),
                    ),
                  ],
                ),
              ),'''

if old_social in content:
    content = content.replace(old_social, '')
    print('Step 3 done: social icons removed')
else:
    print('ERROR step 3: social icons block not found')

with open(path, 'w') as f:
    f.write(content)

print('All done - file saved')
