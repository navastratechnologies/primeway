import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:primewayskills_app/view/auth_screens/loginHomeScreen.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/affiliate_course_screen.dart';
import 'package:primewayskills_app/view/dashboard/dashboard.dart';
import 'package:primewayskills_app/view/splash_screen/splash_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'loginScreen',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginHomeScreen();
          },
        ),
        GoRoute(
          path: 'homeScreen',
          builder: (BuildContext context, GoRouterState state) {
            return const Dashboard();
          },
        ),
        GoRoute(
          path: 'affiliateCourseScreen/:courseId/:userId',
          builder: (BuildContext context, GoRouterState state) {
            return AffiliateCourseDetailScreen(
              courseId: state.params["courseId"]!,
              userNumber: state.params["userId"]!,
            );
          },
        ),
      ],
    ),
  ],
);
