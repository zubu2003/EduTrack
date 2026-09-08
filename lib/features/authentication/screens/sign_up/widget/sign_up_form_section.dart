import 'package:flutter/material.dart';
import 'package:edutrack/utils/constant/colors.dart';
import 'package:edutrack/utils/constant/size.dart';
import 'package:edutrack/utils/constant/text_strings.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widget/button/SElevatedbutton.dart';

class SignUpFormSection extends StatelessWidget {
  const SignUpFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Full Name
        TextFormField(
          decoration: InputDecoration(
            hintText: STextStrings.fullName,
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.user, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Student ID / Teacher ID
        TextFormField(
          decoration: InputDecoration(
            hintText: STextStrings.studentTeacherId,
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.document, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // University Email
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: STextStrings.universityEmail,
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.sms, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Department Dropdown
        Container(
          decoration: BoxDecoration(
            color: SColors.inputFieldBackground,
            borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: STextStrings.department,
              hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
              prefixIcon: const Icon(Iconsax.building, color: SColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
                borderSide: const BorderSide(color: SColors.primary, width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
            ),
            /// list of department
            items: const [
              DropdownMenuItem(
                value: "CSE",
                child: Text("CSE"),
              ),
              DropdownMenuItem(
                value: "EEE",
                child: Text("EEE"),
              ),
              DropdownMenuItem(
                value: "CE",
                child: Text("CE"),
              ),
              DropdownMenuItem(
                value: "ME",
                child: Text("ME"),
              ),
              DropdownMenuItem(
                value: "ETE",
                child: Text("ETE"),
              ),
              DropdownMenuItem(
                value: "BME",
                child: Text("BME"),
              ),
              DropdownMenuItem(
                value: "MIE",
                child: Text("MIE"),
              ),
              DropdownMenuItem(
                value: "WRE",
                child: Text("WRE"),
              ),
              DropdownMenuItem(
                value: "PME",
                child: Text("PME"),
              ),
              DropdownMenuItem(
                value: "MSE",
                child: Text("MSE"),
              ),
              DropdownMenuItem(
                value: "NE",
                child: Text("NE"),
              ),
            ],


            onChanged: (value) {},
            icon: const Icon(Iconsax.arrow_down_1, color: SColors.grey),
            dropdownColor: SColors.white,
            style: TextStyle(color: SColors.textPrimary),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Password
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: STextStrings.password,
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.lock, color: SColors.grey),
            suffixIcon: const Icon(Iconsax.eye_slash, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwItems),

        // Confirm Password
        TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: STextStrings.confirmPassword,
            hintStyle: TextStyle(color: SColors.textSecondary.withOpacity(0.7)),
            prefixIcon: const Icon(Iconsax.lock, color: SColors.grey),
            suffixIcon: const Icon(Iconsax.eye_slash, color: SColors.grey),
            filled: true,
            fillColor: SColors.inputFieldBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(SSize.inputFieldRadius),
              borderSide: const BorderSide(color: SColors.primary, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          ),
        ),

        const SizedBox(height: SSize.spaceBtwSections),

        // Create Account Button
        SizedBox(
          width: double.infinity,
          height: SSize.buttonHeight,
          child: SElevatedbutton(
            text: "Create Account",
            onPressed: () {},

          ),
        ),
      ],
    );
  }
}