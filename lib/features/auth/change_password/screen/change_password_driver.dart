import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:provider/provider.dart';
import 'package:tour_booking/core/theme/app_spacing.dart';
import 'package:tour_booking/core/ui/ui_helper.dart';
import 'package:tour_booking/core/widgets/custom_app_bar.dart';
import 'package:tour_booking/features/auth/change_password/change_password_viewmodel.dart';
import 'package:tour_booking/utils/password_validator.dart';

class ChangePasswordDriverScreen extends StatefulWidget {
  const ChangePasswordDriverScreen({super.key});

  @override
  State<ChangePasswordDriverScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordDriverScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pwdCtrl = TextEditingController();
  final _pwd2Ctrl = TextEditingController();

  bool _ob1 = true;
  bool _ob2 = true;

  String? _pwdValidator(String? v) => PasswordValidator.validate(v);

  String? _confirmValidator(String? v) {
    if ((v ?? '').trim().isEmpty) return 'password_required';
    if (v!.trim() != _pwdCtrl.text.trim()) {
      return 'passwords_do_not_match';
    }
    return null;
  }

  @override
  void dispose() {
    _pwdCtrl.dispose();
    _pwd2Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChangePasswordViewModel(),
      child: Consumer<ChangePasswordViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: CommonAppBar(title: 'reset_password'.tr()),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.l),
                children: [
                  TextFormField(
                    controller: _pwdCtrl,
                    obscureText: _ob1,
                    decoration: InputDecoration(
                      labelText: 'new_password'.tr(),
                      hintText: 'new_password'.tr(),
                      suffixIcon: IconButton(
                        tooltip: 'Toggle password visibility',
                        onPressed: () => setState(() => _ob1 = !_ob1),
                        icon: Icon(
                          _ob1 ? SolarIconsOutline.eye : SolarIconsOutline.eyeClosed,
                          semanticLabel: _ob1 ? 'Hide password' : 'Show password',
                        ),
                      ),
                    ),
                    validator: (v) => _pwdValidator(v)?.tr(),
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.newPassword],
                  ),
                  const SizedBox(height: AppSpacing.m),
                  TextFormField(
                    controller: _pwd2Ctrl,
                    obscureText: _ob2,
                    decoration: InputDecoration(
                      labelText: 'confirm_password'.tr(),
                      suffixIcon: IconButton(
                        tooltip: 'Toggle password visibility',
                        onPressed: () => setState(() => _ob2 = !_ob2),
                        icon: Icon(
                          _ob2 ? SolarIconsOutline.eye : SolarIconsOutline.eyeClosed,
                          semanticLabel: _ob2 ? 'Hide password' : 'Show password',
                        ),
                      ),
                    ),
                    validator: (v) => _confirmValidator(v)?.tr(),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(context, vm),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: vm.isLoading
                          ? null
                          : () => _submit(context, vm),
                      child: vm.isLoading
                          ? const SizedBox(
                              height: AppSpacing.xl,
                              width: AppSpacing.xl,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('update_password'.tr()),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  const _RulesNote(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context, ChangePasswordViewModel vm) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final result = await vm.changePassword(_pwdCtrl.text.trim());
    if (!mounted) return;

    if (result.isSuccess) {
      UIHelper.showSuccess(context, 'password_updated_success'.tr());
      context.go('/driver');
    } else {
      UIHelper.showError(context, vm.message?.tr() ?? 'operation_failed'.tr());
    }
  }
}

class _RulesNote extends StatelessWidget {
  const _RulesNote();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Text(
          '${'password_rules_title'.tr()}\n'
          '${'password_rule_1'.tr()}\n'
          '${'password_rule_2'.tr()}\n'
          '${'password_rule_3'.tr()}\n'
          '${'password_rule_4'.tr()}\n'
          '${'password_rule_5'.tr()}',
        ),
      ),
    );
  }
}
