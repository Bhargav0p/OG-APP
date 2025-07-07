import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/scroll_remover.dart';
import '../contact_model.dart';
import 'package:url_launcher/url_launcher.dart';
class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Contact> contactList = [
    Contact(
      name: "Adarsh Bhardwaj",
      desc: "Website, App and \nPayments",
      email: "webmaster@bits-apogee.org",
      imageAsset: "adarsh.png",
      phoneNumber: "9140650723",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Mayan Agrawal",
      desc: "Publications and \nCorrespondence",
      email: "pcr@bits-apogee.org",
      imageAsset: "mayan.png",
      phoneNumber: "9423527868",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Lalit Adithya",
      desc: "Reception and \nAccomodation",
      email: "recnacc@bits-apogee.org",
      imageAsset: "lalitrecnacc.png",
      phoneNumber: "7358092952",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Sahil Shah",
      desc: "Sponsorship and \nMarketing",
      email: "sponsorship@bits-apogee.org.org",
      imageAsset: "sahil.png",
      phoneNumber: "9321943954",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Poorvansh Kavta",
      desc: "Publicity and\nOnline Partnerships",
      email: "collaborations@bits-apogee.org",
      imageAsset: "poorvanshadp.png",
      phoneNumber: "9602731678",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Nishit Gupta",
      desc: "Events, Projects and\nLogistics",
      email: "controls@bits-apogee.org",
      imageAsset: "nishitcontrols.png",
      phoneNumber: "8107194690",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Ishpreet Singh",
      desc: "Guest Lectures and\n Paper Presentations",
      email: "pep@bits-apogee.org",
      imageAsset: "ishpreet.png",
      phoneNumber: "9407095716",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Ashirwad Karande",
      desc: "President\n Student Union",
      email: "president@pilani.bits-pilani.ac.in",
      imageAsset: "karande.png",
      phoneNumber: "8793009454",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
    Contact(
      name: "Naman Jalan",
      desc: "General Secretary\n Student Union",
      email: "gensec@pilani.bits-pilani.ac.in",
      imageAsset: "naman.png",
      phoneNumber: "8617395921",
      githubUsername: "",
      linkedinUsername: "",
      twitterUsername: "",
      behanceUsername: "",
      dribbleUsername: "",
      instagramUsername: "",
    ),
  ];

  Future<void> _launchMail(String email) async {
    final Uri _mailurl = Uri.parse('mailto:$email');
    await launchUrl(_mailurl);
  }

  Future<void> _launchPhone(String phoneNumber) async {
    final Uri _callurl = Uri.parse('tel:$phoneNumber');
    await launchUrl(_callurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60.h, left: 24.w),
                  child: Text(
                    "Contact Us",
                    style: GoogleFonts.openSans(
                        fontSize: 28.sp, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 200.w, top: 50.h),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28.r,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.h, left: 36.w, right: 36.w),
              child: SizedBox(
                height: (MediaQuery.of(context).size.height - 184.h),
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 24.w,
                          mainAxisSpacing: 20.h,
                          crossAxisCount: 2,
                          childAspectRatio: 0.62),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF17181C),
                              borderRadius: BorderRadius.circular(10.r)),
                          width: 182.w,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    height: 113.h,
                                    decoration: const BoxDecoration(
                                        color: Color.fromRGBO(152, 85, 217, 1)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 1.w, vertical: 1.h),
                                      child: ClipOval(
                                        child: Container(
                                          color: Colors.black,
                                          child: Image.asset(
                                            "assets/images/${contactList[index].imageAsset}",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 12.h),
                                  child: Center(
                                    child: Text(
                                      contactList[index].name,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.mulish(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          fontSize: 18.sp),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 16.08.h, bottom: 20.35.h),
                                  child: Center(
                                    child: Text(
                                      contactList[index].desc,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.openSans(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(255, 252, 252, 1),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 65.57.w,
                                  height: 20.h,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await _launchPhone(
                                              contactList[index].phoneNumber);
                                          await Clipboard.setData(
                                            ClipboardData(
                                                text: contactList[index]
                                                    .phoneNumber),
                                          );
                                        },
                                        child: Icon(
                                          Icons.phone,
                                          size: 20.w,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await _launchMail(
                                              contactList[index].email);
                                          await Clipboard.setData(
                                            ClipboardData(
                                                text: contactList[index].email),
                                          );
                                        },
                                        child: Icon(
                                          size: 20.w,
                                          Icons.email,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: contactList.length),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
