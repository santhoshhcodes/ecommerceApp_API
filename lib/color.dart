import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  primarySwatch: Colors.blue,

  // AppBar theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey,
    foregroundColor: Colors.white,
    elevation: 2,
  ),



//card
  cardTheme: CardThemeData(
    color: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.3),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),

  // Text theme
  textTheme: GoogleFonts.poppinsTextTheme(
  const TextTheme(
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 16),
    bodySmall: TextStyle(color: Colors.black54, fontSize: 14),
  )
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: Colors.blue,
    size: 28,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,

  // AppBar theme
  appBarTheme: AppBarTheme(
    //backgroundColor: Colors.grey,
    foregroundColor: Colors.white,
    elevation: 2,
  ),

  // Card theme
  cardTheme: CardThemeData(
    color:  Colors.white.withOpacity(0.1),
    shadowColor: Colors.black.withOpacity(0.10),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),

  // Text theme
  textTheme: GoogleFonts.poppinsTextTheme(
  const TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
    bodySmall: TextStyle(color: Colors.white, fontSize: 14),
  )
  ),

  // Icon theme
  iconTheme: const IconThemeData(
    color: Colors.white70,
    size: 28,
  ),
);
