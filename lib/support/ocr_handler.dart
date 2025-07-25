import 'package:flutter/material.dart';
import 'package:saas_mlkit/saas_mlkit.dart';

class OCRHandler {
  String nik = '';
  String name = '';
  String tempatLahir = '';
  String tglLahir = '';
  String jenisKelamin = '';
  String alamatFull = '';
  String alamat = '';
  String rt = '';
  String rw = '';
  String rtrw = '';
  String kelDesa = '';
  String kecamatan = '';
  String agama = '';
  String statusKawin = '';
  String pekerjaan = '';
  String kewarganegaraan = '';
  String golonganDarah = '';
  String kota = '';
  String provinsi = '';
  String profession = '';
  String expired = '';

  String normalizeNikText(String text) {
    String result = text.toUpperCase();

    result = result.replaceAll('NIK', '').replaceAll(':', '').trim();

    return result;
  }

  String normalizeTglLahir(String text) {
    String result = text.toUpperCase();

    result = result..replaceAll('TEMPAT/TGL LAHIR', '').replaceAll('LAHIR', '').replaceAll('TEMPAT', '').replaceAll(':', '').replaceAll('/', '').replaceAll('TGL ', '').trim();

    return result;
  }

  String normalizeRtRw(String text) {
    String result = text;
    // print('ISI DARI SIH RT RW=$text');
    result = result
        .replaceAll(' RT/RW', '')
        .replaceAll(' RT/RW ', '')
        .replaceAll('RT', '')
        .replaceAll('RW', '')
        .replaceAll(':', '')
        .replaceAll('/', '')
        .replaceAll('RTT ', '')
        .replaceAll('T ', '')
        .replaceAll('W ', '')
        .trim();
    // print('ISI DARI SIH RT RW result=$result');

    return result;
  }

  String normalizeKelurahan(String text) {
    String result = text.toUpperCase();

    result = result
        .replaceAll('KEL/DESA', '')
        .replaceAll('KEL', '')
        .replaceAll('DES', '')
        .replaceAll(' :', '')
        .replaceAll(':', '')
        .replaceAll('/', '')
        .replaceAll('EL ', '')
        .replaceAll(' ', '')
        .replaceAll('SA ', '')
        .trim();

    return result;
  }

  String normalizeKecamatan(String text) {
    String result = text.toUpperCase();

    result =
        result.replaceAll('KECAMATAN', '').replaceAll('CA', '').replaceAll('TAN ', '').replaceAll(':', '').replaceAll('/', '').replaceAll('KRE ', '').replaceAll('T ', '').replaceAll('N ', '').trim();

    return result;
  }

  String normalizeNamaText(String text) {
    String result = text.toUpperCase();

    result = result.replaceAll('NEMA', '').replaceAll('NAME', '').replaceAll(':', '').trim();

    return result;
  }

  String normalizeLahirText(String text) {
    String result = text.toUpperCase();

    result = result
        .replaceAll('GLAHIR', '')
        .replaceAll('LAHIR', '')
        .replaceAll('/TGL', '')
        .replaceAll('/TL', '')
        .replaceAll('TL', '')
        .replaceAll('TMPT', '')
        .replaceAll('TPT', '')
        .replaceAll('TEMPAT', '')
        .replaceAll(',', '')
        .replaceAll(' :', '')
        .replaceAll(': ', '')
        .trim();

    return result;
  }

  String normalizeJenisKelaminText(String text) {
    String result = text.toUpperCase();

    result = result
        .replaceAll('GOL. DARAHO', '')
        .replaceAll('GOL. DARAH', '')
        .replaceAll('GOL DARAH', '')
        .replaceAll('LAKFEARI', '')
        .replaceAll('LAKFLAK', '')
        .replaceAll('KELAMIN', '')
        .replaceAll('KEIAMIN', '')
        .replaceAll('JENIS', '')
        .replaceAll('DENIS', '')
        .replaceAll('DARAH ', '')
        .replaceAll('ENIS', '')
        .replaceAll('DARA', '')
        .replaceAll('GO', '')
        .replaceAll('L. ', '')
        .replaceAll(' H0', '')
        .replaceAll(' HO', '')
        .replaceAll(':', '')
        .replaceAll(' :', '')
        .replaceAll(' 0', '')
        .replaceAll(' O', '')
        .trim();

    if (result.contains('LAK-LAK') ||
        result == 'LAKI-LAK' ||
        result == 'AK-LAK' ||
        result == 'LAKFLAKI' ||
        result == 'LAKHLAK' ||
        result == 'LAKFEAKI' ||
        result == 'LAKELAKI' ||
        result == 'LAKELAK' ||
        result == 'LAKHLAKI' ||
        result == 'LAKHEAK' ||
        result == 'LAK-LAKI' ||
        result == 'LAKHEAKI' ||
        result == 'LAKIFEAK' ||
        result == 'LAKFEAKE' ||
        result == 'LAKIFEAKI' ||
        result == 'LAKFEAR' ||
        result == 'LAKFLAK' ||
        result == 'LAK-LAKE' ||
        result == 'LAK-EAK' ||
        result.contains('LA') ||
        result == 'LAK-EAKI' ||
        result.contains('L') ||
        result == 'LAKELAKE') {
      return 'Laki-Laki';
    }
    if (result == 'PEREM' ||
        result == 'PUAN' ||
        result == 'PER' ||
        result == 'PERU' ||
        result == 'PU' ||
        result == 'PERI' ||
        result == 'PERA' ||
        result == 'RE' ||
        result == 'PEREH' ||
        result == 'PRH' ||
        result == 'PRHA' ||
        result == 'PHUAN' ||
        result == 'EREM' ||
        result == 'REHN' ||
        result == 'MPUAN' ||
        result.contains('P') ||
        result.contains('PE') ||
        result == 'PEA' ||
        result == 'PERHUAN' ||
        result == 'PRUMPAN' ||
        result == 'EMPUAN' ||
        result == 'RUMPUAN' ||
        result == 'HAMPUAN' ||
        result == 'REMPUN') {
      return 'Perempuan';
    }

    return result;
  }

  String normalizeAlamatText(String text) {
    String result = text.toUpperCase();

    result = result
        .replaceAll('RI/KEILDESAA', '')
        .replaceAll('RTKELIIDESAA', '')
        .replaceAll('TIKEL/LDESA', '')
        .replaceAll('RTKEL/DESAA', '')
        .replaceAll('RTKELVDESA', '')
        .replaceAll('RIKELBESAA', '')
        .replaceAll('KECAMATAN', '')
        .replaceAll('KEL/DESSA', '')
        .replaceAll('KELIDESAA', '')
        .replaceAll('KELI/DESA', '')
        .replaceAll('KELILDESA', '')
        .replaceAll('KELIIDESA', '')
        .replaceAll('KELILDESA', '')
        .replaceAll('KEL/ DESA', '')
        .replaceAll('KELLIDESA', '')
        .replaceAll('KECAMATDN', '')
        .replaceAll('HECAMATAN', '')
        .replaceAll('KEILIBESA', '')
        .replaceAll('KELILBESA', '')
        .replaceAll('NECAMATAN', '')
        .replaceAll('KELL/DESA', '')
        .replaceAll('KEL/DESAA', '')
        .replaceAll('KELLDESAA', '')
        .replaceAll('KEL/DESA', '')
        .replaceAll('KELLIBES', '')
        .replaceAll('KEI/DESA', '')
        .replaceAll('HELLDESA', '')
        .replaceAll('KELIBESA', '')
        .replaceAll('KELLBESA', '')
        .replaceAll('KEL/DESA', '')
        .replaceAll('KELLDESA', '')
        .replaceAll('KEILDESA', '')
        .replaceAll('KEILBESA', '')
        .replaceAll('KELIDESA', '')
        .replaceAll('KEVDESA', '')
        .replaceAll('KEVBESA', '')
        .replaceAll('KELBESA', '')
        .replaceAll('KE/DESA', '')
        .replaceAll('ELLDESA', '')
        .replaceAll('KELDESA', '')
        .replaceAll('ALAMAT', '')
        .replaceAll('LAMAT', '')
        .replaceAll('RTIRW', '')
        .replaceAll('RT/RW', '')
        .replaceAll('ELDESA', '')
        .replaceAll('KEVDES', '')
        .replaceAll('RTIRWN', '')
        .replaceAll(' TIA ', ' ')
        .replaceAll('RT ', '')
        .replaceAll('RT/ ', '')
        .replaceAll('RW ', '')
        .replaceAll(':', '')
        .replaceAll('=', '')
        .replaceAll('  ', ' ')
        .trim();

    // print('result result result result result ' + result);

    return result;
  }

  String normalizeKawinText(String text) {
    String result = text.toUpperCase();

    result = result
        .replaceAll('PERKAWINAN', '')
        .replaceAll('PERKAWINA', '')
        .replaceAll('STATUS', '')
        .replaceAll('TATUS', '')
        .replaceAll('Perkawinar', '')
        .replaceAll('Status Perkawinar', '')
        .replaceAll('STAFUS', '')
        .replaceAll('R ', '')
        .replaceAll('R', '')
        .replaceAll('T ', '')
        .replaceAll(':', '')
        .trim();

    return result;
  }

  String normalizePekerjaanText(String text) {
    String result = text.toUpperCase();

    result = result.replaceAll('PEKERJAAN', '').replaceAll(':', '').trim();

    if (result == 'PELAJARIMAHASISSWA' || result == 'PELAJARIMAHASISWA' || result == 'PELAJARIMAHASISVWA' || result == 'PELAJARMAHASISWA') {
      return 'Pelajar/Mahasiswa';
    }
    return result;
  }

  String normalizeKewarganegaraanText(String text) {
    String result = text.toUpperCase();

    result = result.replaceAll('KEWARGANEGARAAN', '').replaceAll('EUMUR', '').replaceAll('HDUP', '').replaceAll('H ', '').replaceAll('N ', '').replaceAll(':', '').trim();

    return result;
  }

  String? normalizeGolonganDarahText(String text) {
    String bloodType = text;
    if (bloodType.toLowerCase() == "a") {
      return "A";
    } else if (bloodType.toLowerCase() == "b") {
      return "B";
    } else if (bloodType.toLowerCase() == "ab") {
      return "AB";
    } else if (bloodType.toLowerCase() == "o") {
      return "O";
    } else {
      return null;
    }
  }

  String normalizeAgamaText(String text) {
    String result = text.toUpperCase();

    result = result.replaceAll('AGAMA', '').replaceAll(':', '').replaceAll('GAMA', '').trim();

    if (result == 'SLAM' ||
        result == 'AM' ||
        result == 'SLA AM' ||
        result == 'ISLU AM' ||
        result == 'SL LAM' ||
        result == 'ISLAME' ||
        result == 'SLA M' ||
        result == 'ISL AM' ||
        result == 'ISLA AM' ||
        result == 'S AM' ||
        result == 'SLL AM' ||
        result == 'SL AM' ||
        result == 'SE AM' ||
        result == '1SLAM' ||
        result == 'ISLAMM' ||
        result == 'SLA' ||
        result == 'LAM') {
      result = 'Islam';
    }
    // print(result);
    if (result.trim().isEmpty) {
      return '';
    } else {
      return result;
    }
  }

  bool checkNikField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'nik';
  }

  bool checkNamaField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'nama' || text == 'nema' || text == 'name';
  }

  bool checkTglLahirField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'lahir' || text == 'tempat' || text == 'tempatigllahir' || text == 'empatgllahir' || text == 'tempat/tgl';
  }

  bool checkJenisKelaminField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kelamin' || text == 'jenis';
  }

  bool checkAlamatField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'alamat' || text == 'lamat' || text == 'alaahom' || text == 'alama' || text == 'alamao' || text == 'alamarw';
  }

  bool checkRtRwField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'rt/rw' || text == 'rw ' || text == 'rt' || text == 'rtirw';
  }

  bool checkKelDesaField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kel/desa' || text == 'helldesa' || text == 'kelldesa';
  }

  bool checkKecamatanField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kecamatan' || dataText.contains('kecamatan');
  }

  bool checkAgamaField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'agama' || text == 'gama';
  }

  bool checkKawinField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kawin' || text == 'perkawinan' || text == 'perkawinan:';
  }

  bool checkPekerjaanField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kerja' || text == 'pekerjaan';
  }

  bool checkKewarganegaraanField(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'kewarganegaraan' || text == 'negaraan' || text == 'kewarganegaraan:';
  }

  bool checkGolonganDarah(String dataText) {
    final text = dataText.toLowerCase().trim();
    return text == 'darah' || text == 'golong' || text == 'gol' || text == 'dar' || text == 'drah' || text == 'darh';
  }

  bool isInside(Rect? rect, Rect? isInside) {
    if (rect == null) {
      return false;
    }

    if (isInside == null) {
      return false;
    }

    if (rect.center.dy <= isInside.bottom && rect.center.dy >= isInside.top && rect.center.dy >= isInside.right && rect.center.dx <= 650) {
      return true;
    }

    return false;
  }

  bool isInside3Rect({Rect? isThisRect, Rect? isInside, Rect? andAbove}) {
    if (isThisRect == null) {
      return false;
    }

    if (isInside == null) {
      return false;
    }

    if (andAbove == null) {
      return false;
    }

    if (isThisRect.center.dy <= andAbove.top && isThisRect.center.dy >= isInside.top && isThisRect.center.dx >= isInside.left) {
      return true;
    }

    return false;
  }

  String? findNextElement({
    required RecognizedText recognizedText,
    required String key,
  }) {
    String? result;
    if (recognizedText.text.toLowerCase().contains(key.toLowerCase())) {
      // debugPrint('-------------------------$key-------------------------}');
      try {
        var block = recognizedText.blocks.firstWhere(
          (element) => element.text.toLowerCase().contains(key.toLowerCase()),
        );
        var line = block.lines.firstWhere(
          (element) => element.text.toLowerCase().contains(key.toLowerCase()),
        );
        if (line.elements.length > 1) {
          var value = line.elements[1].text;
          // debugPrint('Key: $key');
          // debugPrint('Value: $value');
          result = value;
        }
      } catch (e) {
        return null;
      }
    }
    return result;
  }

  String? findNextLine({
    required RecognizedText recognizedText,
    required String key,
  }) {
    String? result;
    if (recognizedText.text.toLowerCase().contains(key.toLowerCase())) {
      try {
        var block = recognizedText.blocks.firstWhere((element) => element.text.toLowerCase().contains(key.toLowerCase()));
        int indexKey = block.lines.indexWhere((element) => element.text.toLowerCase().contains(key.toLowerCase()));
        // debugPrint('Key: $key');
        // debugPrint("Box 0 : ${block.lines[indexKey].cornerPoints[0].x}, ${block.lines[indexKey].cornerPoints[0].y}");
        // debugPrint("Box 1 : ${block.lines[indexKey].cornerPoints[1].x}, ${block.lines[indexKey].cornerPoints[1].y}");
        // debugPrint("Box 2 : ${block.lines[indexKey].cornerPoints[2].x}, ${block.lines[indexKey].cornerPoints[2].y}");
        // debugPrint("Box 3 : ${block.lines[indexKey].cornerPoints[3].x}, ${block.lines[indexKey].cornerPoints[3].y}");
        double y1 = block.lines[indexKey].cornerPoints[0].y.toDouble();
        double y2 = block.lines[indexKey].cornerPoints[1].y.toDouble();
        double y3 = block.lines[indexKey].cornerPoints[2].y.toDouble();
        double y4 = block.lines[indexKey].cornerPoints[3].y.toDouble();
        for (var block in recognizedText.blocks) {
          for (var line in block.lines) {
            if (!line.text.toLowerCase().contains(key.toLowerCase())) {
              if (isInlineText(y1, line.cornerPoints[0].y.toDouble()) &&
                  isInlineText(y2, line.cornerPoints[1].y.toDouble()) &&
                  isInlineText(y3, line.cornerPoints[2].y.toDouble()) &&
                  isInlineText(y4, line.cornerPoints[3].y.toDouble())) {
                // debugPrint('Value: ${line.text}');
                // debugPrint("Box 0 : ${line.cornerPoints[0].dx}, ${line.cornerPoints[0].dy}");
                // debugPrint("Box 1 : ${line.cornerPoints[1].dx}, ${line.cornerPoints[1].dy}");
                // debugPrint("Box 2 : ${line.cornerPoints[2].dx}, ${line.cornerPoints[2].dy}");
                // debugPrint("Box 3 : ${line.cornerPoints[3].dx}, ${line.cornerPoints[3].dy}");
                result = line.text;
              }
            }
          }
        }
      } catch (e) {
        return null;
      }
    }
    return result;
  }

  String? findEl({
    required RecognizedText recognizedText,
    required String key,
  }) {
    String? result;
    recognizedText.blocks.asMap().forEach((int index, TextBlock el) {
      // debugPrint('index ke-$index | text => ${sourceCam?.blocks[index].text} | length => ${sourceCam?.blocks[index].lines.length}');
      if (el.text.toLowerCase().contains(key.toLowerCase())) {
        if (el.lines.length > 1) {
          result = el.lines[1].text;
        } else {
          if (index != recognizedText.blocks.length) result = recognizedText.blocks[index + 1].text;
        }
      }
      for (var line in el.lines) {
        line;
        // debugPrint('index block => $index | text line => ${line.text}');
      }
    });
    return result;
  }

  bool isInlineText(double y1, double y2) {
    var diff = y1 - y2;
    return diff.abs() < 6;
  }

  // Future<void> recognizedText(String? pickedImage) async {
  Future<KTPData?> recognizedText(RecognizedText recognizedText) async {
    //   var textRecognizer = GoogleMlKit.vision.textRecognizer();
    //   final visionImage = InputImage.fromFilePath(pickedImage);
    // var visionText = await textRecognizer.processImage(visionImage);
    // var textRecognizer = GoogleMlKit.vision.textRecognizer();
    // var textRecognizer = TextRecognizer();
    // final visionImage = InputImage.fromFilePath(pickedImage!);
    // final visionText = await textRecognizer.processImage(visionImage);
    final visionText = recognizedText;

    String nikResult = '';
    String nameResult = '';
    String tempatLahirResult = '';
    String tglLahirResult = '';
    String jenisKelaminResult = '';
    String alamatFullResult = '';
    String alamatResult = '';
    String rtrwResult = '';
    String kelDesaResult = '';
    String kecamatanResult = '';
    String agamaResult = '';
    String statusKawinResult = '';
    String pekerjaanResult = '';
    String kewarganegaraanResult = '';
    String golonganDarahResult = '';
    // String kotaResult = '';
    // String provinsiResult = '';
    // String professionResult = '';
    // String expiredResult = '';

    Rect? nikRect;
    Rect? namaRect;
    Rect? alamatRect;
    Rect? rtrwRect;
    Rect? kelDesaRect;
    Rect? kecamatanRect;
    Rect? jenisKelaminRect;
    Rect? tempatTanggalLahirRect;
    Rect? agamaRect;
    Rect? statusKawinRect;
    Rect? pekerjaanRect;
    Rect? kewarganegaraanRect;
    Rect? golonganDarahRect;

    if (provinsi == '') {
      var result = findNextElement(
        recognizedText: recognizedText,
        key: 'PROVINSI',
      );
      if (result != null) {
        // registerController.docProvince.value = result;
        provinsi = result;
      }
    }
    if (kota == '') {
      var result = findNextElement(
        recognizedText: recognizedText,
        key: 'KOTA',
      );
      if (result != null) {
        // registerController.docCity.value = result;
        kota = result;
      } else {
        result = findEl(
          recognizedText: recognizedText,
          key: 'KOTA',
        );
        kota = result ?? '';
      }
    }
    if (profession == '') {
      var result = findNextElement(
        recognizedText: recognizedText,
        key: 'Pekerjaan',
      );
      if (result != null) {
        // registerController.docProfession!.value = result;
        profession = result;
      } else {
        result = findEl(
          recognizedText: recognizedText,
          key: 'Pekerjaan',
        );
        if (result != null) {
          // registerController.docProfession!.value = result;
          profession = result;
        }
      }
    }
    if (expired == '') {
      var result = findNextLine(
        recognizedText: recognizedText,
        key: 'Berlaku Hingga',
      );
      if (result != null) {
        expired = result;
      }
    }

    try {
      for (int i = 0; i < visionText.blocks.length; i++) {
        for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
          // print('ISI BLOCK TEXT ${visionText.blocks[i].lines[j].text}');

          for (int k = 0; k < visionText.blocks[i].lines[j].elements.length; k++) {
            final data = visionText.blocks[i].lines[j].elements[k];

            // print('b$i l$j e$k ' +
            //     data.text.toLowerCase().trim().replaceAll(' ', '') +
            //     ' ' +
            //     data.boundingBox.center.toString());

            if (checkNikField(data.text)) {
              nikRect = data.boundingBox;
              // print('nik field detected');
            }

            if (checkNamaField(data.text)) {
              namaRect = data.boundingBox;
              // print('nama field detected');
            }

            if (checkTglLahirField(data.text)) {
              tempatTanggalLahirRect = data.boundingBox;
              // print('tempat tgllahir field detected');
            }

            if (checkJenisKelaminField(data.text)) {
              jenisKelaminRect = data.boundingBox;
              // print('jenis kelamin field detected');
            }

            if (checkAlamatField(data.text)) {
              alamatRect = data.boundingBox;
              // print('alamat field detected');
            }

            if (checkRtRwField(data.text)) {
              rtrwRect = data.boundingBox;
              // print('RT/RW field detected');
            }

            if (checkKelDesaField(data.text)) {
              kelDesaRect = data.boundingBox;
              // print('kelurahan / desa field detected');
            }

            if (checkKecamatanField(data.text)) {
              kecamatanRect = data.boundingBox;
              // print('kecamatan field detected');
            }

            if (checkAgamaField(data.text)) {
              agamaRect = data.boundingBox;
              // print('agama field detected');
            }

            if (checkKawinField(data.text)) {
              statusKawinRect = data.boundingBox;
              // print('statusKawin field detected');
            }

            if (checkPekerjaanField(data.text)) {
              pekerjaanRect = data.boundingBox;
              // print('pekerjaan field detected');
            }

            if (checkKewarganegaraanField(data.text)) {
              kewarganegaraanRect = data.boundingBox;
              // print('kewarganegaraan field detected');
            }

            if (checkGolonganDarah(data.text)) {
              golonganDarahRect = data.boundingBox;
              // print('kewarganegaraan field detected');
            }
          }
        }
      }
    } catch (e) {
      debugPrint('error $e');
      throw Exception('iteration failed');
    }

    // print('nik rect ' + nikRect.toString());
    // print('nama rect ' + namaRect.toString());
    // print('alamat rect ' + alamatRect.toString());
    // print('rt rw rect ' + rtrwResult.toString());
    // print('kelDesa rect ' + kelDesaRect.toString());
    // print('kecamatan rect ' + kecamatanRect.toString());
    // print('jenis Kelamin rect ' + jenisKelaminRect.toString());
    // print('tempatTanggalLahir rect ' + tempatTanggalLahirRect.toString());
    // print('agama rect ' + agamaRect.toString());
    // print('statusKawin rect ' + statusKawinRect.toString());
    // print('pekerjaan rect ' + pekerjaanRect.toString());
    // print('kewarganegaraan rect ' + kewarganegaraanRect.toString());

    try {
      for (int i = 0; i < visionText.blocks.length; i++) {
        for (int j = 0; j < visionText.blocks[i].lines.length; j++) {
          final data = visionText.blocks[i].lines[j];
          // print('ISI DARI DATA=====>>>>>> ${data.text}');

          if (isInside(data.boundingBox, nikRect)) {
            nikResult = '$nikResult ${data.text}';
            // print('------ nik');
            // print(nikResult);
          }

          if (isInside(data.boundingBox, namaRect)) {
            if (data.text.toLowerCase() != 'nama') {
              // print('------ name');
              nameResult = ('$nameResult ${data.text}').trim();
              // print(nameResult);
            }
          }

          if (isInside(data.boundingBox, tempatTanggalLahirRect)) {
            final temp = data.text.replaceAll('Tempat/Tgi Lahir', '');
            tempatLahirResult = temp.substring(0, temp.indexOf(',') + 1);
            // print('------ tempat lahir');
            // print(tempatLahirResult);
          }

          if (isInside(data.boundingBox, tempatTanggalLahirRect)) {
            final temp = data.text.replaceAll('Tempat/Tgi Lahir', '');
            final result = temp.substring(0, temp.indexOf(',') + 1);
            // print(result);
            // ignore: unnecessary_null_comparison
            if (result != null && result.isNotEmpty) {
              tglLahirResult = temp.replaceAll(result, '').replaceAll(':', '').trim();
            }

            // print('------ tgllahir');
            // print(tglLahirResult);
          }

          if (isInside(data.boundingBox, jenisKelaminRect)) {
            jenisKelaminResult = '$jenisKelaminResult ${data.text}';
            // print('------ jenis kelamin ');
            // print(rtrwResult);
          }

          if (isInside3Rect(isThisRect: data.boundingBox, isInside: alamatRect, andAbove: agamaRect)) {
            alamatFullResult = '$alamatFullResult ${data.text}';
            // print('------ alamat');
            // print(alamatFullResult);
          }

          if (isInside(data.boundingBox, alamatRect)) {
            alamatResult = '$alamatResult ${data.text}';
            // print('------ alamat  ');
            // print(alamatResult);
          }

          if (isInside(data.boundingBox, rtrwRect)) {
            rtrwResult = '$rtrwResult ${data.text}';
            // print('------ rt rw ');
            // print(rtrwResult);
          }

          if (isInside(data.boundingBox, kelDesaRect)) {
            kelDesaResult = '$kelDesaResult ${data.text}';
            // print('------ keldesa');
            // print(rtrwResult);
          }

          if (isInside(data.boundingBox, kecamatanRect)) {
            kecamatanResult = '$kecamatanResult ${data.text}';
            // print('------ kecamatan');
            // print(rtrwResult);
          }

          if (isInside(data.boundingBox, agamaRect)) {
            // agamaResult = agamaResult + ' ' + data.text;
            // print('------ agama : $agamaResult');
          }

          if (isInside(data.boundingBox, statusKawinRect)) {
            statusKawinResult = '$statusKawinResult ${data.text}';
            // print('------ status kawin result ');
            // print(statusKawinResult);
          }

          if (isInside(data.boundingBox, pekerjaanRect)) {
            pekerjaanResult = '$pekerjaanResult ${data.text}';
            // print('------ status pekerjaan result ');
            // print(pekerjaanResult);
          }

          if (isInside(data.boundingBox, kewarganegaraanRect)) {
            kewarganegaraanResult = '$kewarganegaraanResult ${data.text}';
            // print('------ status kewarganegaraan result ');
            // print(kewarganegaraanResult);
          }

          if (isInside(data.boundingBox, golonganDarahRect)) {
            golonganDarahResult = '$golonganDarahResult ${data.text}';
            // print('------ status golonganDarahResult result ');
            // print(golonganDarahResult);
          }
        }
      }
    } catch (e) {
      debugPrint("error $e");
      throw Exception('iteration failed ');
    }

    // print('result before normalization');
    // print('nik : ' + nikResult.toString());
    // print('nama : ' + nameResult.toString());
    // print('tempatLahir : ' + tempatLahirResult.toString());
    // print('tglLahir : ' + tglLahirResult.toString());
    // print('jenis kelamin : ' + jenisKelaminResult.toString());
    // print('alamat full : ' + alamatFullResult.toString());
    // print('rt rw : ' + rtrwResult.toString());
    // print('kel desa : ' + kelDesaResult.toString());
    // print('kecamatan : ' + kecamatanResult.toString());
    // print('agama : ' + agamaResult.toString());
    // print('status kawin : ' + statusKawinResult.toString());
    // print('kewarganegaraan : ' + kewarganegaraanResult.toString());

    nik = normalizeNikText(nikResult);
    agama = normalizeAgamaText(agamaResult);
    name = normalizeNamaText(nameResult);
    alamatFull = normalizeAlamatText(alamatFullResult);
    jenisKelamin = normalizeJenisKelaminText(jenisKelaminResult);
    statusKawin = normalizeKawinText(statusKawinResult);
    kewarganegaraan = normalizeKewarganegaraanText(kewarganegaraanResult);
    pekerjaan = normalizePekerjaanText(pekerjaanResult);
    tglLahir = normalizeTglLahir(tglLahirResult);
    rtrw = normalizeRtRw(rtrwResult);
    kecamatan = normalizeKecamatan(kecamatanResult);
    kelDesa = normalizeKelurahan(kelDesaResult);
    tempatLahir = normalizeLahirText(tempatLahirResult);
    golonganDarah = normalizeGolonganDarahText(golonganDarahResult) ?? '';

    // print('result after normalization');
    // print('nik \t\t\t: ${nik}');
    // print('agama \t\t: ${agama}');
    // print('name \t\t: ${name}');
    // print('alamatFull \t\t: ${alamatFull}');
    // print('jenisKelamin \t: ${jenisKelamin}');
    // print('statusKawin \t\t: ${statusKawin}');
    // print('kewarganegaraan \t: ${kewarganegaraan}');
    // print('pekerjaan \t\t: ${pekerjaan}');
    // print('tglLahir \t\t: ${tglLahir}');
    // print('rtrw \t\t: ${rtrw}');
    // print('kecamatan \t\t: ${kecamatan}');
    // print('kelDesa \t\t: ${kelDesa}');
    // print('tempatLahir \t\t: ${tempatLahir}');

    return KTPData(
      nik: nik,
      name: name,
      birthPlace: tempatLahir,
      birthDate: tglLahir,
      gender: jenisKelamin,
      bloodType: golonganDarah,
      address: alamatFull,
      rt: rtrw,
      rw: rtrw,
      subDistrict: kelDesa,
      district: kecamatan,
      city: kota,
      province: provinsi,
      religion: agama,
      maritalStatus: statusKawin,
      profession: profession,
      nationality: kewarganegaraan,
      // expired: ,
    );
  }
}
