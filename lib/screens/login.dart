import 'package:flutter/material.dart';
import 'package:teemo_front/screens/signup.dart';
import 'package:teemo_front/screens/map.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _IdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 로고 이미지
              //Image.asset('assets/logo.png'),
              // 만남주선 어플리케이션
              const Text(
                '만남주선 어플리케이션',
                style: TextStyle(color: Colors.grey),
              ),
              // APP NAME
              const Text(
                'APP NAME',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              ),
              // 아이디입력
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _IdController,
                      decoration: const InputDecoration(hintText: '아이디'),
                    ),
                  ),
                  const Text('@'),
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(hintText: '이메일'),
                    ),
                  ),
                ],
              ),
              // 비밀번호 입력
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: '비밀번호'),
                obscureText: true,
              ),
              // 로그인버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    String memberId = _IdController.text;
                    //빈칸검사(아이디)
                    if (memberId.isNotEmpty) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MapScreen(memberId: memberId)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('아이디를 입력해주세요.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('로그인'),
                ),
              ),
              // 비밀번호 찾기
              TextButton(
                onPressed: () {
                  // 비밀번호 찾기 로직 구현
                },
                child:
                    const Text('비밀번호찾기', style: TextStyle(color: Colors.grey)),
              ),
              // 회원가입
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpPage()),
                  );
                },
                child: const Text('회원가입',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
