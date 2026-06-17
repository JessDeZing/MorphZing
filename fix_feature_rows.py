path = './lib/presentation/pages/screens/home/home_screen.dart'
with open(path, 'r') as f:
    content = f.read()

old = '''                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(todoRoute),
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: SvgPicture.asset(
                                          'assets/icons/todo.svg',
                                          colorFilter: ColorFilter.mode(
                                            isDark ? Colors.white : blackTextColor,
                                            BlendMode.srcIn,
                                          ),
                                        )),
                                    const SizedBox(height: 6),
                                    Text(
                                      'To-Do',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(allJournal),
                            child: SizedBox(
                              height: Platform.isAndroid ? 140 : 130,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image(
                                        image: AssetImage(
                                            'assets/icons/Journal.png'),
                                      )),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    journal.tr,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : blackTextColor,
                                      fontFamily: 'SF Pro Display',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            // _pushAndUpdateBanners(allJournal)
                            onTap: () => _pushAndUpdateBanners(webViewRoute),
                            // async {
                            //   launchUrl(
                            //     Uri.parse('https://zingphotography.com'),
                            //     mode: LaunchMode.externalApplication,
                            //   );
                            // },
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/ZingPhotography.png'),
                                          color: isDark
                                              ? Colors.white
                                              : blackTextColor,
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      zingPhotography.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _pushAndUpdateBanners(allNoteRoute),
                            child: SizedBox(
                                height: Platform.isAndroid ? 140 : 130,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Image(
                                          image: AssetImage(
                                              'assets/icons/notes.png'),
                                        )),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      notes.tr,
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : blackTextColor,
                                        fontFamily: 'SF Pro Display',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () =>
                        //         _pushAndUpdateBanners(worldChangersRoute),
                        //     child: SizedBox(
                        //         height: 130,
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             SizedBox(
                        //                 height: 100,
                        //                 width: 100,
                        //                 child: Image(
                        //                   image: AssetImage(
                        //                       'assets/icons/wordl_changer.png'),
                        //                 )),
                        //             SizedBox(
                        //               height: 6,
                        //             ),
                        //             Text(
                        //               worldChangers.tr,
                        //               style: TextStyle(
                        //                 color: isDark
                        //                     ? Colors.white
                        //                     : blackTextColor,
                        //                 fontFamily: 'SF Pro Display',
                        //                 fontSize: 14,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             )
                        //           ],
                        //         )),
                        //   ),
                        // ),

                      ],
                    ),'''

new = '''                    const SizedBox(height: 8),
                    _featureRow(
                      context: context,
                      icon: SvgPicture.asset(
                        'assets/icons/todo.svg',
                        colorFilter: ColorFilter.mode(
                          isDark ? Colors.white : blackTextColor,
                          BlendMode.srcIn,
                        ),
                        height: 24,
                        width: 24,
                      ),
                      iconBg: const Color(0xFF3D2B6B),
                      label: 'To-Do',
                      subtitle: 'Tackle today\'s tasks',
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(todoRoute),
                    ),
                    _featureRow(
                      context: context,
                      icon: Image.asset('assets/icons/Journal.png', height: 24, width: 24),
                      iconBg: const Color(0xFF6B3A1F),
                      label: 'Journal',
                      subtitle: 'Write about your day',
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(allJournal),
                    ),
                    _featureRow(
                      context: context,
                      icon: Image.asset('assets/icons/notes.png', height: 24, width: 24),
                      iconBg: const Color(0xFF1F5C3A),
                      label: 'Notes',
                      subtitle: 'Quick thoughts & ideas',
                      isDark: isDark,
                      onTap: () => _pushAndUpdateBanners(allNoteRoute),
                    ),
                    _featureRow(
                      context: context,
                      icon: Icon(Icons.palette_outlined, color: Colors.white, size: 24),
                      iconBg: const Color(0xFF5C1F4A),
                      label: 'Calm Corner',
                      subtitle: 'Breathe. Color. Reset.',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    const SizedBox(height: 16),'''

if old in content:
    content = content.replace(old, new)
    print('Feature rows replaced')
else:
    print('ERROR: old block not found')
    
with open(path, 'w') as f:
    f.write(content)
print('File saved')
