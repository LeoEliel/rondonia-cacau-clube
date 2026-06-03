import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../domain/entities/product_query.dart';
import '../../domain/entities/enums.dart';
import '../core/data_exceptions.dart';
import '../dtos/product_dto.dart';

/// Firestore-backed product reads. Confines all `cloud_firestore` usage for the
/// catalog to the data layer.
///
/// Catalog scale is small (a prototype), so search/seal/text filtering and
/// sorting are applied client-side after a single collection read. This avoids
/// requiring composite Firestore indexes while keeping query semantics in one
/// place.
class ProductRemoteDataSource {
  ProductRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(FirestorePaths.products);

  Future<List<ProductDto>> fetchProducts(ProductQuery query) async {
    final snap = await _col.get();
    final items = snap.docs.map(ProductDto.fromDoc).toList();
    return _applyQuery(items, query);
  }

  Future<ProductDto> fetchProductById(String id) async {
    final doc = await _col.doc(id).get();
    if (!doc.exists) {
      throw DataNotFoundException('Produto "$id" não encontrado.');
    }
    return ProductDto.fromDoc(doc);
  }

  Future<List<ProductDto>> fetchProductsByProducer(String producerId) async {
    final snap = await _col.where('producerId', isEqualTo: producerId).get();
    final items = snap.docs.map(ProductDto.fromDoc).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return items;
  }

  List<ProductDto> _applyQuery(List<ProductDto> source, ProductQuery query) {
    var items = source;

    if (query.producerId != null) {
      items = items.where((p) => p.producerId == query.producerId).toList();
    }
    if (query.category != null) {
      final key = query.category!.wireKey;
      items = items.where((p) => p.byproductCategory == key).toList();
    }
    if (query.seals.isNotEmpty) {
      final keys = query.seals.map((s) => s.wireKey).toSet();
      items = items.where((p) => p.qualitySeals.any(keys.contains)).toList();
    }
    final text = query.text?.trim().toLowerCase();
    if (text != null && text.isNotEmpty) {
      items = items
          .where((p) =>
              p.name.toLowerCase().contains(text) ||
              p.description.toLowerCase().contains(text))
          .toList();
    }

    switch (query.sort) {
      case ProductSort.recent:
        items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case ProductSort.topRated:
        items.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSort.nameAsc:
        items.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
    }
    return items;
  }
}
