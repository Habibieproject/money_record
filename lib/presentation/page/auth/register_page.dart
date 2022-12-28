import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_record/config/app_asset.dart';
import 'package:money_record/config/app_color.dart';
import 'package:money_record/data/source/source_user.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final formkey = GlobalKey<FormState>();
  register() async {
    if (formkey.currentState!.validate()) {
      await SourceUser.register(context, controllerName.text,
          controllerEmail.text, controllerPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kColorBackground,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DView.nothing(),
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Image.asset(AppAsset.logo),
                          DView.spaceHeight(),
                          TextFormField(
                            controller: controllerName,
                            validator: (value) =>
                                value == '' ? 'Jangan Kosong' : null,
                            style: const TextStyle(color: Colors.white),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                fillColor:
                                    AppColor.kColorPrimary.withOpacity(0.5),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                hintText: "name",
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16)),
                          ),
                          DView.spaceHeight(),
                          TextFormField(
                            controller: controllerEmail,
                            validator: (value) =>
                                value == '' ? 'Jangan Kosong' : null,
                            style: const TextStyle(color: Colors.white),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                fillColor:
                                    AppColor.kColorPrimary.withOpacity(0.5),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                hintText: "email",
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16)),
                          ),
                          DView.spaceHeight(),
                          TextFormField(
                            controller: controllerPassword,
                            validator: (value) =>
                                value == '' ? 'Jangan Kosong' : null,
                            style: const TextStyle(color: Colors.white),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: true,
                            decoration: InputDecoration(
                                fillColor:
                                    AppColor.kColorPrimary.withOpacity(0.5),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none),
                                hintText: "password",
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 16)),
                          ),
                          DView.spaceHeight(30),
                          Material(
                            color: AppColor.kColorPrimary,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: () => register(),
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 16),
                                child: Text(
                                  "REGISTER",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sudah Punya Akun? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: AppColor.kColorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
