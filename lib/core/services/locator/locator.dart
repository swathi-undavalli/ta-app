import 'package:get_it/get_it.dart';

import 'feature_locator.dart';

final sl = GetIt.instance;

Future<void> setupLocator() async {
  //! Features
  await setupActivities();
}

/*await setupSocialMedia();*/
