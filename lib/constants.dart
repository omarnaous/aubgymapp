import 'dart:ui';

class ConstantsClass {
  static String aubImageLink = "Assets/building.png";

  static String aubLogoLink = 'Assets/aublogo.png';

  static String reserve = 'Assets/reserve.png';

  static Color themeColor = const Color(0xFF850132);

  // Adjust opacity as needed
  static Color secondaryColor = const Color.fromRGBO(133, 1, 50, 0.35);

  static List homePageListItems = [
    "Enter GYM",
    "Leave GYM",
    "GYM",
    "Facilities",
    "Classes",
    "Private Sessions",
    "Tutorials"
  ];

  static List<String> timeSlots = [
    '6:30 AM - 8:00 AM',
    '8:00 AM - 9:30 AM',
    '9:30 AM - 11:00 AM',
    '11:00 AM - 12:30 PM',
    '12:30 PM - 2:00 PM',
    '2:00 PM - 3:30 PM',
    '3:30 PM - 5:00 PM',
    '5:00 PM - 6:30 PM',
    '6:30 PM - 8:00 PM',
    '8:00 PM - 9:30 PM',
  ];

  static List<String> onehourtimeslot = [
    '6:30 AM - 7:30 AM',
    '7:30 AM - 8:30 AM',
    '8:30 AM - 9:30 AM',
    '9:30 AM - 10:30 AM',
    '10:30 AM - 11:30 AM',
    '11:30 AM - 12:30 PM',
    '12:30 PM - 1:30 PM',
    '1:30 PM - 2:30 PM',
    '2:30 PM - 3:30 PM',
    '3:30 PM - 4:30 PM',
    '4:30 PM - 5:30 PM',
    '5:30 PM - 6:30 PM',
    '6:30 PM - 7:30 PM',
    '7:30 PM - 8:30 PM',
    '8:30 PM - 9:30 PM',
  ];

  List imagesList1 = [
    "Assets/warup.png",
    "Assets/Fullbody.png",
    "Assets/lower.png",
    "Assets/core.png",
    "Assets/forearm.png",
    "Assets/legss.png"
  ];

  List imagesList2 = [
    "https://s3-alpha-sig.figma.com/img/b9f0/7782/954a7237bd08f8c2e3426d66c5b42ab5?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Ta182TX2pEti6dZpkUULuUtT~LdvUdFE5Dobf6TmM616HOr7LppdXqNCz7tvBp09fFDDohANssiBwLodeMBSTwSfLVe2QeaGnAeTiCZfwUlq6cHLrC4uVI59nvLE2T3qmemUfONEdYLxaVGLAP-5ucU~XSB2ByhBjEiXm7OsjAEvYFYwMQukBeTKEUe5mGgXbeYYonnVOQIBbkH-F5WwsjzLvlo-EAxi1jSu0JVsfNjCUoxgBUnxofeT62JBjaI8YYXDLGfPVNlXEXcTqLLLgcdAcy3yMZrvrLxIETCWtMPP91vezp~EYYj1TkxL33JwcbOiZdS-0CseRQeg3SA75A__",
    "https://s3-alpha-sig.figma.com/img/6f00/4b32/409172bd88dfba95b7c3daf43401ffff?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IRbQuCp6MzxYGCM6l-iRb-sTZCzI~6QsNsAeizleANhW6Ah6KAqcPIvxeiAMwkKO8YVqe2Z9STqIQhKkK8i56a3R9illbEhITZmt3LyN3HxoDcJaqb5Q8KyzeLZ6PTgvS4zaVH96QuQGGpjiX3jf1MToAu~SHBoZK9VNClNfwBogZ4MHCq0KqEVLTCSVkKDQ8vuX5fGyuz3BeCXtKgU1XJ~vPTND5w20IFECH58XRSE6EsoBsJ8TETwb9~i3ijVk-fAhP9s~~JDrtHAruMJPX8e3oFjApmW30qHtIjaouP7XQYJdwh1YLZ4kbowN7mIrcxDCBkmsi9~DOvNinazAxw__",
    "https://s3-alpha-sig.figma.com/img/2397/e220/ac5c47601b1fa2c6021ab13434692f1e?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Ml6EwCzIsohIhN3LTAftNAxxyou-li97bHMBVGNqLOV5Z1E3PCDY3hDzIDDypuVPqBkmQNNTPzE5o-F6~bBVP6~G8dg1mEPxVUyXbE5XmYeAj1XX50Pc7U17jed3~2x~~M07-bpHVCMC-qViIedq7ONSH7swV0sGTLlzh12v65kcqp6d2AuXBHWf3pH0OlrD-lqQME0R3h4b~HXY7U83ytk5VIWKvRusoudPkWFf3zBsHRVywLSGJe-HE~WkWY8l~ZHmaq1oRMQyVaMDhyyemgU8PmEYrUA4wfj0UpqC0IfMUSgC5hWvjnwwnaT3FGfMLmD0Rj7XDdPChOkGSgtjvA__",
    "https://s3-alpha-sig.figma.com/img/4dc9/53ed/e9fda02a2890090625e11086e095334f?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ZH8VdOzFT60NkaCziC2UEmsQ0Dwr9WqsENXjUl2FLfzfu2sOaNC8OlNIHEHnl3O9fHatKpRNMIfcB2PoLDtr1k0rE02X-HinSQ7y3ddEaQW3~9sAO21rdfPHguudusirFv4804LaVuuMuvMO~Vmh79QV3~--4HF81F28eacsIAecXMll6PaYfXsB5YcygKWBvL2z2yI8t7RoD75btvBZqUYmZGZ-b8AKKbFF3eCNqh~eInlFnL~lmxhykn0N9AV86ANWP~4s~j5L5TU9atcP2q6kznZPvcKDAvEcwLlkhK7fL-cOkSbDjGXFUajfN962les2T2gnVjHvqL3iZG~e7A__",
    "https://s3-alpha-sig.figma.com/img/727a/3ec4/fdc00e0690e0c0d0067473dc88ffbf27?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=QgY-8-RdGvCgazF~oFTW3v4FfpFic3Rxwn2NRcL2poYT8AESq2Cx-GXftNoNyuSCMR188TfHQkx8NV9pMUBAgb25yD1IQGYHk7B8SrbJAxlykUvRlTXy85h77LocULoaMb6WVpMmeyJZjsuLh59ibitZ2anBNYTbjG8WSRL6tgDXMNydbsEAawtpuXleG5Dk9AspJ6luw2SvnkVBO~oBhl2BGXdykTbvGPyw5Xz2CAlLJz3DNEOHe~bUW4Ey2kX6FMrP1LB94FKKl1g~3QvlEtymreuEyjJvAJAjOMg-eYw9nLfvOxqazv07kiTFdKJZTc2zloaZJvpaTzEWJ5ndRQ__",
    "https://s3-alpha-sig.figma.com/img/c11b/7c91/aea5dae99bca70e088152788053f98ff?Expires=1711324800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=KZHJcjiK7VwDew9kollr75OdQ1brMualUi4v6WIw3IOVLlZZtw8BLQo2F7DFBXq0VETP-buM35jGZ3~UPjCS0ERixewlFalT1gyZ6jmnhyHKNUjimw0Obj94gpt05LxR4h0Ja4KzvwUWs--6QAj83H8Ek82j9sRsGr-EpCmZxmlcB9HIDUXB8OSnrfbQevciICYg03Srw-DJWVzyFhEeueB5z72m8~XfeyvnuxxEZksNQ31U~oLEvveYiYbOf2dJdnnMui5fiHkMY004CdVVrEB9jq9qi0CKNOcBvyJ1CRFabY6ftoYiguc2U30Va93WWIgkT0TV8bGhhc3OMx7dTw__",
  ];

  List textList1 = [
    "Warm Up",
    "Full Body",
    "Lower Body",
    "Core",
    "Forearm",
    "Legs"
  ];
  List linksList1 = [
    "https://www.youtube.com/watch?v=VecbXgWY0DI&pp=ygUPbWFsZSB3YXJtdXAgZ3lt",
    "https://www.youtube.com/watch?v=eTxO5ZMxcsc&feature=youtu.be",
    "https://www.youtube.com/watch?v=YPLopuFxz-0&pp=ygUTbWFsZSBsb3dlciBib2R5IGd5bQ%3D%3D",
    "https://www.youtube.com/watch?v=QdIutxfm_hU",
    "https://www.youtube.com/shorts/YEyFdtni3uU",
    "https://www.youtube.com/watch?v=AQLG6YCOavI"
  ];
  List linksList2 = [
    "https://www.youtube.com/watch?v=oLu9kwDzBdg",
    "https://www.youtube.com/watch?v=jjUyJufUKL8",
    "https://www.youtube.com/watch?v=nBhdmoJbxwc",
    "https://www.youtube.com/watch?v=qfWx1EPdhwE",
    "https://www.youtube.com/watch?v=uXUzDclr644",
    "https://www.youtube.com/watch?v=ZZI__bqlBkQ"
  ];
}

// Pass AubAdmin123