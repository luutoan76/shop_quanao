// ignore_for_file: library_private_types_in_public_api
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/ApiService.dart';
import 'package:shop_quanao/Model/Fake_Category.dart';
import 'package:shop_quanao/Model/Product.dart';
import 'package:shop_quanao/page/ProductDetails_screen.dart';

// ignore: must_be_immutable
class HomeBody extends StatefulWidget {
  //late Product? product;

  const HomeBody({super.key});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const String iconAddress = "lib/public/icons/category/";

  //
  //ProductViewModel productViewModel = ProductViewModel();
  late Future<List<Product>> _products;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //productViewModel.fetchProducts();
    _products =ApiService().getProduct();
  }

  // select item: (default)
  int selectedCategortItem = 0;
  int selectProductItem = 0;
  //demo:
  int price = 10;
  String unit = 'Đ';

  /* ****************************************** Start ******************************************

    - ฅ^•ﻌ•^ฅ demo only!:
                  xóa khi đã có backend ! 😺😺😺

     ****************************************** Start ****************************************** */
/*
  TODO: Class zí zụ làm mòe nhớ xóa nhoaa !
*/
  final List<Category> category = [
    // Category(id, Name, location + Logo) - ฅ^•ﻌ•^ฅ
    Category(1, "All", "${iconAddress}All.png"),
    Category(2, "Adidas", "${iconAddress}Adidas.png"),
    Category(3, "Fila", "${iconAddress}Fila.png"),
    Category(4, "Nike", "${iconAddress}Nike.png"),
    Category(5, "Puma", "${iconAddress}Puna.png"),
  ];

  // final List<String> Urls = [
  //   // Category(id, Name, location + Logo) - ฅ^•ﻌ•^ฅ
  //   "Hình 1",
  //   "Hình 2",
  //   "Hình 3"
  // ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 10,),
              CarouselView(),
              productTitle(),
              categoryListView(),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: FutureBuilder<List<Product>>(
                future: _products,
                builder: (context, snapshot){
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(child: Text('Error: ${snapshot.error}')),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No products available')),
                    );
                  } else {
                    return SliverGrid( 
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 2 / 3,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = snapshot.data![index];
                          final String? firstImageUrl = product.img != null && product.img!.isNotEmpty
                              ? product.img![0]
                              : null;
                          return GestureDetector(
                            onTap: () {
                              final List<String> urls = product.img!;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    key: ValueKey('product_detail_page_$index'),
                                    productName: product.name.toString(),
                                    productDescription: product.description.toString(),
                                    productImages: urls,
                                    ProductId: product.id.toString(),
                                    productPrice: product.price.toString(),
                                    productLoaisp: product.loaisp.toString(),
                                    productSize: product.size!,
                                    productColor: product.color!,
                                    productLike: product.like.toString(),
          
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              height: 250,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    firstImageUrl != null
                                        ? ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(30),  
                                            topRight: Radius.circular(30), 
                                          ),
                                          child: Image.network(
                                              firstImageUrl,
                                              width: double.infinity,
                                              height: 200,
                                              fit: BoxFit.cover,
                                              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                                print('Error loading image: $error');
                                                return const Center(child: Icon(Icons.error));
                                              },
                                            ),
                                        )
                                        : const Text(
                                            "Sp không có hình",
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                    const SizedBox(height: 15,),
                                    Center(
                                      //padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: Text(
                                        product.name ?? "",
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Center(
                                      //padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                      child: Text(
                                        'Giá: ${product.price} $unit',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    );
                  }
                },
              
          ),
        ),
      ],
      
    );
  }

/*
      ****************** widgets start ******************
*/

// Title page:
  Widget productTitle() {
    String selectedCategory = 'Sản phẩm'; // default

    if (selectedCategortItem >= 0 && selectedCategortItem < category.length) {
      selectedCategory = category[selectedCategortItem].name.toString();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 5, right: 5, bottom: 0),
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Sản phẩm mới',
              style: TextStyle(
                color: Color(0xFF152354),
                fontSize: 30,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              selectedCategory, // Hiển thị nội dung đã thay đổi dựa trên icon được chọn
              style: const TextStyle(
                color: Color(0xFF152354),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

// Category Items:
  Widget categoryListView() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategortItem = index;
              });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animation transfer delay: 0,5s -⁠ ฅ^•ﻌ•^ฅ
                AnimatedContainer(
                  duration: const Duration(
                      milliseconds: 200), // Recommended:  0,3 - 0,5

                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(2),

                  width: 100,
                  height: 100,

                  decoration: BoxDecoration(
                    color: selectedCategortItem == index
                        ? const Color(0xFF69BDFC)
                        : const Color(0xFFD9D9D9),
                    shape: BoxShape.circle,
                  ),

                  child: Center(
                    child: Image.asset(
                      category[index].logo,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

// Products Items:
  

  Widget CarouselView(){
    final List<String> imgList = [
    'https://i.pinimg.com/564x/d2/fd/1e/d2fd1e8c0f5d7b53c551b8aa3c31554b.jpg',
    'https://i.pinimg.com/564x/2b/39/09/2b39094e93831aedbea06899902b1b4f.jpg',
    'https://i.pinimg.com/564x/cc/4e/85/cc4e85653d8743cae049a7672439bfaa.jpg',];

    return Center(
      child: CarouselSlider(
        options: CarouselOptions(
          height: 200,
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 16/9,
          viewportFraction: 0.8,
        ),
        items: imgList.map((item) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(item, fit: BoxFit.cover, width: 1000),
          ),
        )).toList(),
      ),
    );
  }

/*
      ****************** widgets end ******************
*/
}
