class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "TrackScore",
    image: "assets/images/1.png",
    desc:
        "Play, record, and relive the moments that make your game extraordinary.",
  ),
  OnboardingContents(
    title: "Game Insight",
    image: "assets/images/2.png",
    desc:
        "Dive into the game like never before - Uncover player and team insights that redefine your football experience.",
  ),
  OnboardingContents(
    title: "Targeted Triumphs",
    image: "assets/images/3.png",
    desc:
        "Discover your game changer with precision - where targeted ads redefine your journey to victory.",
  ),
];
