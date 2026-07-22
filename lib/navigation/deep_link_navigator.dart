import 'package:go_router/go_router.dart';

/// Alt menü (shell) sekmeleri — bunlar push edilirse RootScaffold ikinci kez
/// yığına girer ve go_router shell sayfasına sabit key verdiği için Navigator
/// "duplicate page key" assert'i ile çöker; sekmelere go ile geçilmeli.
const Set<String> _shellTabPaths = {
  '/home',
  '/favorite',
  '/transport',
  '/reservations',
  '/profile',
};

/// Uygulama içi deep link'i doğru navigasyon fiiliyle açar:
/// sekme hedefleri go (yığın değişir), detay sayfaları push (geri dönülür).
/// Hedef zaten görüntülenen konumsa hiçbir şey yapmaz.
void openDeepLink(GoRouter router, String location) {
  final path = Uri.parse(location).path;
  if (path.isEmpty || !path.startsWith('/')) return;

  final currentPath = router.routerDelegate.currentConfiguration.uri.path;
  if (path == currentPath) return;

  if (_shellTabPaths.contains(path)) {
    router.go(location);
  } else {
    router.push(location);
  }
}
