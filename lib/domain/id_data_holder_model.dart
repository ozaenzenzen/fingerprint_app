class IdDataHolderModel {
  String? address;
  String? nik;
  String? nama;
  String? ttl;
  String? jenisKelamin;
  String? golonganDarah;
  String? rtRw;
  String? kelurahanDesa;
  String? kecamatan;
  String? kota;
  String? provinsi;
  String? agama;
  String? pekerjaan;
  String? kewarganegaraan;
  String? berlakuHingga;

  IdDataHolderModel({
    this.address,
    this.nik,
    this.nama,
    this.ttl,
    this.jenisKelamin,
    this.golonganDarah,
    this.rtRw,
    this.kelurahanDesa,
    this.kecamatan,
    this.kota,
    this.provinsi,
    this.agama,
    this.pekerjaan,
    this.kewarganegaraan,
    this.berlakuHingga,
  });

  // Convert the model to a JSON-compatible map
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'nik': nik,
      'nama': nama,
      'ttl': ttl,
      'jenisKelamin': jenisKelamin,
      'golonganDarah': golonganDarah,
      'rtRw': rtRw,
      'kelurahanDesa': kelurahanDesa,
      'kecamatan': kecamatan,
      'kota': kota,
      'provinsi': provinsi,
      'agama': agama,
      'pekerjaan': pekerjaan,
      'kewarganegaraan': kewarganegaraan,
      'berlakuHingga': berlakuHingga,
    };
  }

  // Create an instance from a JSON map
  factory IdDataHolderModel.fromJson(Map<String, dynamic> json) {
    return IdDataHolderModel(
      address: json['address'] as String?,
      nik: json['nik'] as String?,
      nama: json['nama'] as String?,
      ttl: json['ttl'] as String?,
      jenisKelamin: json['jenisKelamin'] as String?,
      golonganDarah: json['golonganDarah'] as String?,
      rtRw: json['rtRw'] as String?,
      kelurahanDesa: json['kelurahanDesa'] as String?,
      kecamatan: json['kecamatan'] as String?,
      kota: json['kota'] as String?,
      provinsi: json['provinsi'] as String?,
      agama: json['agama'] as String?,
      pekerjaan: json['pekerjaan'] as String?,
      kewarganegaraan: json['kewarganegaraan'] as String?,
      berlakuHingga: json['berlakuHingga'] as String?,
    );
  }
}
