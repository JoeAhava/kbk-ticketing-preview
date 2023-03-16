
import 'package:flutter/material.dart';

class Validator{

 static String validatePhone(String value,context){
    if(!value.startsWith('+251')){
      return "The phone number must start with '+251'";
    }
    if(int.tryParse(value) == null){
      return "Please enter number only";
    }
    if(value.length != 13){
      return "Phone number must be 13 Digits, including the country code";
    }
    return null;
  }

  static String validatePassword(String value,BuildContext context, {bool isOtp = false}){
   if(isOtp){
     if (value.trim().isEmpty) {
       return "Enter the OTP";
     }
     if(value.length < 4){
       return "OTP is 4 or more characters";
     }
   }
   else{
     if (value.trim().isEmpty) {
       return "Enter your password";
     }
     if(value.length < 4){
       return "A minimum of 4 letters is required";
     }
   }
    return null;
  }

  static String validateConfirmationPassword(String newPassword,String confirmNewPassword,BuildContext context){
   if(newPassword != confirmNewPassword){
     return "Passwords don't match";
   }
   return null;
  }

 static String validateEmail(String email, BuildContext context){
   if (!email.contains("@")) {
     return "'@' should be in your email";
   }
   if (!email.contains(".")) {
     return "'.' should be in your email";
   }
   return null;
 }


 static String validateName(String name, BuildContext context){
   if (name.trim().isEmpty) {
     return "Please enter your name";
   }
   return null;
 }

}