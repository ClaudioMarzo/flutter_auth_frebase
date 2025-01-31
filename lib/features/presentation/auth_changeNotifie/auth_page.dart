import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:katyfestascatalog/core/ui/style/color_style.dart';
import 'package:katyfestascatalog/core/ui/style/text_styles.dart';
import 'package:katyfestascatalog/core/helps/notification_change.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:katyfestascatalog/core/ui/custom/circularprogress_custom.dart';
import 'package:katyfestascatalog/features/presentation/auth_changeNotifie/auth_controller.dart';
import 'package:katyfestascatalog/features/presentation/auth_valueNotifie/ui/auth_buttom_custom.dart';
import 'package:katyfestascatalog/features/presentation/auth_valueNotifie/ui/google_buttom_custom.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late AuthController controller;

  @override
  void initState() {
    super.initState();
    controller = context.read<AuthController>();
    controller.addListener(
      () {
        if (controller.inputs == InputState.empty) {
          NotificationCustom.showSnackBar(
            context,
            'Input',
            'E-mail ou senha vazios',
            ColorsCustom.i.red,
            ContentType.failure,
          );
        } else if (controller.inputs == InputState.invalidEmail) {
          NotificationCustom.showSnackBar(
            context,
            'Email',
            'Padrão de e-mail inválido',
            ColorsCustom.i.red,
            ContentType.help,
          );
        } else if (controller.register == RegisterFireBaseState.accountExit) {
          NotificationCustom.showSnackBar(
            context,
            'Duplicidade',
            'Conta de usuário já existe',
            ColorsCustom.i.darkyellow,
            ContentType.help,
          );
        } else if (controller.register == RegisterFireBaseState.error || controller.login == LoginState.infoInvalid || controller.google == RegisterGoogleState.error) {
          NotificationCustom.showSnackBar(
            context,
            'Aviso',
            'Email ou senha inválido.',
            ColorsCustom.i.darkyellow,
            ContentType.help,
          );
        } else if (controller.register == RegisterFireBaseState.success) {
          NotificationCustom.showSnackBar(
            context,
            'Sucesso!',
            'Usuário Cadastrado',
            ColorsCustom.i.green,
            ContentType.success,
          );
        } else if (controller.login == LoginState.error) {
          NotificationCustom.showSnackBar(
            context,
            'Oh!',
            'Erro ao autenticar',
            ColorsCustom.i.black,
            ContentType.help,
          );
        } else if (controller.login == LoginState.success || controller.google == RegisterGoogleState.success) {
          final snackBar = SnackBar(
            backgroundColor: ColorsCustom.i.green,
            behavior: SnackBarBehavior.floating,
            content: AwesomeSnackbarContent(
              title: 'Sucesso',
              message: 'Login autenticado com sucesso',
              contentType: ContentType.success,
            ),
            duration: const Duration(milliseconds: 1500),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then(
            (reason) {
              controller.idleAllState();
              if (reason != SnackBarClosedReason.action) {
                Navigator.of(context).pushReplacementNamed('/home');
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width > 650;
    bool isButtomScreen = MediaQuery.of(context).size.width > 420;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorsCustom.i.black,
                  width: 0.3,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              width: isSmallScreen == true ? MediaQuery.of(context).size.width * 0.53 : MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'KATYFESTAS',
                      textAlign: TextAlign.center,
                      style: TextStyles.i.textBold.copyWith(
                        fontSize: 20,
                        color: ColorsCustom.i.black,
                      ),
                    ),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                    ),
                    onChanged: (value) {
                      controller.authRequest = controller.authRequest.copyWith(email: value);
                    },
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                    onChanged: (value) {
                      controller.authRequest = controller.authRequest.copyWith(password: value);
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 1,
                        child: Consumer<AuthController>(
                          builder: (context, controller, child) {
                            return AuthButtonCustom(
                              buttomWidth: isButtomScreen == true ? 142 : 110,
                              buttomHeight: isButtomScreen == true ? 48 : 24,
                              onPressed: controller.login == LoginState.loading ? null : () => controller.loginAccountAction(),
                              loading: controller.login == LoginState.loading
                                  ? const CircularprogressCustom(width: 1.5)
                                  : Text(
                                      textAlign: TextAlign.center,
                                      'ENTRAR',
                                      style: TextStyles.i.textRegular.copyWith(fontSize: isButtomScreen == true ? 14 : 10, color: ColorsCustom.i.white),
                                    ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        flex: 1,
                        child: Consumer<AuthController>(
                          builder: (context, controller, child) {
                            return AuthButtonCustom(
                              buttomWidth: isButtomScreen == true ? 142 : 110,
                              buttomHeight: isButtomScreen == true ? 48 : 24,
                              onPressed: controller.register == RegisterFireBaseState.loading ? null : () => controller.createAccountAction(),
                              loading: controller.register == RegisterFireBaseState.loading
                                  ? const CircularprogressCustom(width: 1.5)
                                  : Text(
                                      textAlign: TextAlign.center,
                                      'CADASTRAR',
                                      style: TextStyles.i.textRegular.copyWith(fontSize: isButtomScreen == true ? 14 : 10, color: ColorsCustom.i.white),
                                    ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.grey, height: 1, thickness: 1, indent: 20, endIndent: 20)),
                        Text('Ou continuar com ',
                            textAlign: TextAlign.center,
                            style: TextStyles.i.textLight.copyWith(
                              fontSize: isButtomScreen ? 14 : 10,
                              color: ColorsCustom.i.black,
                            )),
                        const Expanded(child: Divider(color: Colors.grey, height: 1, thickness: 1, indent: 20, endIndent: 20)),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Consumer<AuthController>(
                      builder: (context, controller, child) {
                        return GoogleButtomCustom(
                          onTap: () => controller.accountGoogleAction(),
                          imagePath: 'assets/images/google.png',
                          heightImage: isButtomScreen == true ? 30 : 20,
                        );
                      },
                    ),
                  ),
                  Text(
                    'Ao prosseguir, você concorda com nossos Termos de Uso e confirma que leu nossa Politicia de Prividade.',
                    textAlign: TextAlign.center,
                    style: TextStyles.i.textLight.copyWith(
                      fontSize: isButtomScreen ? 14 : 10,
                      color: ColorsCustom.i.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
