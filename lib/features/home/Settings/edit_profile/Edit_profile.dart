// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:logisticdriverapp/features/home/Settings/edit_profile/update_profile_controller.dart';
import '../../../../constants/bottom_show.dart';
import '../../../../constants/validation_regx.dart';
import '../../../../export.dart';
import '../get_profile/profile_controller.dart';

export '../../../../common_widgets/cuntom_textfield.dart';
export '../../../../common_widgets/custom_button.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  // FocusNodes
  final nameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final emergencyNameFocus = FocusNode();
  final emergencyPhoneFocus = FocusNode();
  final latitudeFocus = FocusNode();
  final longitudeFocus = FocusNode();

  // Image picker
  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;

  bool isChecked = false;
  bool isDataLoaded = false;

  void checkFields() {
    final isValid =
        nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emergencyNameController.text.isNotEmpty &&
        emergencyPhoneController.text.isNotEmpty &&
        latitudeController.text.isNotEmpty &&
        longitudeController.text.isNotEmpty;

    if (isChecked != isValid) {
      setState(() {
        isChecked = isValid;
      });
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => profileImage = image);
    }
  }

  // Inside _EditProfileScreenState

  Future<void> _updateCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackBar.showError(context, "Please enable location services");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppSnackBar.showError(context, "Location permission denied");
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        AppSnackBar.showError(
          context,
          "Location permissions permanently denied. Enable in settings.",
        );
        await Geolocator.openAppSettings();
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update text fields
      setState(() {
        latitudeController.text = position.latitude.toStringAsFixed(6);
        longitudeController.text = position.longitude.toStringAsFixed(6);
      });

      AppSnackBar.showSuccess(context, "Location updated successfully!");
    } catch (e) {
      AppSnackBar.showError(context, "Error fetching location: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(updateProfileControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (!mounted) return;

          AppSnackBar.showSuccess(context, data?.message ?? "Profile Updated");

          context.go("/profile");
        },
        error: (e, _) {
          if (!mounted) return;

          AppSnackBar.showError(context, e.toString());
        },
      );
    });

    // Add listeners
    nameController.addListener(checkFields);
    phoneController.addListener(checkFields);
    emergencyNameController.addListener(checkFields);
    emergencyPhoneController.addListener(checkFields);
    latitudeController.addListener(checkFields);
    longitudeController.addListener(checkFields);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    nameFocus.dispose();
    phoneFocus.dispose();
    emergencyNameFocus.dispose();
    emergencyPhoneFocus.dispose();
    latitudeFocus.dispose();
    longitudeFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateProfileControllerProvider);
    final profileState = ref.watch(profileControllerProvider);

    return profileState.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (profileResponse) {
        final user = profileResponse.data.user;
        final driver = profileResponse.data.driver;

        // Prefill controllers once
        if (!isDataLoaded && mounted) {
          nameController.text = user.name;
          phoneController.text = user.phone;
          emergencyNameController.text = driver.emergencyContactName;
          emergencyPhoneController.text = driver.emergencyContactPhone;
          latitudeController.text = driver.currentLatitude.toString();
          longitudeController.text = driver.currentLongitude.toString();
          isDataLoaded = true;
        }

        return Scaffold(
          backgroundColor: AppColors.lightGrayBackground,
          appBar: AppBar(
            title: const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            toolbarHeight: 45,
            leading: IconButton(
              onPressed: () => context.go("/profile"),
              icon: const Icon(Icons.arrow_back, size: 18),
            ),
            backgroundColor: AppColors.electricTeal,
            foregroundColor: AppColors.pureWhite,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.pureWhite,
            onPressed: _updateCurrentLocation,
            child: const Icon(Icons.my_location, color: AppColors.electricTeal),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // PROFILE IMAGE
                  // GestureDetector(
                  //   onTap: pickProfileImage,
                  //   child: Stack(
                  //     alignment: Alignment.center,
                  //     children: [
                  //       Container(
                  //         width: 150,
                  //         height: 150,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           border: Border.all(
                  //             color: AppColors.electricTeal,
                  //             width: 2.5,
                  //           ),
                  //           image: profileImage != null
                  //               ? DecorationImage(
                  //                   image: FileImage(File(profileImage!.path)),
                  //                   fit: BoxFit.cover,
                  //                 )
                  //               : null,
                  //           color: profileImage == null
                  //               ? AppColors.electricTeal.withOpacity(.2)
                  //               : null,
                  //         ),
                  //       ),
                  //       if (profileImage == null)
                  //         const Icon(
                  //           Icons.person,
                  //           size: 70,
                  //           color: AppColors.electricTeal,
                  //         ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 25),

                  // NAME
                  CustomAnimatedTextField(
                    controller: nameController,
                    focusNode: nameFocus,
                    labelText: "Full Name",
                    hintText: "Full Name",
                    prefixIcon: Icons.person,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    validator: (v) =>
                        AppValidators.required(v, field: "Full Name"),
                  ),
                  const SizedBox(height: 12),

                  // PHONE
                  CustomAnimatedTextField(
                    controller: phoneController,
                    focusNode: phoneFocus,
                    labelText: "Phone",
                    hintText: "Enter Phone Number",
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.phone_outlined,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    validator: (v) =>
                        AppValidators.numeric(v, field: "Phone Number"),
                  ),
                  const SizedBox(height: 12),

                  // EMERGENCY NAME
                  CustomAnimatedTextField(
                    controller: emergencyNameController,
                    focusNode: emergencyNameFocus,
                    labelText: "Emergency Contact Name",
                    hintText: "Emergency Contact Name",
                    prefixIcon: Icons.person,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    validator: (v) =>
                        AppValidators.required(v, field: "Contact Name"),
                  ),
                  const SizedBox(height: 12),

                  // EMERGENCY PHONE
                  CustomAnimatedTextField(
                    controller: emergencyPhoneController,
                    focusNode: emergencyPhoneFocus,
                    labelText: "Emergency Contact Phone",
                    hintText: "Emergency Contact Phone",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_android,
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    validator: (v) =>
                        AppValidators.numeric(v, field: "Contact Phone"),
                  ),
                  const SizedBox(height: 12),

                  // LATITUDE
                  CustomAnimatedTextField(
                    controller: latitudeController,
                    focusNode: latitudeFocus,
                    labelText: "Latitude",
                    hintText: "Current Latitude",
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    prefixIcon: Icons.my_location,
                  ),
                  const SizedBox(height: 12),

                  // LONGITUDE
                  CustomAnimatedTextField(
                    controller: longitudeController,
                    focusNode: longitudeFocus,
                    labelText: "Longitude",
                    hintText: "Current Longitude",
                    iconColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.mediumGray,
                    prefixIcon: Icons.my_location,
                  ),
                  const SizedBox(height: 20),

                  // UPDATE BUTTON
                  CustomButton(
                    isChecked: isChecked && updateState is! AsyncLoading,
                    backgroundColor: AppColors.electricTeal,
                    borderColor: AppColors.electricTeal,
                    textColor: AppColors.lightGrayBackground,
                    text: updateState is AsyncLoading
                        ? "Updating..."
                        : "Update Profile",
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;

                      await ref
                          .read(updateProfileControllerProvider.notifier)
                          .updateProfile(
                            name: nameController.text,
                            phone: phoneController.text,
                            emergencyName: emergencyNameController.text,
                            emergencyPhone: emergencyPhoneController.text,
                            latitude: latitudeController.text,
                            longitude: longitudeController.text,
                            image: profileImage,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
