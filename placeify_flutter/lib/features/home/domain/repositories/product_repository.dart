import '../models/category.dart';
import '../models/product.dart';

abstract class ProductRepository {
  List<ProductCategory> getCategories();
  List<Product> getProducts();
  Product? getProductById(String id);
}
