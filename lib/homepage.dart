import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_project_01/firebase_add_data.dart';
import 'package:demo_project_01/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



HomeController homeController = Get.put(HomeController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        bottom: TabBar(
          controller: homeController.tabController,
          tabs: [
            Tab(text: "Home"),
            Tab(text: "Add Data"),
          ],
        ),
      ),
      body: TabBarView(controller: homeController.tabController, children: [HomeTab(), AddDataTab()]),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FirebaseHelper().getData(),
        builder: (context, asyncSnapshot) {
          final dataList = asyncSnapshot.data?.docs;

          if (asyncSnapshot.hasData) {
            return ListView.builder(
              itemCount: dataList!.length,
              itemBuilder: (context, index) {
                final data = dataList[index].data();
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text(data['email']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(onPressed: () async {
                          homeController.isUpdateData.value = true;
                          homeController.nameController.text = data['name'];
                          homeController.emailController.text = data['email'];
                          homeController.phoneController.text = data['phoneNo'];
                          homeController.dataId.value = dataList[index].id;
                          homeController.tabController.animateTo(1);

                        }, icon: Icon(Icons.edit, color: Colors.black)),
                        IconButton(onPressed: () async {
                          await FirebaseHelper().deleteData(dataList[index].id);
                          setState(() {});
                        }, icon: Icon(Icons.delete, color: Colors.red)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}

class AddDataTab extends StatefulWidget {
  const AddDataTab({super.key});

  @override
  State<AddDataTab> createState() => _AddDataTabState();
}

class _AddDataTabState extends State<AddDataTab> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Obx(() {
        homeController.dataId.value;
        return Column(
          children: [
            TextFormField(
              decoration: InputDecoration(label: Text("Name")),
              controller: homeController.nameController,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("Email")),
              controller: homeController.emailController,
            ),
            TextFormField(
              decoration: InputDecoration(label: Text("phone No")),
              controller: homeController.phoneController,
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {

                if(homeController.isUpdateData.isTrue){
                  await FirebaseHelper().updateData(
                    id: homeController.dataId.value,
                    email: homeController.emailController.text,
                    name: homeController.nameController.text,
                    phoneNo: homeController.phoneController.text,
                  );
                }else{
                  await FirebaseHelper().addData(
                    email: homeController.emailController.text,
                    name: homeController.nameController.text,
                    phoneNo: homeController.phoneController.text,
                  );
                }


                homeController.emailController.clear();
                homeController.nameController.clear();
                homeController.phoneController.clear();
                homeController.isUpdateData.value = false;
                homeController.tabController.animateTo(0);
              },
              child: Text(homeController.isUpdateData.isTrue? "update": "Add"),
            ),
          ],
        );
      }),
    );
  }
}
