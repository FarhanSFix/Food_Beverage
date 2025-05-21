import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_baverage/app/data/Food.dart';
import 'package:food_baverage/app/routes/app_pages.dart';
import 'package:food_baverage/app/utils/colors.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/detail_food_controller.dart';

class DetailFoodView extends GetView<DetailFoodController> {
  const DetailFoodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        height: 100.h,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                deleteMenu(controller.food.id);
              },
              child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.white,
                      ),
                      10.horizontalSpace,
                      const Text("Hapus", style: TextStyle(color: Colors.white))
                    ],
                  )),
            ),
            GestureDetector(
              onTap: () {
                editMenu(controller.food, context);
              },
              child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ),
                      10.horizontalSpace,
                      const Text("Edit", style: TextStyle(color: Colors.white))
                    ],
                  )),
            ),
          ],
        ),
      ),
      body: StreamBuilder<Food>(
        stream: controller.getFood(controller.food.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            controller.food = snapshot.data!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300.h,
                  backgroundColor: Colors.red,
                  pinned: true,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ).marginSymmetric(horizontal: 10.w, vertical: 10.h),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(70),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Text(
                              snapshot.data!.nama,
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          10.verticalSpace,
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.r,
                              vertical: 5.r,
                            ),
                            height: 30.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.r),
                                ),
                                color: getColor(snapshot.data?.jenis ?? "")),
                            child: Text(
                              "${snapshot.data?.jenis}",
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      snapshot.data!.images,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Waktu Pembuatan",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          10.verticalSpace,
                          Row(
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Colors.orange,
                              ),
                              Text(
                                "${snapshot.data!.waktuPembuatan} Menit",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          20.verticalSpace,
                          Text(
                            snapshot.data!.deskripsi,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                          20.verticalSpace,
                          Text(
                            "Resep dan Cara Membuat",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            snapshot.data!.resep,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Data tidak ditemukan"));
          }
        },
      ),
    );
  }

  void deleteMenu(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Hapus"),
        content: const Text("Apakah anda yakin ingin menghapus data ini?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMenu(id);
              Get.offAllNamed(Routes.HOME);
              Get.snackbar(
                "Dihapus",
                "Data berhasil dihapus",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                margin: const EdgeInsets.all(10),
              );
            },
            child: const Text("Ya"),
          ),
        ],
      ),
    );
  }

  void editMenu(Food food, BuildContext context) {
    final image = XFile("").obs;

    //mengisi field inputan dengan properti dari objek parameter food yang sesuai
    controller.namaController.text = food.nama;
    controller.waktuPembuatanController.text = food.waktuPembuatan.toString();
    controller.resepController.text = food.resep;
    controller.deskripsiController.text = food.deskripsi;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Obx(
        () => Container(
          height: 0.9.sh,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              ScreenUtil().setWidth(10),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Edit Menu",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w500)),
                    IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.close,
                          size: 16.sp,
                          color: Colors.grey[500],
                        )),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      ScreenUtil().setWidth(10),
                    ),
                  ),
                  child: image.value.path == ""
                      ? CachedNetworkImage(
                          imageUrl: food.images,
                          width: 1.sw,
                          height: 200.h,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(image.value.path),
                          width: 1.sw,
                          height: 200.h,
                          fit: BoxFit.cover,
                        ),
                ),
                10.verticalSpace,
                ElevatedButton(
                    onPressed: () async {
                      ImagePicker picker = ImagePicker();
                      final pickedFile =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        image.value = pickedFile;
                      }
                    },
                    child: const Text("Edit Foto")),
                20.verticalSpace,
                Text(
                  "Nama Menu",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  textEditingController: controller.namaController,
                  hintText: food.nama.toString(),
                ),
                15.verticalSpace,
                Text(
                  "Waktu Pembuatan",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  textEditingController: controller.waktuPembuatanController,
                  hintText: food.resep.toString(),
                ),
                10.verticalSpace,
                Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  maxLines: 5,
                  textEditingController: controller.deskripsiController,
                  hintText: food.nama.toString(),
                ),
                10.verticalSpace,
                Text(
                  "Resep",
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(12),
                  ),
                ),
                10.verticalSpace,
                RoundedInputField(
                  maxLines: 10,
                  textEditingController: controller.resepController,
                  hintText: food.nama.toString(),
                ),
                30.verticalSpace,
                controller.obx(
                  (state) => Flexible(
                    child: SizedBox(
                      height: ScreenUtil().setHeight(40),
                      width: 1.sw,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          if (image.value.path.isNotEmpty) {
                            await controller.updateMenuWithImage(
                              food.id,
                              controller.namaController.text,
                              int.parse(
                                  controller.waktuPembuatanController.text),
                              controller.deskripsiController.text,
                              food.jenis,
                              File(image.value.path),
                              controller.resepController.text,
                            );
                          } else {
                            await controller.updateMenu(
                              food.id,
                              controller.namaController.text,
                              int.parse(
                                  controller.waktuPembuatanController.text),
                              controller.deskripsiController.text,
                              food.jenis,
                              food.images,
                              controller.resepController.text,
                            );
                          }
                          Get.back();
                          Get.snackbar(
                            "Edit Berhasil",
                            "Data Telah Berhasil Diedit",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                          controller.namaController.dispose();
                          controller.waktuPembuatanController.dispose();
                          controller.deskripsiController.dispose();
                          controller.resepController.dispose();
                        },
                        child: const Text('Simpan Menu'),
                      ),
                    ),
                  ),
                  onEmpty: Flexible(
                    child: SizedBox(
                      height: ScreenUtil().setHeight(40),
                      width: 1.sw,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          if (image.value.path.isNotEmpty) {
                            await controller.updateMenuWithImage(
                              food.id,
                              controller.namaController.text,
                              int.parse(
                                  controller.waktuPembuatanController.text),
                              controller.deskripsiController.text,
                              food.jenis,
                              File(image.value.path),
                              controller.resepController.text,
                            );
                          } else {
                            await controller.updateMenu(
                              food.id,
                              controller.namaController.text,
                              int.parse(
                                  controller.waktuPembuatanController.text),
                              controller.deskripsiController.text,
                              food.jenis,
                              food.images,
                              controller.resepController.text,
                            );
                          }
                          Get.back();
                          Get.snackbar(
                            "Edit Berhasil",
                            "Data Telah Berhasil Diedit",
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        },
                        child: const Text('Simpan Menu'),
                      ),
                    ),
                  ),
                  onLoading: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  onError: (error) {
                    Get.snackbar(
                      "Error",
                      error.toString(),
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                    return Flexible(
                      child: SizedBox(
                        height: ScreenUtil().setHeight(40),
                        width: 1.sw,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (image.value.path.isNotEmpty) {
                              await controller.updateMenuWithImage(
                                food.id,
                                controller.namaController.text,
                                int.parse(
                                    controller.waktuPembuatanController.text),
                                controller.deskripsiController.text,
                                food.jenis,
                                File(image.value.path),
                                controller.resepController.text,
                              );
                            } else {
                              await controller.updateMenu(
                                food.id,
                                controller.namaController.text,
                                int.parse(
                                    controller.waktuPembuatanController.text),
                                controller.deskripsiController.text,
                                food.jenis,
                                food.images,
                                controller.resepController.text,
                              );
                            }
                            Get.back();
                            Get.snackbar(
                              "Edit Berhasil",
                              "Data Telah Berhasil Diedit",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text('Simpan Menu'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ).paddingSymmetric(vertical: 10.h, horizontal: 20.w),
          ),
        ),
      ),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final double? roundedCorner;
  final ValueChanged<String>? onChanged;
  final TextEditingController? textEditingController;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Color? borderColor;
  final int? maxLines;
  final TextInputType? keyboardType;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.textEditingController,
    this.roundedCorner = 10,
    this.height,
    this.width,
    this.textSize,
    this.backgroundColor,
    this.padding,
    this.borderColor,
    this.keyboardType,
    this.maxLines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: TextField(
        onChanged: onChanged,
        controller: textEditingController,
        maxLines: maxLines ?? 1,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedCorner!),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(roundedCorner!),
          ),
          contentPadding: padding ??
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: textSize ?? 13),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
