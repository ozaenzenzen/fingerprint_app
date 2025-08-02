class OcrDataHolderModel {
  String? nama;
  String? nik;
  String? tempatLahir;
  String? tanggalLahir;
  String? jenisKelamin;
  String? golonganDarah;
  String? address;
  String? rt;
  String? rw;
  String? kelurahanDesa;
  String? kecamatan;
  String? kota;
  String? provinsi;
  String? agama;
  String? maritalStatus;
  String? pekerjaan;
  String? kewarganegaraan;
  String? berlakuHingga;

  OcrDataHolderModel({
    this.nama,
    this.nik,
    this.tempatLahir,
    this.tanggalLahir,
    this.jenisKelamin,
    this.golonganDarah,
    this.address,
    this.rt,
    this.rw,
    this.kelurahanDesa,
    this.kecamatan,
    this.kota,
    this.provinsi,
    this.agama,
    this.maritalStatus,
    this.pekerjaan,
    this.kewarganegaraan,
    this.berlakuHingga,
  });

  // Convert the model to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'fullName': nama,
      'nik': nik,
      'placeOfBirth': tempatLahir,
      'dateOfBirth': tanggalLahir,
      'gender': jenisKelamin,
      'bloodType': golonganDarah,
      'address': address,
      'rt': rt,
      'rw': rw,
      'kelurahan': kelurahanDesa,
      'kecamatan': kecamatan,
      'city': kota,
      'province': provinsi,
      'religion': agama,
      'maritalStatus': maritalStatus,
      'occupation': pekerjaan,
      'nationality': kewarganegaraan,
      'validUntil': berlakuHingga,
    };
  }

  // Create an instance from a JSON map
  factory OcrDataHolderModel.fromJson(Map<String, dynamic> json) {
    return OcrDataHolderModel(
      nama: json['fullName'],
      nik: json['nik'],
      tempatLahir: json['placeOfBirth'],
      tanggalLahir: json['dateOfBirth'],
      jenisKelamin: json['gender'],
      golonganDarah: json['bloodType'],
      address: json['address'],
      rt: json['rt'],
      rw: json['rw'],
      kelurahanDesa: json['kelurahan'],
      kecamatan: json['kecamatan'],
      kota: json['city'],
      provinsi: json['province'],
      agama: json['religion'],
      maritalStatus: json['maritalStatus'],
      pekerjaan: json['occupation'],
      kewarganegaraan: json['nationality'],
      berlakuHingga: json['validUntil'],
    );
  }
}
