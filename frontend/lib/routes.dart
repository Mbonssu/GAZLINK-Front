import 'package:flutter/material.dart';
import 'models/models.dart';

// Shared Screens
import 'screens/shared/splash_screen.dart';
import 'screens/shared/login_screen.dart';
import 'screens/shared/signup_screen.dart';
import 'screens/shared/onboarding_screen.dart';
import 'screens/shared/forgot_password_screen.dart';
import 'screens/shared/otp_verification_screen.dart';
import 'screens/shared/role_selection_screen.dart';
import 'screens/shared/profile_screen.dart';
import 'screens/shared/edit_profile_screen.dart';
import 'screens/shared/change_password_screen.dart';
import 'screens/shared/settings_screen.dart';
import 'screens/shared/notifications_screen.dart';
import 'screens/shared/notification_settings_screen.dart';
import 'screens/shared/saved_addresses_screen.dart';
import 'screens/shared/add_edit_address_screen.dart';
import 'screens/shared/language_screen.dart';
import 'screens/shared/theme_settings_screen.dart';
import 'screens/shared/about_screen.dart';
import 'screens/shared/payment_method_screen.dart';
import 'screens/shared/mtn_momo_payment_screen.dart';
import 'screens/shared/orange_money_payment_screen.dart';
import 'screens/shared/payment_history_screen.dart';
import 'screens/shared/receipt_screen.dart';
import 'screens/shared/chat_support_screen.dart';
import 'screens/shared/faq_screen.dart';
import 'screens/shared/terms_screen.dart';
import 'screens/shared/privacy_policy_screen.dart';
import 'screens/shared/report_issue_screen.dart';

// Client Screens
import 'screens/client/client_home_screen.dart';
import 'screens/client/order_flow_screen.dart';
import 'screens/client/order_history_screen.dart';
import 'screens/client/order_detail_screen.dart';
import 'screens/client/order_tracking_screen.dart';
import 'screens/client/rate_delivery_screen.dart';
import 'screens/client/cancel_order_screen.dart';
import 'screens/client/depot_list_screen.dart';
import 'screens/client/depot_detail_screen.dart';
import 'screens/client/depot_reviews_screen.dart';
import 'screens/client/favorite_depots_screen.dart';

// Deliverer Screens
import 'screens/deliverer/deliverer_home_screen.dart';
import 'screens/deliverer/delivery_detail_screen.dart';
import 'screens/deliverer/delivery_history_screen.dart';
import 'screens/deliverer/earnings_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String roleSelection = '/role-selection';

  // Profile & Settings
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String changePassword = '/change-password';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String notificationSettings = '/notification-settings';
  static const String savedAddresses = '/saved-addresses';
  static const String addEditAddress = '/add-edit-address';
  static const String language = '/language';
  static const String themeSettings = '/theme-settings';
  static const String about = '/about';

  // Client Routes
  static const String clientHome = '/client-home';
  static const String orderFlow = '/order-flow';
  static const String orderHistory = '/order-history';
  static const String orderDetail = '/order-detail';
  static const String orderTracking = '/order-tracking';
  static const String rateDelivery = '/rate-delivery';
  static const String cancelOrder = '/cancel-order';
  static const String depotList = '/depot-list';
  static const String depotDetail = '/depot-detail';
  static const String depotReviews = '/depot-reviews';
  static const String favoriteDepots = '/favorite-depots';

  // Payment Routes
  static const String paymentMethod = '/payment-method';
  static const String mtnMomoPayment = '/mtn-momo-payment';
  static const String orangeMoneyPayment = '/orange-money-payment';
  static const String paymentHistory = '/payment-history';
  static const String receipt = '/receipt';

  // Support Routes
  static const String chatSupport = '/chat-support';
  static const String faq = '/faq';
  static const String terms = '/terms';
  static const String privacyPolicy = '/privacy-policy';
  static const String reportIssue = '/report-issue';

  // Deliverer Routes
  static const String delivererHome = '/deliverer-home';
  static const String deliveryDetail = '/delivery-detail';
  static const String deliveryHistory = '/delivery-history';
  static const String earnings = '/earnings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Shared Routes
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phone: args?['phone'] ?? '',
            purpose: args?['purpose'] ?? 'verification',
          ),
        );
      case AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());

      // Profile & Settings
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case AppRoutes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case AppRoutes.notificationSettings:
        return MaterialPageRoute(
            builder: (_) => const NotificationSettingsScreen());
      case AppRoutes.savedAddresses:
        return MaterialPageRoute(builder: (_) => const SavedAddressesScreen());
      case AppRoutes.addEditAddress:
        final address = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddEditAddressScreen(address: address),
        );
      case AppRoutes.language:
        return MaterialPageRoute(builder: (_) => const LanguageScreen());
      case AppRoutes.themeSettings:
        return MaterialPageRoute(builder: (_) => const ThemeSettingsScreen());
      case AppRoutes.about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      // Client Routes
      case AppRoutes.clientHome:
        return MaterialPageRoute(builder: (_) => const ClientHomeScreen());
      case AppRoutes.orderFlow:
        final depot = settings.arguments as Depot?;
        if (depot == null) {
          return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(child: Text('Dépôt requis')),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => OrderFlowScreen(depot: depot),
        );
      case AppRoutes.orderHistory:
        return MaterialPageRoute(builder: (_) => const OrderHistoryScreen());
      case AppRoutes.orderDetail:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(order: order),
        );
      case AppRoutes.orderTracking:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => OrderTrackingScreen(order: order),
        );
      case AppRoutes.rateDelivery:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => RateDeliveryScreen(order: order),
        );
      case AppRoutes.cancelOrder:
        final order = settings.arguments as Order;
        return MaterialPageRoute(
          builder: (_) => CancelOrderScreen(order: order),
        );
      case AppRoutes.depotList:
        return MaterialPageRoute(builder: (_) => const DepotListScreen());
      case AppRoutes.depotDetail:
        final depot = settings.arguments as Depot;
        return MaterialPageRoute(
          builder: (_) => DepotDetailScreen(depot: depot),
        );
      case AppRoutes.depotReviews:
        final depot = settings.arguments as Depot;
        return MaterialPageRoute(
          builder: (_) => DepotReviewsScreen(depot: depot),
        );
      case AppRoutes.favoriteDepots:
        return MaterialPageRoute(builder: (_) => const FavoriteDepotsScreen());

      // Payment Routes
      case AppRoutes.paymentMethod:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PaymentMethodScreen(
            amount: args['amount'],
            orderId: args['orderId'],
          ),
        );
      case AppRoutes.mtnMomoPayment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MtnMomoPaymentScreen(
            amount: args['amount'],
            orderId: args['orderId'],
          ),
        );
      case AppRoutes.orangeMoneyPayment:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrangeMoneyPaymentScreen(
            amount: args['amount'],
            orderId: args['orderId'],
          ),
        );
      case AppRoutes.paymentHistory:
        return MaterialPageRoute(builder: (_) => const PaymentHistoryScreen());
      case AppRoutes.receipt:
        final payment = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ReceiptScreen(payment: payment),
        );

      // Support Routes
      case AppRoutes.chatSupport:
        return MaterialPageRoute(builder: (_) => const ChatSupportScreen());
      case AppRoutes.faq:
        return MaterialPageRoute(builder: (_) => const FaqScreen());
      case AppRoutes.terms:
        return MaterialPageRoute(builder: (_) => const TermsScreen());
      case AppRoutes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      case AppRoutes.reportIssue:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());

      // Deliverer Routes
      case AppRoutes.delivererHome:
        return MaterialPageRoute(builder: (_) => DelivererHomeScreen());
      case AppRoutes.deliveryDetail:
        final delivery = settings.arguments as Delivery;
        return MaterialPageRoute(
          builder: (_) => DeliveryDetailScreen(delivery: delivery),
        );
      case AppRoutes.deliveryHistory:
        return MaterialPageRoute(builder: (_) => const DeliveryHistoryScreen());
      case AppRoutes.earnings:
        return MaterialPageRoute(builder: (_) => const EarningsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} not found'),
            ),
          ),
        );
    }
  }
}
