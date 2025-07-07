import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../../utils/ui_utils.dart';
import '../repo/model/hive_model/hive_menu_entry.dart';

class AddButton extends StatefulWidget {
  AddButton(
      {Key? key,
        required this.is_available,
        required this.menuItemName,
        required this.amount,
        required this.foodStallId,
        required this.price,
        required this.menuItemId,
        required this.isVeg,
        required this.foodStallName})
      : super(key: key);
  int amount;
  bool is_available;
  String menuItemName;
  int price;
  bool isVeg;
  String foodStallName;
  int foodStallId;
  int menuItemId;

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  Widget build(BuildContext context) {
    return (widget.is_available)
        ? Container(
      width: 100.w,
      child: (widget.amount == 0)
          ? InkWell(
        onTap: () {
          if (widget.is_available) {
            setState(() {
              widget.amount++;
              var box = Hive.box('cartBox');
              box.put(
                  widget.menuItemId,
                  HiveMenuEntry(
                      menuItemName: widget.menuItemName,
                      price: widget.price,
                      FoodStall: widget.foodStallName,
                      quantity: widget.amount,
                      FoodStallId: widget.foodStallId,
                      isVeg: widget.isVeg));
            });
          }
        },
        splashColor: Colors.transparent,
        child: Container(
          height: 34.h,
          width: 91.w,
          decoration: BoxDecoration(
            color: Color.fromRGBO(152, 85, 217, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(28, 30, 45, 1),
                border: Border.all(
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(

                    child: Text(
                      "Add+",
                      style: GoogleFonts.poppins(
                          color: Color.fromRGBO(152, 85, 217, 1),
                          fontSize: UIUtills()
                              .getProportionalHeight(height: 16),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
            ),
          ),
        ),
      )
          : Container(
        height: UIUtills().getProportionalHeight(height: 34),
        width: UIUtills().getProportionalWidth(width: 90),
        //padding: const EdgeInsets.symmetric(horizontal: 9.69),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.25),
                offset: Offset(0, 2.36364),
                blurRadius: 4.72727)
          ],
          borderRadius: BorderRadius.circular(10),
          color: Color.fromRGBO(152, 85, 217, 1)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Container(
                height: 30.h,
                width: 25.w,
                color: Colors.transparent,
                child: const Icon(
                  Icons.remove,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onTap: () {
                if (widget.is_available) {
                  setState(() {
                    var box = Hive.box('cartBox');
                    widget.amount--;
                    if (widget.amount == 0) {
                      box.delete(widget.menuItemId);
                    } else {
                      box.put(
                          widget.menuItemId,
                          HiveMenuEntry(
                              menuItemName: widget.menuItemName,
                              price: widget.price,
                              FoodStall: widget.foodStallName,
                              quantity: widget.amount,
                              FoodStallId: widget.foodStallId,
                              isVeg: widget.isVeg));
                    }
                  });
                }
              },
            ),
            Container(
              height: UIUtills().getProportionalHeight(height: 32),
              width: UIUtills().getProportionalWidth(width: 38),
              color: Color.fromRGBO(28, 30, 45, 1),
              child: Center(

                  child: Text(
                    "${widget.amount}",
                    style: GoogleFonts.roboto(
                        color: Colors.white, fontSize: 16),
                  ),

              ),
            ),
            InkWell(
              child: Container(
                height: 30.h,
                width: 25.w,
                color: Colors.transparent,
                child: const Icon(
                  Icons.add,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                if (widget.is_available) {
                  setState(() {
                    widget.amount++;
                    var box = Hive.box('cartBox');
                    box.put(
                        widget.menuItemId,
                        HiveMenuEntry(
                            isVeg: widget.isVeg,
                            menuItemName: widget.menuItemName,
                            price: widget.price,
                            FoodStall: widget.foodStallName,
                            quantity: widget.amount,
                            FoodStallId: widget.foodStallId));
                  });
                }
              },
            ),
          ],
        ),
      ),
    )
        : Container(
      height: UIUtills().getProportionalHeight(height: 34),
      width: UIUtills().getProportionalWidth(width: 90),
      decoration: BoxDecoration(
        color: Color.fromRGBO(88, 53, 122, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(28, 30, 45, 1),
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
              child: Text(
                "Sold Out",
                style: GoogleFonts.poppins(
                    color: Color.fromRGBO(122, 122, 122, 1),
                    fontSize: UIUtills().getProportionalHeight(height: 16),
                    fontWeight: FontWeight.w500),
              )),
        ),
      ),
    );
  }
}
