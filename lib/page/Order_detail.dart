
import 'package:flutter/material.dart';
import 'package:shop_quanao/Model/Order.dart';

class OrderDetail extends StatefulWidget {
  final Order order;
  const OrderDetail({super.key, required this.order});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            //
            Navigator.pop(context);
          },
        ),
        title: const Text('Chi tiết đơn hàng', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to the search page
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text(
                    'ID hoá đơn: ${widget.order.id}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ngày đặt: ${widget.order.dayCreate}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Địa chỉ: ${widget.order.address}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tổng tiền: ${widget.order.total}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Trạng thái: ${widget.order.status}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Display product list
                  const Text(
                    'Danh sách sản phẩm:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.order.orderItem!.length,
                      itemBuilder: (context, index) {
                        final item = widget.order.orderItem![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                            
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Transform.rotate(
                                  angle: 10 *
                                      (3.14 / 180.0), 
                                  child: Image.network(
                                    item.img,
                                    width: 130,
                                    height: 130,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.namePro,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("${item.price} d",
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text("Số lượng: ${item.quantity}",
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    
                                  ],
                                ),
                              ),
                              
                            ],
                          ),
                        );
                      },
                    ),
                  
            ],
          ),
        ),
      )
      
    );
    
  }
}