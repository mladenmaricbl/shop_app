import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_item.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void initState(){
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies(){
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      if(productId != null){
        print(productId);
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false).getProductById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'price': _editedProduct.price.toString(),
          'description': _editedProduct.description,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus)
      setState(() {});
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
      if(!isValid)
        return;
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if(_editedProduct.id != null){
      await Provider.of<ProductsProvider>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
    }else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false).addProduct(
            _editedProduct);
      }catch(error){
        await showDialog(context: context, builder: (ctx) => AlertDialog(
          title: Text('An error ocurred!'),
          content: Text('Something went wrong!'),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: (){
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ));
      }
      /*finally{
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }*/
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Manage products'),
          actions: [
            IconButton(
              onPressed: _submitForm,
              icon: const Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading ?
        Center(
          child: CircularProgressIndicator(),
        )
            :
        Form(
          key: _form,
          child: ListView(
            padding: const EdgeInsets.only(left: 20, right: 20),
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (val){
                  if(val.isEmpty)
                    return 'Field can not be empty!';
                   return null;
                },
                onSaved: (val){
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: val,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,

                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (val){
                  if(val.isEmpty)
                    return 'Field can not be empty!';
                  return null;
                },
                onSaved: (val){
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    price: double.parse(val),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    isFavorite: _editedProduct.isFavorite,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                validator: (val){
                  if(val.isEmpty)
                    return 'Field can not be empty!';
                  return null;
                },
                  onSaved: (val){
                   _editedProduct = Product(
                     id: _editedProduct.id,
                     title: _editedProduct.title,
                     price: _editedProduct.price,
                     description: val,
                     imageUrl: _editedProduct.imageUrl,
                     isFavorite: _editedProduct.isFavorite,
                   );
                  }
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width:2,
                        color: Colors.grey
                      )
                    ),
                    child: _imageUrlController.text.isEmpty? Center(
                      child: Text('No image'),
                    )
                    :
                     FittedBox(
                       child: Image.network(
                           _imageUrlController.text,
                            fit: BoxFit.cover,
                       ),
                     ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                        _submitForm();
                      },
                       validator: (val){
                         if(val.isEmpty)
                          return 'Field can not be empty!';
                         return null;
                        },
                        onSaved: (val){
                         _editedProduct = Product(
                           id: _editedProduct.id,
                           title: _editedProduct.title,
                           price: _editedProduct.price,
                           description: _editedProduct.description,
                           imageUrl: val,
                           isFavorite: _editedProduct.isFavorite,
                         );
                      }
                    ),
                  )
                ],
              )
            ],
          ),
        )
    );
  }
}
