import 'package:app/core/session/session_controller.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:app/domain/core/failure.dart';
import 'package:app/domain/core/result.dart';
import 'package:app/domain/entities/product.dart';
import 'package:app/domain/usecases/follow_producer.dart';
import 'package:app/domain/usecases/get_current_user.dart';
import 'package:app/domain/usecases/get_producers.dart';
import 'package:app/domain/usecases/get_products.dart';
import 'package:app/domain/usecases/get_user.dart';
import 'package:app/domain/usecases/sign_out.dart';
import 'package:app/domain/usecases/unfollow_producer.dart';
import 'package:app/presentation/home/controllers/home_controller.dart';
import 'package:app/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import '../helpers/fake_repositories.dart';
import '../helpers/samples.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  void putController({
    required Result<List<Product>> products,
    bool producersFailure = false,
    Duration producersDelay = Duration.zero,
  }) {
    final productRepo = FakeProductRepository()..getProductsResult = products;
    final producerRepo = FakeProducerRepository()
      ..delay = producersDelay
      ..getProducersResult = producersFailure
          ? failure(const NetworkFailure())
          : success([Samples.producer()]);
    Get.put<HomeController>(HomeController(
      GetProducts(productRepo),
      GetProducers(producerRepo),
    ));

    // HomeAppHeader reads identity from the session, so the page needs one
    // registered even when nobody is signed in (anonymous → greets generically).
    final authRepo = FakeAuthRepository()..currentUserResult = success(null);
    final userRepo = FakeUserRepository();
    Get.put<SessionController>(SessionController(
      GetCurrentUser(authRepo),
      GetUser(userRepo),
      SignOut(authRepo),
      FollowProducer(userRepo),
      UnfollowProducer(userRepo),
    ));
  }

  Widget wrap() =>
      GetMaterialApp(theme: AppTheme.light, home: const HomePage());

  testWidgets('shows the loading state then an empty state', (tester) async {
    putController(
      products: success(const []),
      producersDelay: const Duration(milliseconds: 200),
    );

    await tester.pumpWidget(wrap());
    await tester.pump(); // first frame: still loading
    expect(find.text('Carregando catálogo…'), findsOneWidget);

    await tester.pumpAndSettle(); // load resolves to an empty catalog
    expect(find.text('Nada por aqui ainda'), findsOneWidget);
  });

  testWidgets('shows an error state with retry when loading fails',
      (tester) async {
    putController(products: success(const []), producersFailure: true);

    await tester.pumpWidget(wrap());
    await tester.pumpAndSettle();

    expect(find.text('Não foi possível carregar'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
