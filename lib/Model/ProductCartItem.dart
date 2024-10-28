// ignore: file_names
class ProductCart {
  int? idsp;
  String? tenSP;
  String? imgUrl;
  int? giaBan;

  ProductCart({this.idsp, this.tenSP, this.imgUrl, this.giaBan});

  ProductCart.fromJson(Map<String, dynamic> json) {
    idsp = json['idsp'];
    tenSP = json['tenSP'];
    imgUrl = json['img_Url'];
    giaBan = json['giaBan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idsp'] = idsp;
    data['tenSP'] = tenSP;
    data['img_Url'] = imgUrl;
    data['giaBan'] = giaBan;
    return data;
  }
}