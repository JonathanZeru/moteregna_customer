import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:get/get.dart';
import 'package:gibe_market/views/home/widget/snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gibe_market/controllers/motorist_controller.dart';

class OnlineSwitch extends StatefulWidget {
  const OnlineSwitch({super.key});

  @override
  State<OnlineSwitch> createState() => _OnlineSwitchState();
}

class _OnlineSwitchState extends State<OnlineSwitch> {
  late final ValueNotifier<bool> _controller;
  final MotoristController _motoristController = Get.find<MotoristController>();
  
  @override
  void initState() {
    super.initState();
    _controller = ValueNotifier<bool>(_motoristController.isOnline);
    _controller.addListener(_handleSwitchChange);
  }
  
  @override
  void dispose() {
    _controller.removeListener(_handleSwitchChange);
    _controller.dispose();
    super.dispose();
  }
  
  void _handleSwitchChange() async {
    if(_motoristController.delivering.value == false){
    if (!_motoristController.isUpdatingOnlineStatus.value && 
        _controller.value != _motoristController.isOnline) {
      final success = await _motoristController.updateOnlineStatus(_controller.value);
      
      if (!success) {
        // Revert the switch if the update failed
        _controller.value = _motoristController.isOnline;
      }
      
      HapticFeedback.lightImpact();
    }
    }else{
showCyberSnackBar(
      context,
      'delivery_finish_api_error'.tr,
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Obx(() {
      // Sync controller value with motorist data
      if (!_motoristController.isUpdatingOnlineStatus.value && 
          _controller.value != _motoristController.isOnline) {
        _controller.value = _motoristController.isOnline;
      }
      
      final isLoading = _motoristController.isUpdatingOnlineStatus.value;
      
      return Tooltip(
        message: _controller.value ? "online_message".tr : "offline_message".tr,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _controller.value
                  ? theme.colorScheme.tertiary.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              isLoading ?
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _controller.value
                        ? theme.colorScheme.tertiary
                        : Colors.grey,
                  ),
                )
            :
                Text(
                  _controller.value ? "online".tr : "offline".tr,
                  style: GoogleFonts.orbitron(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _controller.value
                        ? theme.colorScheme.tertiary
                        : Colors.grey,
                  ),
                ),
              const SizedBox(width: 5),
              Opacity(
                opacity: isLoading ? 0.5 : 1.0,
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: AdvancedSwitch(
                    controller: _controller,
                    activeColor: theme.colorScheme.tertiary,
                    inactiveColor: Colors.grey,
                    width: 40,
                    height: 20,
                    borderRadius: BorderRadius.circular(10),
                ),
              ),
              )
            ],
          ),
        ),
      );
    });
  }
}