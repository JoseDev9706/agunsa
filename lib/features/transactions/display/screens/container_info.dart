import 'dart:io';

import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ContainerInfo extends ConsumerWidget {
  final Map<String, dynamic>? args;
  const ContainerInfo({
    super.key,
    this.args,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          TransactionAppBar(
            uiUtils: uiUtils,
            title: '',
          ),
          Expanded(
            child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: uiUtils.grayDarkColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                'TRANSACCION:',
                                style: TextStyle(color: uiUtils.whiteColor),
                              ),
                              Text(
                                'DESCARGA',
                                style: TextStyle(color: uiUtils.whiteColor),
                              ),
                              const SizedBox(width: 15),
                              SvgPicture.asset(
                                'assets/svg/descarga.svg',
                                color: uiUtils.whiteColor,
                                height: 20,
                                width: 20,
                              ),
                            ],
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/drop_rigth.svg',
                              color: uiUtils.primaryColor,
                              height: 8,
                              width: 8,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'DATOS DEL CONTENEDOR',
                              style: TextStyle(
                                  color: uiUtils.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.file(
                              File(args?['images'][0].path),
                              height: 115,
                              width: 94,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 94,
                                width: 94,
                                color: uiUtils.grayDarkColor,
                              ),
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  LabelInfoWidget(
                                    isPhotoInfo: true,
                                    uiUtils: uiUtils,
                                    label: 'NUMERO DE CONTENEDOR',
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      'GCXU 577020 45G1',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: uiUtils.optionsColor),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Divider(
                                      color: uiUtils.grayLightColor,
                                      thickness: 1,
                                    ),
                                  ),
                                  LabelInfoWidget(
                                      isPhotoInfo: true,
                                      uiUtils: uiUtils,
                                      label:
                                          'IDENTIFICACIÓN LÍNEA DE TRANSPORTE:'),
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      '45G1',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: uiUtils.optionsColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        LabelInfo2(
                          uiUtils: uiUtils,
                          label: 'CODIGO ISO',
                          subLabel: '45G1',
                        ),
                        Text(
                            'Este código indica que es un contenedor High Cube de 40 pies con altura adicional.',
                            style: TextStyle(
                                fontSize: 12, color: uiUtils.optionsColor)),
                        const SizedBox(height: 10),
                        LabelInfo2(
                            uiUtils: uiUtils,
                            label: 'TIPO DE CONTENEDOR:',
                            subLabel: 'GCXU'),
                        const SizedBox(height: 10),
                        LabelInfo2(
                            uiUtils: uiUtils,
                            labelWidget: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icon-info.svg',
                                  color: uiUtils.grayDarkColor,
                                  height: 12,
                                  width: 12,
                                ),
                                const SizedBox(width: 5),
                                Text('TARA',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: uiUtils.grayDarkColor)),
                                const Spacer(),
                                Text('(PESO VACIO DEL CONTENEDOR)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: uiUtils.grayDarkColor)),
                              ],
                            ),
                            label: '',
                            subLabel: '3.700 KG'),
                        const SizedBox(height: 10),
                        LabelInfo2(
                            uiUtils: uiUtils,
                            labelWidget: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icon-info.svg',
                                  color: uiUtils.grayDarkColor,
                                  height: 12,
                                  width: 12,
                                ),
                                const SizedBox(width: 5),
                                Text('PLAYLOAD',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: uiUtils.grayDarkColor)),
                                const Spacer(),
                                Text('(PESO NETO QUE PUEDE CARGAR)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: uiUtils.grayDarkColor)),
                              ],
                            ),
                            label: '',
                            subLabel: '28.800 KG'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: uiUtils.grayLightColor,
                    thickness: 1,
                  ),
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/drop_rigth.svg',
                              color: uiUtils.primaryColor,
                              height: 8,
                              width: 8,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'REGISTRO FOTOGRÁFICO',
                              style: TextStyle(
                                  color: uiUtils.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ...?args?['images']
                                ?.asMap()
                                .entries
                                .where((entry) =>
                                    entry.key >= 1 && entry.value != null)
                                .map((entry) {
                              return Container(
                                margin: const EdgeInsets.only(right: 8),
                                height: uiUtils.screenHeight * 0.09,
                                width: uiUtils.screenWidth * 0.2,
                                decoration: BoxDecoration(
                                  color: uiUtils.labelColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(
                                    File(entry.value.path),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      color: uiUtils.grayDarkColor,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: uiUtils.grayLightColor,
                    thickness: 1,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GeneralBottom(
                        width: uiUtils.screenWidth * 0.5,
                        color: uiUtils.primaryColor,
                        text: 'CAPTURA PRECINTOS',
                        onTap: () {},
                        textColor: uiUtils.whiteColor,
                        icon: SvgPicture.asset(
                          'assets/svg/camera.svg',
                          color: uiUtils.whiteColor,
                          height: 20,
                          width: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: CustomBottomNavitionBar(uiUtils: uiUtils),
    ));
  }
}

class LabelInfo2 extends StatelessWidget {
  const LabelInfo2({
    super.key,
    required this.uiUtils,
    required this.label,
    required this.subLabel,
    this.labelWidget,
  });

  final UiUtils uiUtils;
  final String label;
  final String subLabel;
  final Widget? labelWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            margin: const EdgeInsets.only(left: 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: uiUtils.labelColor, width: 1),
                color: uiUtils.labelColor),
            child: labelWidget ??
                Text(
                  label,
                  style: TextStyle(
                      color: uiUtils.grayDarkColor,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.only(left: 0),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(color: uiUtils.labelColor, width: 1),
                color: Colors.transparent),
            child: Center(
              child: Text(
                subLabel,
                style: TextStyle(
                    color: uiUtils.grayLightColor,
                    fontSize: 13,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LabelInfoWidget extends StatelessWidget {
  const LabelInfoWidget({
    super.key,
    required this.uiUtils,
    required this.label,
    required this.isPhotoInfo,
  });

  final UiUtils uiUtils;
  final String label;
  final bool isPhotoInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: isPhotoInfo ? 10 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2), color: uiUtils.labelColor),
      child: Text(
        label,
        style: TextStyle(
            color: uiUtils.grayLightColor,
            fontSize: 13,
            fontWeight: FontWeight.normal),
      ),
    );
  }
}
