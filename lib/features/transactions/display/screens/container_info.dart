import 'dart:io';

import 'package:agunsa/core/router/app_router.dart';
import 'package:agunsa/core/router/routes_provider.dart';
import 'package:agunsa/core/utils/code_utils.dart';
import 'package:agunsa/core/widgets/custom_navigation_bar.dart';
import 'package:agunsa/core/widgets/general_bottom.dart';
import 'package:agunsa/features/transactions/display/providers/transactions_provider.dart';
import 'package:agunsa/features/transactions/display/widgets/transaction_app_bar.dart';
import 'package:agunsa/core/utils/ui_utils.dart';
import 'package:agunsa/features/transactions/domain/entities/photos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ContainerInfo extends ConsumerWidget {
  final Map<String, dynamic>? args;
  const ContainerInfo({
    super.key,
    this.args,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    CodeUtils codeUtils = CodeUtils();
    final isExpanded = ref.watch(expandedContainersProvider
        .select((state) => state['containerInfo'] ?? false));
    final isRegistroFotosExpanded = ref.watch(expandedContainersProvider
        .select((state) => state['registroFotos'] ?? false));
    final isRegistroPrecintExpanded = ref.watch(expandedContainersProvider
        .select((state) => state['registroPrecint'] ?? false));
    final isRegistroPlacaExpanded = ref.watch(expandedContainersProvider
        .select((state) => state['registroPlaca'] ?? false));
    final isRegistroConductorExpanded = ref.watch(expandedContainersProvider
        .select((state) => state['registroConductor'] ?? false));
    final fotoProviderInfo = ref.watch(fotoProvider);
    final precintProviderInfo = ref.watch(precintProvider);
    final placaProviderInfo = ref.watch(placaProvider);
    final conductorProviderInfo = ref.watch(dniProvider);
    final transactionType = ref.watch(transactionTypeSelectedProvider);
    final precintsImage = ref.watch(precintsImageProvider);
    final dniImage = ref.watch(dniImageProvider);
    final placaImage = ref.watch(placaImageProvider);
    final aditionalImges = ref.watch(aditionalImagesProvider);
    final containerImage = ref.watch(containerImageProvider);
    final stepText = codeUtils.getNextStepText(
      aditionalImages: aditionalImges,
      precintsImage: precintsImage,
      placaImage: placaImage,
      dniImage: dniImage,
      isInOut: transactionType?.isInOut ?? false,
      isFromPendingTransaction: ref.watch(isFromPendingTransactionProvider),
    );
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TransactionAppBar(
                uiUtils: uiUtils,
                title: '',
                onTap: () {
                  ref.read(routerDelegateProvider).popRoute();
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _transactionHeader(ref),
                      const SizedBox(height: 20),
                      if (containerImage.isNotEmpty) ...[
                        _animatedSection(
                          title: 'DATOS DEL CONTENEDOR',
                          isExpanded: isExpanded,
                          onTap: () {
                            ref
                                .read(expandedContainersProvider.notifier)
                                .toggle('containerInfo');
                          },
                          content: fotoProviderInfo != null
                              ? _containerInfo(fotoProviderInfo, ref)
                              : Container(),
                        ),
                        if (aditionalImges.isNotEmpty) ...[
                          Divider(color: uiUtils.grayLightColor, thickness: 1),
                        ],
                        _animatedSection(
                          title: 'REGISTRO FOTOGRÁFICO',
                          isExpanded: isRegistroFotosExpanded,
                          onTap: () {
                            ref
                                .read(expandedContainersProvider.notifier)
                                .toggle('registroFotos');
                          },
                          content: _imageGallery(ref,
                              selectedIndexes: aditionalImges, isPlaca: false),
                        ),
                      ],
                      if (precintsImage.isNotEmpty) ...[
                        // Sección de "DATOS PRECINTO" si hay 4 o más imágenes
                        Divider(color: uiUtils.grayLightColor, thickness: 1),
                        _animatedSection(
                            title: 'DATOS PRECINTO',
                            isExpanded: isRegistroPrecintExpanded,
                            onTap: () {
                              ref
                                  .read(expandedContainersProvider.notifier)
                                  .toggle('registroPrecint');
                            },
                            content: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _imageGallery(ref,
                                    selectedIndexes: precintsImage,
                                    isPlaca: false),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                            color: uiUtils.labelColor,
                                            width: 1),
                                        color: uiUtils.labelColor),
                                    child: Text(
                                      'CÓDIGO PRECINTO ADUANA',
                                      style: TextStyle(
                                          color: uiUtils.grayDarkColor,
                                          fontSize: uiUtils.screenWidth * 0.03,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border: Border.all(
                                            color: uiUtils.labelColor,
                                            width: 1),
                                        color: Colors.transparent),
                                    child: Center(
                                      child: Text(
                                        precintProviderInfo?.codPrecinto ?? '',
                                        style: TextStyle(
                                            color: uiUtils.grayLightColor,
                                            fontSize:
                                                uiUtils.screenWidth * 0.03,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ],
                      if (placaImage != null) ...[
                        Divider(color: uiUtils.grayLightColor, thickness: 1),
                        _animatedSection(
                          title: 'DATOS DE LA PLACA',
                          isExpanded: isRegistroPlacaExpanded,
                          onTap: () {
                            ref
                                .read(expandedContainersProvider.notifier)
                                .toggle('registroPlaca');
                          },
                          content: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _imageGallery(ref,
                                  selectedIndexes: [placaImage], isPlaca: true),
                              Expanded(
                                flex: 4,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                          color: uiUtils.labelColor, width: 1),
                                      color: uiUtils.labelColor),
                                  child: Text(
                                    'NUMERO',
                                    style: TextStyle(
                                        color: uiUtils.grayDarkColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  margin: const EdgeInsets.only(left: 0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      border: Border.all(
                                          color: uiUtils.labelColor, width: 1),
                                      color: Colors.transparent),
                                  child: Center(
                                    child: Text(
                                      placaProviderInfo?.codigo ?? '',
                                      style: TextStyle(
                                          color: uiUtils.grayLightColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (dniImage != null) ...[
                        Divider(color: uiUtils.grayLightColor, thickness: 1),
                        _animatedSection(
                          title: 'DATOS DEL CONDUCTOR',
                          isExpanded: isRegistroConductorExpanded,
                          onTap: () {
                            ref
                                .read(expandedContainersProvider.notifier)
                                .toggle('registroConductor');
                          },
                          content: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _imageGallery(ref,
                                  selectedIndexes: [dniImage],
                                  isPlaca: false,
                                  isCond: true),
                              SizedBox(
                                height: uiUtils.screenHeight * 0.1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: uiUtils.labelColor),
                                            child: Center(
                                              child: Text(
                                                'NOMBRES:',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            width: uiUtils.screenWidth * 0.3,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: Colors.transparent),
                                            child: Center(
                                              child: Text(
                                                'Carlos Mario',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: uiUtils.labelColor),
                                            child: Center(
                                              child: Text(
                                                'APELLIDOS:',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            width: uiUtils.screenWidth * 0.3,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: Colors.transparent),
                                            child: Center(
                                              child: Text(
                                                'Sanchez Sanchez',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 0),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: uiUtils.labelColor),
                                            child: Center(
                                              child: Text(
                                                'DNI:           ',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: uiUtils.screenHeight * 0.03,
                                            width: uiUtils.screenWidth * 0.3,
                                            margin:
                                                const EdgeInsets.only(left: 0),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(2),
                                                border: Border.all(
                                                    color: uiUtils.labelColor,
                                                    width: 1),
                                                color: Colors.transparent),
                                            child: Center(
                                              child: Text(
                                                '70074390-9',
                                                style: TextStyle(
                                                    color:
                                                        uiUtils.grayLightColor,
                                                    fontSize:
                                                        uiUtils.screenWidth *
                                                            0.03,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GeneralBottom(
                            width: uiUtils.screenWidth * 0.5,
                            color: uiUtils.primaryColor,
                            text: stepText,
                            onTap: () {
                              codeUtils.handleNextStep(
                                ref: ref,
                                stepText: stepText,
                                args: args,
                              );
                            },
                            textColor: uiUtils.whiteColor,
                            icon: SvgPicture.asset(
                              'assets/svg/camera.svg',
                              color: uiUtils.whiteColor,
                              height: 20,
                              width: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _transactionHeader(WidgetRef ref) {
    final transactionType = ref.watch(transactionTypeSelectedProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: UiUtils().grayDarkColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          child: Row(
            children: [
              Text('TRANSACCION:',
                  style: TextStyle(color: UiUtils().whiteColor)),
              Text(transactionType?.name ?? '',
                  style: TextStyle(color: UiUtils().whiteColor)),
              const SizedBox(width: 15),
              SvgPicture.network(
                transactionType?.imageUrl ?? '',
                color: UiUtils().whiteColor,
                height: 25,
                width: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _animatedSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Transform.rotate(
                  angle: !isExpanded ? -1.5708 : 0,
                  child: SvgPicture.asset(
                    'assets/svg/drop_rigth.svg',
                    color: UiUtils().primaryColor,
                    height: 8,
                    width: 8,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  title,
                  style: TextStyle(
                    color: UiUtils().primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(height: 10),
            content,
          ],
        ],
      ),
    );
  }

  Widget _imageGallery(WidgetRef ref,
      {List<XFile?> selectedIndexes = const [],
      bool? isPlaca = false,
      bool isCond = false}) {
    if (selectedIndexes.isEmpty) return const SizedBox();

    return Row(
      children: selectedIndexes.map<Widget>((index) {
        final image = index;

        return Container(
          margin: const EdgeInsets.only(right: 8),
          height: isPlaca!
              ? UiUtils().screenHeight * 0.05
              : isCond
                  ? UiUtils().screenHeight * 0.1
                  : UiUtils().screenHeight * 0.09,
          width: isPlaca
              ? UiUtils().screenWidth * 0.25
              : isCond
                  ? UiUtils().screenWidth * 0.35
                  : UiUtils().screenWidth * 0.2,
          decoration: BoxDecoration(
            color: UiUtils().labelColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.file(
              File(image?.path ?? ''),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: UiUtils().grayDarkColor),
            ),
          ),
        );
      }).toList(),
    );
  }

  _containerInfo(Foto foto, WidgetRef ref) {
    UiUtils uiUtils = UiUtils();
    final images = ref.watch(containerImageProvider);
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(images.first?.path ?? ''),
              height: 115,
              width: 94,
              errorBuilder: (context, error, stackTrace) => Container(
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
                      foto.numSerie,
                      style: TextStyle(
                        fontSize: 13,
                        color: uiUtils.optionsColor,
                      ),
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
                    label: 'IDENTIFICACIÓN LÍNEA DE TRANSPORTE:',
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      foto.numControl,
                      style: TextStyle(
                        fontSize: 13,
                        color: uiUtils.optionsColor,
                      ),
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
          subLabel: foto.codPropietario,
        ),
        Text(
          'Este código indica que es un contenedor High Cube de 40 pies con altura adicional.',
          style: TextStyle(fontSize: 12, color: uiUtils.optionsColor),
        ),
        const SizedBox(height: 10),
        LabelInfo2(
          uiUtils: uiUtils,
          label: 'TIPO DE CONTENEDOR:',
          subLabel: foto.tipoContenedor,
        ),
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
              Text(
                'TARA',
                style: TextStyle(
                    fontSize: 13,
                    color: uiUtils.grayDarkColor,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '(PESO VACIO DEL CONTENEDOR)',
                style: TextStyle(
                    fontSize: uiUtils.screenWidth * 0.028,
                    color: uiUtils.grayDarkColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          label: '',
          subLabel: '${foto.taraKg} KG',
        ),
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
              Text(
                'PLAYLOAD',
                style: TextStyle(
                    fontSize: 13,
                    color: uiUtils.grayDarkColor,
                    fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '(PESO NETO QUE PUEDE CARGAR)',
                style: TextStyle(
                    fontSize: uiUtils.screenWidth * 0.025,
                    color: uiUtils.grayDarkColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          label: '',
          subLabel: '${foto.payloadKg} KG',
        ),
        const SizedBox(height: 20),
      ],
    );
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
                      fontWeight: FontWeight.bold),
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
                    fontWeight: FontWeight.bold),
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
            fontSize: uiUtils.screenWidth * 0.025,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
