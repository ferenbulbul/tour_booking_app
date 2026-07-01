import 'package:easy_localization/easy_localization.dart';
import 'package:tour_booking/core/base/base_viewmodel.dart';
import 'package:tour_booking/models/customer_info_for_driver/customer_info.dart';
import 'package:tour_booking/services/driver/driver_service.dart';

class DriverHomeViewModel extends BaseViewModel {
  final DriverService _driverService;

  DriverHomeViewModel(this._driverService);

  bool isLoading = false;
  String? error;
  bool isStartingTour = false;
  String? startError;
  bool isCompletingDropoff = false;
  String? dropoffError;
  String? activeTourBookingId;

  bool get hasActiveTour => activeTourBookingId != null;

  List<CustomerInfo> customerList = [];

  void endTour() {
    activeTourBookingId = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final response = await _driverService.getCustomerInfo();

      if (response.isSuccess == true && response.data != null) {
        customerList = response.data!.customerInfo;

        // Backend "Started" durumundaki booking'i kaynak kabul et:
        // uygulama yeniden açıldığında aktif tur durumunu geri yükler,
        // başka yerden tamamlanmışsa temizler.
        final started = customerList.where((c) => c.isStarted).toList();
        activeTourBookingId =
            started.isNotEmpty ? started.first.bookingId : null;
      } else {
        error = response.message ?? tr('error_data_fetch_failed');
      }
    } catch (e) {
      error = tr('error_something_went_wrong', namedArgs: {'error': e.toString()});
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Sürücü turu/transferi başlatır (backend'e işler, sonra aktif kabul eder).
  Future<bool> startTour(String bookingId) async {
    isStartingTour = true;
    startError = null;
    notifyListeners();

    try {
      final resp = await _driverService.startBooking(bookingId);

      if (resp.isSuccess == true) {
        activeTourBookingId = bookingId;
        return true;
      } else {
        startError = resp.message ?? tr('error_generic');
        return false;
      }
    } catch (e) {
      startError = tr('error_generic');
      return false;
    } finally {
      isStartingTour = false;
      notifyListeners();
    }
  }

  /// Sürücü turu/transferi tamamlar (tip-bağımsız birleşik endpoint).
  Future<bool> completeDropoff(String bookingId) async {
    isCompletingDropoff = true;
    dropoffError = null;
    notifyListeners();

    try {
      final resp = await _driverService.completeBooking(bookingId);

      if (resp.isSuccess == true) {
        // Yalnızca tamamlanan iş aktif tursa temizle (geçmiş iş tamamlamada
        // başka bir aktif turu bozmamak için). refresh zaten isStarted'a göre
        // aktif tur durumunu yeniden hesaplar.
        if (activeTourBookingId == bookingId) {
          activeTourBookingId = null;
        }
        await refresh();
        return true;
      } else {
        dropoffError = resp.message ?? tr('error_generic');
        return false;
      }
    } catch (e) {
      dropoffError = tr('error_generic');
      return false;
    } finally {
      isCompletingDropoff = false;
      notifyListeners();
    }
  }
}
