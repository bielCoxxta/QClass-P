import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:qclass_p/app_routes.dart';
import 'package:qclass_p/constants/config_envs.dart';
import 'package:qclass_p/presentation/pages/splash_page.dart';

import 'domain/entities/environment_entity.dart';
import 'presentation/controllers/init_app_controller.dart';

class AppModule extends Module {
  AppModule({required GlobalConfigs globalConfigs}) {
    _globalConfigs = globalConfigs;
  }
  static late final GlobalConfigs _globalConfigs;

  @override
  void binds(Injector i) {
    //==== Global configs ====
    i.addSingleton<CrashLog>(() => _globalConfigs.crashLog);
    i.addSingleton<EnvironmentEntity>(() => ConfigEnvs.environment);

    // ==== package_info ====
    i.addSingleton<IPackageInfoDriver>(PackageInfoDriver.new);
    i.addSingleton<IPackageInfoService>(PackageInfoService.new);
    i.addSingleton<PackageInfoEntity>(() => _globalConfigs.appInfo);

    //==== Controllers ====
    i.addSingleton<ThemeController>(ThemeController.new);
    i.addSingleton<InitAppController>(InitAppController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(AppRoutes.root.path, child: (context) => const SplashPage());
    r.module(AuthRoutes.root.path, module: AuthModule());
  }
}

/* 
Algumas classes precisam ser instaciadas antes da navegação do módulo,
casa contrário vai tentar pegar uma injeção que ainda não foi injetada
*/
class GlobalConfigs {
  static final GlobalConfigs _singleton = GlobalConfigs._internal();
  factory GlobalConfigs() => _singleton;
  GlobalConfigs._internal();

  //==== log de erros ====
  CrashLog get crashLog => CrashLog();

  // ==== infoAPP ====
  var currentAppInfo = PackageInfoEntity(
    appName: 'QClass',
    name: 'QClass',
    version: 'unknow',
    buildNumber: 0,
    buildSignature: '',
    forceUpdate: false,
  );
  PackageInfoEntity get appInfo => currentAppInfo;

  /// Permission
  // PermissionService get permissionService => PermissionService();
}
