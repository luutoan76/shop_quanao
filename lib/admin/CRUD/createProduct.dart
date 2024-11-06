import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Createproduct extends StatefulWidget {
  const Createproduct({super.key});

  @override
  State<Createproduct> createState() => _CreateproductState();
}

class _CreateproductState extends State<Createproduct> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController desController = TextEditingController();
  late TextEditingController priceController = TextEditingController();
  late TextEditingController loaispController = TextEditingController();
  late TextEditingController imgController = TextEditingController();
  late List<TextEditingController> sizeController = [];
  late List<TextEditingController> colorController = [];
  List<String> size = [];
  List<String> color =[];

  void addColor(){
    setState(() {
      color.add("");
      colorController.add(TextEditingController());
    });
  }
  void removeColor(int index){
    setState(() {
      color.removeAt(index);
      colorController.removeAt(index);
    });
  }
  void _addSize() {
    setState(() {
      size.add("");
      sizeController.add(TextEditingController());
    });
  }

  void _removeSize(int index) {
    setState(() {
      size.removeAt(index);
      sizeController.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // chuyen den trang moi
            Navigator.pop(context);

          },
        ),
        title: const Text(
          "Sản phẩm",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: (){

            },
          ),
        ],

      ),
      body: SingleChildScrollView(
        
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 600, // Controls the width of the Column
            ),
            child: Column(
              
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                  child: Text("Thêm sản phẩm" , style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Tên sản phẩm",
                      labelText: "Tên sản phẩm",
                      prefixIcon: const Icon(Icons.abc),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      
            
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(
                      hintText: "Giá",
                      labelText: "Gía",
                      prefixIcon: const Icon(Icons.money),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      
            
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
                  child: TextField(
                    controller: loaispController,
                    decoration: InputDecoration(
                      hintText: "Loại sản phẩm",
                      labelText: "Loại sản phẩm",
                      prefixIcon: const Icon(Icons.category),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      
            
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
                  child: TextField(
                    controller: imgController,
                    decoration: InputDecoration(
                      hintText: "img",
                      labelText: "img",
                      prefixIcon: const Icon(Icons.image),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      
            
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Sizes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: size.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: sizeController[index],
                                  decoration: InputDecoration(
                                    hintText: "Size ${index + 1}",
                                    
                                  ),
                                  onChanged: (value) {
                                    size[index] = value;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => _removeSize(index),
                              ),
                            ],
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: _addSize,
                        child: Text("Thêm size"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Màu sắc", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: color.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: colorController[index],
                                  decoration: InputDecoration(
                                    hintText: "Màu sắc ${index + 1}",
                                    
                                  ),
                                  onChanged: (value) {
                                    color[index] = value;
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () => removeColor(index),
                              ),
                            ],
                          );
                        },
                      ),
                      ElevatedButton(
                        onPressed: addColor,
                        child: Text("Thêm màu"),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16), 
                  child: TextFormField(
                    maxLines: 5,
                    minLines: 3,
                    controller: desController,
                    decoration: InputDecoration(
                      hintText: "Mô tả",
                      labelText: "Mô tả",
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:const  BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      
            
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0.05),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: ElevatedButton(
                      onPressed: () async {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 105, 163, 239),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text(
                        "Lưu thay đổi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}