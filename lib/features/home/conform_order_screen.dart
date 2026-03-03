import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logisticdriverapp/constants/bottom_show.dart';
import '../../export.dart';

class ConformOrderScreen extends StatefulWidget {
  const ConformOrderScreen({super.key});

  @override
  State<ConformOrderScreen> createState() => _ConformOrderScreenState();
}

class _ConformOrderScreenState extends State<ConformOrderScreen> {
  TextEditingController otpController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  bool showConfirmDropdown = false;
  bool arrived = false;
  bool hasPhoto = false; // placeholder flag for photo picked
  bool hasSignature = false;
  bool _isOtpFilled = false;
  bool isUndelivered = false;

  // simple in-memory signature points for the lightweight signature pad
  List<Offset> _signaturePoints = [];
  final GlobalKey _signatureAreaKey = GlobalKey();

  List<String> codes = ["FMPMP81935329", "FMPMP81935329"];
  List<bool> selected = [false, false];

  @override
  void dispose() {
    otpController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color blueColor = AppColors.electricTeal;

    return Scaffold(
      backgroundColor: AppColors.lightGrayBackground,
      appBar: AppBar(
        title: const Text(
          "Delevery Confirmation",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 45,
        leading: IconButton(
          onPressed: () => context.go("/order-details"),
          icon: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        backgroundColor: blueColor,
        foregroundColor: AppColors.pureWhite,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HOW TO GET OTP CARD (unchanged)
              Container(
                width: double.infinity, // <-- FULL WIDTH
                child: Card(
                  color: AppColors.pureWhite,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.lightBorder, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          txt: "How to get OTP?",
                          color: blueColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 10),
                        CustomText(
                          txt: "1. Ask Customer to open App / Website",
                          fontSize: 16,
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          txt: "2. Go to My Orders > Order Details",
                          fontSize: 16,
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          txt: "3. OTP shown on Order Details screen",
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ORDER / ARRIVED ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_2, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Delivery #12345",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Arrived at location"),
                      SizedBox(width: 8),
                      customToggleSwitch(),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ENTER OTP title
              const Text(
                "Enter Customer OTP",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),

              // OTP input (PinCodeTextField)
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: otpController,
                obscureText: false,
                animationType: AnimationType.fade,
                keyboardType: TextInputType.number,
                autoDismissKeyboard: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  inactiveColor: AppColors.electricTeal,
                  selectedColor: AppColors.electricTeal,
                  activeColor: AppColors.electricTeal,
                  activeFillColor: AppColors.pureWhite,
                  inactiveFillColor: AppColors.pureWhite,
                  selectedFillColor: AppColors.pureWhite,
                  borderWidth: 1.5,
                ),
                animationDuration: const Duration(milliseconds: 200),
                enableActiveFill: true,
                onChanged: (value) {
                  setState(() {
                    _isOtpFilled = value.length == 6;
                  });
                },
              ),

              const SizedBox(height: 8),
              // Resend & sample codes (kept small)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // TODO: call resend OTP API
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('OTP resent')),
                      // );

                      AppSnackBar.showError(context, "OTP resent");
                    },
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "Sample Codes",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Sample codes list (optional)
              ...List.generate(codes.length, (i) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.pureWhite,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.lightBorder, width: 2),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => selected[i] = !selected[i]),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: selected[i]
                                ? blueColor
                                : AppColors.pureWhite,
                            border: Border.all(color: blueColor, width: 2),
                          ),
                          child: selected[i]
                              ? const Icon(
                                  Icons.check,
                                  size: 22,
                                  color: AppColors.pureWhite,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          codes[i],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: blueColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 12),

              // Take Photo (optional)
              Text(
                "Take Photo (Optional)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder, width: 2),
                ),
                child: hasPhoto
                    ? Stack(
                        children: [
                          // placeholder for shown photo; in practice show Image.file()
                          const Center(
                            child: Icon(
                              Icons.image,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => setState(() => hasPhoto = false),
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: TextButton.icon(
                          style: ButtonStyle(
                            foregroundColor: WidgetStatePropertyAll(
                              AppColors.electricTeal,
                            ),
                          ),
                          onPressed: () {
                            setState(() => hasPhoto = true);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   const SnackBar(
                            //     content: Text("Photo added (simulated)"),
                            //   ),
                            // );

                            AppSnackBar.showError(
                              context,
                              "Photo added (simulated)",
                            );
                          },
                          icon: const Icon(Icons.camera_alt),
                          label: const Text("Add Photo"),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // Delivery Notes (optional)
              Text(
                "Delivery Notes (Optional)",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder, width: 2),
                ),
                child: TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add notes...",
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Signature section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Customer Signature",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () => _showSignaturePad(context),
                    child: Text(
                      hasSignature ? "View / Edit" : "Add Signature",
                      style: TextStyle(color: blueColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Signature small preview
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder, width: 2),
                ),
                child: hasSignature
                    ? CustomPaint(
                        size: const Size(double.infinity, 80),
                        painter: _SignaturePreviewPainter(
                          points: _signaturePoints,
                        ),
                      )
                    : Center(
                        child: Text(
                          "No signature provided",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // ENTER OTP -> show confirm dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: CustomButton(
                  text: "Delevery Complete",
                  backgroundColor: _isOtpFilled
                      ? blueColor
                      : AppColors.pureWhite,
                  borderColor: blueColor,
                  textColor: _isOtpFilled ? AppColors.pureWhite : blueColor,
                  onPressed: _isOtpFilled
                      ? () {
                          context.go("/home");
                        }
                      : null,
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  // YOUR CUSTOM SWITCH
  Widget customToggleSwitch() {
    const Color blueColor = AppColors.electricTeal;
    return Container(
      width: 60,
      height: 25,
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isUndelivered = false;
                arrived = false;
              }),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: !isUndelivered ? blueColor : AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "OFF",
                  style: TextStyle(
                    fontSize: 12,
                    color: !isUndelivered ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() {
                isUndelivered = true;
                arrived = true;
              }),

              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: isUndelivered ? blueColor : AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: Text(
                  "ON",
                  style: TextStyle(
                    fontSize: 12,
                    color: isUndelivered ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // show a dialog with a lightweight signature pad
  void _showSignaturePad(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Capture Signature"),
              content: SizedBox(
                width: double.maxFinite,
                height: 260,
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final box =
                              _signatureAreaKey.currentContext!
                                      .findRenderObject()
                                  as RenderBox;

                          final localPoint = box.globalToLocal(
                            details.globalPosition,
                          );

                          setStateDialog(() {
                            _signaturePoints.add(localPoint);
                          });
                        },
                        onPanEnd: (_) => setStateDialog(() {}),
                        child: Container(
                          key: _signatureAreaKey,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.lightBorder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: CustomPaint(
                            painter: _SignaturePainter(
                              points: _signaturePoints,
                            ),
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setStateDialog(() {
                              _signaturePoints.clear();
                            });
                          },
                          child: const Text("Clear"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasSignature = _signaturePoints.isNotEmpty;
                            });
                            context.pop(ctx);
                          },
                          child: const Text("Save"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (points.length < 2) return;

    Path path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      Offset p1 = points[i];
      Offset p2 = points[i + 1];

      final midPoint = Offset((p1.dx + p2.dx) / 2, (p1.dy + p2.dy) / 2);

      path.quadraticBezierTo(p1.dx, p1.dy, midPoint.dx, midPoint.dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

class _SignaturePreviewPainter extends CustomPainter {
  final List<Offset> points;

  _SignaturePreviewPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double minX = points.first.dx;
    double maxX = points.first.dx;
    double minY = points.first.dy;
    double maxY = points.first.dy;

    for (var p in points) {
      minX = p.dx < minX ? p.dx : minX;
      maxX = p.dx > maxX ? p.dx : maxX;
      minY = p.dy < minY ? p.dy : minY;
      maxY = p.dy > maxY ? p.dy : maxY;
    }

    double width = maxX - minX;
    double height = maxY - minY;

    double scaleX = size.width / width;
    double scaleY = size.height / height;
    double scale = (scaleX < scaleY ? scaleX : scaleY) * 0.90;

    // CENTER OFFSET
    double offsetX = (size.width - width * scale) / 2;
    double offsetY = (size.height - height * scale) / 2;

    Path path = Path();
    bool first = true;

    for (var p in points) {
      final scaled = Offset(
        offsetX + (p.dx - minX) * scale,
        offsetY + (p.dy - minY) * scale,
      );

      if (first) {
        path.moveTo(scaled.dx, scaled.dy);
        first = false;
      } else {
        path.lineTo(scaled.dx, scaled.dy);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}
