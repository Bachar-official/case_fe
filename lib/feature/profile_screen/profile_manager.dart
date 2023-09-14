import 'package:case_fe/data/repository/token_repo.dart';
import 'package:case_fe/domain/entity/permission.dart';
import 'package:case_fe/feature/apps_screen/apps_manager.dart';

class ProfileManager {
  final TokenRepo tokenRepo;
  final AppsManager appsManager;

  ProfileManager({required this.tokenRepo, required this.appsManager});

  bool get isAuthorized => tokenRepo.token.isNotEmpty;
  bool get canManageUsers => tokenRepo.permission?.canManageUsers ?? false;

  void clearToken() => appsManager.clearToken();
}
