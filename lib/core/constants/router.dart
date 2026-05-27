import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:morphzing/presentation/pages/screens/agenda/agenda_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/finances/finances_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/meet_up/meet_up_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/self_care/self_care_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/special_occasions/special_occasions_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/travel/travel_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/events/work/work_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_moth/this_month_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/this_year/this_year_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/today/today_screen.dart';
import 'package:morphzing/presentation/pages/screens/agenda/todo/todo_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/create_password/create_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/login/login_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/phone/phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/recovery_password/recovery_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/registration/registration_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/reset_password/reset_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/signup/sign_up_screen.dart';
import 'package:morphzing/presentation/pages/screens/auth/verification/verification_screen.dart';
import 'package:morphzing/presentation/pages/screens/calendar/calendar_screen.dart';
import 'package:morphzing/presentation/pages/screens/calendar/tasks_events_details/tasks_events_screen.dart';
import 'package:morphzing/presentation/pages/screens/entry/intro/first_intro_screen.dart';
import 'package:morphzing/presentation/pages/screens/entry/intro/second_intro_screen.dart';
import 'package:morphzing/presentation/pages/screens/entry/setup_language/setup_language_screen.dart';
import 'package:morphzing/presentation/pages/screens/home/home_binding.dart';
import 'package:morphzing/presentation/pages/screens/home/home_screen.dart';
import 'package:morphzing/presentation/pages/screens/home/web_view_container.dart';
import 'package:morphzing/presentation/pages/screens/journal/image_list_view_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal/journal_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal/painting_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/all_journal/all_journal_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/calendar_journal/calendar_journal_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/journal/new_journal_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/multi_photo/multi_photo_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/single_photo/single_photo_screen.dart';
import 'package:morphzing/presentation/pages/screens/journal_new/today_journal/today_journal_screen.dart';
import 'package:morphzing/presentation/pages/screens/mission_statement_screen.dart';
import 'package:morphzing/presentation/pages/screens/subscription_plan.dart';
import 'package:morphzing/presentation/pages/screens/not_internet/not_internet_screen.dart';
import 'package:morphzing/presentation/pages/screens/note/all_note/all_note_screen.dart';
import 'package:morphzing/presentation/pages/screens/note/my_note/my_note_screen.dart';
import 'package:morphzing/presentation/pages/screens/note/note/note_screen.dart';
import 'package:morphzing/presentation/pages/screens/notification_settings/notification_settings_screen.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/arguments.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/invitations_by_category/invitations_screen.dart';
import 'package:morphzing/presentation/pages/screens/pending_invitations/pending_invitations_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile/change_password/change_password_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile/current_phone/current_phone_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile/profile_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/about_the_app_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/disclaimer_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/faq_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/privacy_policy_screen.dart';
import 'package:morphzing/presentation/pages/screens/profile_menu/terms_of_use.dart';
import 'package:morphzing/presentation/pages/screens/profile/about_me_screen.dart';
import 'package:morphzing/presentation/pages/screens/entry/splash/splash_screen.dart';
import 'package:morphzing/presentation/pages/screens/search/search_screen.dart';
import 'package:morphzing/presentation/pages/screens/standard_view/standard_view.dart';
import 'package:morphzing/presentation/pages/screens/subscription/subscription_screen.dart';
import 'package:morphzing/presentation/pages/screens/templates/templates_screen.dart';
import 'package:morphzing/presentation/pages/screens/world_changers/world_changers_screen.dart';
import 'package:morphzing/presentation/routers/rout_names.dart';

class AppRouter {
  static GetPageRoute<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      /// New Journal Screens
      case allNoteRoute:
        return GetPageRoute(
            page: () => const AllNoteScreen(), settings: settings);
      case noteRoute:
        return GetPageRoute(page: () => const NoteScreen(), settings: settings);
      case myRoute:
        return GetPageRoute(
            page: () => const MyNoteScreen(), settings: settings);

      /// New Journal Screens
      case allJournal:
        return GetPageRoute(
            page: () => const AllJournalScreen(), settings: settings);
      case calendarJournal:
        return GetPageRoute(
            page: () => const CalendarJournalScreen(), settings: settings);
      case createJournal:
        return GetPageRoute(
            page: () => const AllJournalScreen(), settings: settings);
      case todayJournalRoute:
        return GetPageRoute(
            page: () => const TodayJournalScreen(), settings: settings);
      case multiPhotoRoute:
        return GetPageRoute(
            page: () => const MultiPhotoScreen(), settings: settings);
      case singlePhotoRoute:
        return GetPageRoute(
            page: () => const SinglePhotoScreen(), settings: settings);

      case notInternetRoute:
        return GetPageRoute(
            page: () => const NotInternetScreen(), settings: settings);

      /// Entry Screens
      case splashRoute:
        return GetPageRoute(
            page: () => const SplashScreen(), settings: settings);
      case setupLanguageRoute:
        return GetPageRoute(
            page: () => const SetupLanguageScreen(), settings: settings);
      case firstIntroRoute:
        return GetPageRoute(
            page: () => const FirstIntroScreen(), settings: settings);
      case secondIntroRoute:
        return GetPageRoute(
            page: () => const SecondIntroScreen(), settings: settings);

      /// Registration Screens

      case recoveryPasswordRoute:
        return GetPageRoute(
            page: () => const RecoveryPasswordScreen(), settings: settings);
      case phoneRoute:
        return GetPageRoute(
            page: () => const PhoneScreen(), settings: settings);
      case verificationRoute:
        return GetPageRoute(
            page: () => const VerificationScreen(), settings: settings);
      case createPasswordRoute:
        return GetPageRoute(
            page: () => const CreatePasswordScreen(), settings: settings);
      case resetPasswordRoute:
        return GetPageRoute(
            page: () => const ResetPasswordScreen(), settings: settings);
      case loginRoute:
        return GetPageRoute(
            page: () => const LoginScreen(), settings: settings);
      case signUpRoute:
        return GetPageRoute(
            page: () => const SignUpScreen(), settings: settings);
      case registrationRoute:
        return GetPageRoute(
            page: () => const RegistrationScreen(), settings: settings);
      case changePasswordRoute:
        return GetPageRoute(
            page: () => const ChangePasswordScreen(), settings: settings);
      case currentPhoneRoute:
        return GetPageRoute(
            page: () => const CurrentPhoneScreen(), settings: settings);
      case profileRoute:
        return GetPageRoute(
            page: () => const ProfileScreen(), settings: settings);

      /// Other Screens
      case searchRoute:
        return GetPageRoute(
            page: () => const SearchScreen(), settings: settings);
      case journeyRoute:
        return GetPageRoute(
            page: () => const NewJournalScreen(), settings: settings);
      case painterRoute:
        return GetPageRoute(page: () => const PaintingScreen());
      case allImagesRoute:
        return GetPageRoute(page: () => const ImageListViewScreen());
      case aboutMeRoute:
        return GetPageRoute(page: () => const AboutMeScreen());
      // web view
      case webViewRoute:
        return GetPageRoute(page: () => const WebViewContainer());
      case homeRoute:
        return GetPageRoute(
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        );
      case missionStatementRoute:
        return GetPageRoute(page: () => const MissionStatementScreen());
      case subscriptionPlanRoute:
        return GetPageRoute(
            page: () => const SubscriptionPlanScreen()); // new developed screen
      // case newSubscriptionScreen:
      //   return GetPageRoute(page: () => const NewSubscriptionScreen()); // another with prev data
      //   //subscriptionBottomSheet new neew
      // case subscriptionBottomSheet:
      // return GetPageRoute(page: () => const SubscriptionBottomSheet());

      case aboutTheAppRoute:
        return GetPageRoute(page: () => AboutTheAppScreen());
      case faqRoute:
        return GetPageRoute(page: () => FaqScreen());
      case termsOfUseRoute:
        return GetPageRoute(page: () => TermsOfUseScreen());
      case disclaimerRoute:
        return GetPageRoute(page: () => const DisclaimerScreen());
      case privacyPolicyRoute:
        return GetPageRoute(page: () => PrivacyPolicyScreen());
      case worldChangersRoute:
        return GetPageRoute(page: () => const WorldChangersScreen());
      case todoRoute:
        return GetPageRoute(page: () => const TodoListScreen());
      case todayRoute:
        final args = settings.arguments as DateTime?;
        return GetPageRoute(
            page: () => TodayScreen(chosenDayFromMonthly: args));
      case thisMonthRoute:
        return GetPageRoute(page: () => const ThisMonthScreen());
      case thisYearRoute:
        return GetPageRoute(page: () => const ThisYearScreen());
      case agendaRoute:
        return GetPageRoute(page: () => const AgendaScreen());
      case workRoute:
        return GetPageRoute(page: () => const WorkScreen());
      case financesRoute:
        return GetPageRoute(page: () => const FinancesScreen());
      case meetUpRoute:
        return GetPageRoute(page: () => const MeetUpScreen());
      case selfCareRoute:
        return GetPageRoute(page: () => const SelfCareScreen());
      case specialOccasionRoute:
        return GetPageRoute(page: () => const SpecialOccasionsScreen());
      case travelRoute:
        return GetPageRoute(page: () => const TravelScreen());
      case calendarRoute:
        return GetPageRoute(page: () => const CalendarScreen());
      case calendarCellDetailsRoute:
        DateTime time = settings.arguments as DateTime;
        return GetPageRoute(page: () => TasksAndEventsScreen(time: time));
      case journalRoute:
        return GetPageRoute(
          page: () => const JournalScreen(),
        );
      case pendingInvitationsRoute:
        return GetPageRoute(page: () => const PendingInvitationsScreen());
      case invitationsByCategoryRoute:
        final args = settings.arguments as InvitationArguments;
        return GetPageRoute(page: () => InvitationsScreen(arguments: args));
      case subscriptionScreen:
        return GetPageRoute(page: () => const SubscriptionScreen());
      case templatesScreen:
        return GetPageRoute(page: () => const TemplatesScreen());
      case standardView:
        final args = settings.arguments as String;
        return GetPageRoute(page: () => StandardView(imageUrl: args));
      case notificationSettingsRoute:
        return GetPageRoute(page: () => const NotificationSettingsScreen());
      default:
        // Handle deep links that start with /event_id/
        if (settings.name != null && settings.name!.startsWith('/event_id/')) {
          // Extract event ID from the route
          final eventIdStr = settings.name!.split('/').last;
          final eventId = int.tryParse(eventIdStr);

          if (eventId != null) {
            // Navigate to home screen and let DynamicDeepLinkService handle the deep link
            return GetPageRoute(
              page: () => const HomeScreen(),
              binding: HomeBinding(),
            );
          }
        }

        return GetPageRoute(
            page: () => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

