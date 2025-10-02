import 'package:flutter/material.dart';
import 'package:smart_helmet/aboutUs/web_view.dart';
import 'package:smart_helmet/global/constant.dart';

class TeamMember {
  final String name;
  final String role;
  final String photoUrl;
  final String portfolioUrl;

  TeamMember(
      {required this.portfolioUrl,
      required this.name,
      required this.role,
      required this.photoUrl});
}

class MeetOurTeamPage extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
        name: "Kalkidan Birhanu",
        role: "Electircal Engineer",
        photoUrl: "assets/images/kalkidan.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/kalbirhanu/home"),
    TeamMember(
        name: "Mezmur Yichalewal",
        role: "Electro-Mechanical Engineer",
        photoUrl: "assets/images/mezmur.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/mezmurs-portfolio/home"),
    TeamMember(
        name: "Kaleb Tesfaye",
        role: "Civil Engineer",
        photoUrl: "assets/images/kaleb.jpg", // Replace with actual photo URL
        portfolioUrl:
            "https://sites.google.com/view/ietp-project-kaleb-tesfaye/home"),
    TeamMember(
        name: "Mahider Jemere",
        role: "Software Engineer",
        photoUrl: "assets/images/mahider.jpg", // Replace with actual photo URL
        portfolioUrl:
            "https://sites.google.com/aastustudent.edu.et/mahiders-portfolio/home"),
    TeamMember(
        name: "Eyerusalem Gashaw",
        role: "Electircal Engineer",
        photoUrl: "assets/images/eyerus.jpg", // Replace with actual photo URL
        portfolioUrl:
            "https://sites.google.com/view/eyerusalem-gashaw?usp=sharing"),
    TeamMember(
        name: "Helina Alemayehu",
        role: "Electircal Engineer",
        photoUrl: "assets/images/hilena.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/helinaportifolio/home"),
    TeamMember(
        name: "Betselot Tesfa",
        role: "Software Engineer",
        photoUrl: "assets/images/betselot.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/betselot-portfolio/home"),
    TeamMember(
        name: "Nahom Ketsela",
        role: "Software Engineer",
        photoUrl: "assets/images/nahom.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/nahom-ketsela/home"),
    TeamMember(
        name: "Desalegn Lulie",
        role: "Electro-Mechanical Engineer",
        photoUrl: "assets/images/desalegn.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/desalegns-portfolio/home"),
    TeamMember(
        name: "Betanya Afewerk",
        role: "Civil Engineer",
        photoUrl: "assets/images/bitanya.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/betanyaa/home"),
    TeamMember(
        name: "Yiheyis Tamir",
        role: "Software Engineer",
        photoUrl: "assets/images/yiheyis.jpg", // Replace with actual photo URL
        portfolioUrl:
            "https://sites.google.com/view/yiheyis-portfolio/home?authuser=0"),
    TeamMember(
        name: "Khewlet Mohammed",
        role: "Electircal Engineer",
        photoUrl: "assets/images/khewlet.jpg", // Replace with actual photo URL
        portfolioUrl: "https://sites.google.com/view/khewlet-mohammed/home"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 2,
        title: Text("Meet Our Team"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two members per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            final member = teamMembers[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HelmetWebView(url: member.portfolioUrl),
                ));
              },
              child: Card(
                color: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(member.photoUrl),
                    ),
                    SizedBox(height: 10),
                    Text(
                      member.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Text(
                      member.role,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
