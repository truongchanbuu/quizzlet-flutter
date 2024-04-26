import 'package:flutter/material.dart';

buildPolicyAlertText() {
  return RichText(
    textAlign: TextAlign.center,
    text: const TextSpan(
      children: [
        TextSpan(
          text: 'Bằng việc đăng ký, tôi chấp thuận ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: 'Điều khoản dịch vụ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: ' và ',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: 'Chính sách quyền riêng tư',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: ' của Quizzlet',
          style: TextStyle(
            color: Colors.black,
          ),
        )
      ],
    ),
  );
}
