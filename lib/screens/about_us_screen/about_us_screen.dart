// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors


// import 'package:flutter/material.dart';

// class AboutUsScreen extends StatelessWidget {
//   static const String routeName = '/AboutUsScreen';
//   const AboutUsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return ScreensWrapper(
//       backgroundColor: kBackgroundColor,
//       child: Column(
//         children: [
//           CustomAppBar(
//             title: Text(
//               'About Developer',
//               style: h2TextStyle,
//             ),
//           ),
//           VSpace(),
//           PaddingWrapper(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(width: double.infinity),
//                 Row(
//                   children: [
//                     Container(
//                       clipBehavior: Clip.hardEdge,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10000),
//                       ),
//                       child: Image.asset(
//                         'assets/icons/intro/dev.jpg',
//                         width: largeIconSize * 2,
//                         height: largeIconSize * 2,
//                         alignment: Alignment.topCenter,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     HSpace(),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Amr M Hassan',
//                           style: h2TextStyle,
//                         ),
//                         Text(
//                           'Flutter developer',
//                           style: h4TextStyleInactive,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 VSpace(),
//                 Text(
//                   '- Mainly Flutter developer, with previous experience in \n   MERN stack.\n- Multi skills professional.',
//                   style: h4TextStyleInactive,
//                   softWrap: true,
//                 ),
//                 VSpace(factor: 2),
//                 Row(
//                   children: [
//                     ButtonWrapper(
//                       onTap: () {
//                         launchUrlString(
//                           'https://www.facebook.com/amrm.hassan.10',
//                           mode: LaunchMode.externalApplication,
//                         );
//                         copyToClipboard(
//                             context, 'https://www.facebook.com/amrm.hassan.10');
//                       },
//                       child: Image.asset(
//                         'assets/icons/intro/facebook.png',
//                         width: largeIconSize,
//                       ),
//                     ),
//                     HSpace(),
//                     ButtonWrapper(
//                       onTap: () {
//                         launchUrlString(
//                           'https://www.linkedin.com/in/amr-hassan-354985193/',
//                           mode: LaunchMode.externalApplication,
//                         );
//                         copyToClipboard(context,
//                             'https://www.linkedin.com/in/amr-hassan-354985193/');
//                       },
//                       child: Image.asset(
//                         'assets/icons/intro/linkedin.png',
//                         width: largeIconSize,
//                       ),
//                     ),
//                     HSpace(),
//                     ButtonWrapper(
//                       onTap: () {
//                         launchUrlString(
//                           'https://github.com/amrmhassan',
//                           mode: LaunchMode.externalApplication,
//                         );
//                         copyToClipboard(
//                             context, 'https://github.com/amrmhassan');
//                       },
//                       child: Image.asset(
//                         'assets/icons/intro/github.png',
//                         width: largeIconSize,
//                       ),
//                     ),
//                     HSpace(),
//                     ButtonWrapper(
//                       onTap: () {
//                         launchUrlString(
//                           'https://www.upwork.com/freelancers/~01249dbbc65be765ce',
//                           mode: LaunchMode.externalApplication,
//                         );
//                         copyToClipboard(context,
//                             'https://www.upwork.com/freelancers/~01249dbbc65be765ce');
//                       },
//                       child: Image.asset(
//                         'assets/icons/intro/upwork.png',
//                         width: largeIconSize,
//                       ),
//                     ),
//                   ],
//                 ),
//                 VSpace(factor: 2),
//                 GestureDetector(
//                   onTap: () {
//                     copyToClipboard(context, '+201147497502');
//                     launchUrlString(
//                       'https://wa.me/+201147497502',
//                       mode: LaunchMode.externalApplication,
//                     );
//                   },
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         'assets/icons/intro/whatsapp.png',
//                         width: largeIconSize,
//                       ),
//                       HSpace(),
//                       SelectableText(
//                         '+201147497***',
//                         style: h3LightTextStyle,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
