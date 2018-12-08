import 'dart:convert';
class ProductModel {
  String idProduct;
  String photoURLProduct;
  String namaProduct;
  String typeProduct;
  String descriptionProduct;
  int hargaProduct;
  

  ProductModel();
  
  ProductModel.fromSnapshot(Map<dynamic, dynamic> snapshot,String id)
      : idProduct = id,
        photoURLProduct = snapshot["photoURLProduct"],
        namaProduct = snapshot["namaProduct"],
        typeProduct = snapshot["typeProduct"],
        descriptionProduct = snapshot["descriptionProduct"],
        hargaProduct = snapshot["hargaProduct"];

  toJson() {
    return {
      "idProduct": idProduct,
      "photoURLProduct": photoURLProduct,
      "namaProduct": namaProduct,
      "typeProduct": typeProduct,
      "descriptionProduct": descriptionProduct,
      "hargaProduct": hargaProduct,
    };
  }
}