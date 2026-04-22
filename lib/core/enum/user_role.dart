enum UserRole { customer, driver, guest }

extension UserRoleExtension on UserRole {
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'driver':
        return UserRole.driver;
      case 'guest':
        return UserRole.guest;
      case 'customer':
      default:
        return UserRole.customer;
    }
  }

  bool get isGuest => this == UserRole.guest;
}
