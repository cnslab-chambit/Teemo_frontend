import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _pageController = PageController();
  final _nicknameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _currentPage = 0;
  String? _gender;
  DateTime? _birthDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.grey,
          ),
          onPressed: () {
            // 뒤로 가기 로직
            if (_currentPage > 0) {
              setState(() {
                _currentPage--;
              });
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('회원가입',
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 닉네임 설정 페이지
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "닉네임 설정",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "  - 5자 이상 20자 이하로 설정 가능합니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            TextSpan(
                              text: "  - 한글, 영문, 숫자로만 구성해주세요\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            TextSpan(
                              text: "  - 타인에게 공개되는 정보입니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // 닉네임 입력 칸
                  SizedBox(
                    height: 50,
                    child: TextField(
                      controller: _nicknameController,
                      style: const TextStyle(color: Colors.grey),
                      decoration: InputDecoration(
                        hintText: '닉네임',
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // 다음 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 닉네임 유효성 검사 로직 구현
                      setState(() {
                        _currentPage++;
                      });
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Text('다음'),
                  ),
                ],
              ),
            ),
          ),
          // 성별 설정 페이지
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "성별 설정",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "  - 추후에 변경 불가합니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            TextSpan(
                              text: "  - 타인에게 공개되는 정보입니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // 성별 선택 버튼
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<String>(
                        value: '남성',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('남성'),
                      Radio<String>(
                        value: '여성',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                      const Text('여성'),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // 다음 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 성별 유효성 검사 로직 구현
                      setState(() {
                        _currentPage++;
                      });
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Text('다음'),
                  ),
                ],
              ),
            ),
          ),
          // 생년월일 설정 페이지
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "생년 월일",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "  - 추후에 변경 불가합니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            TextSpan(
                              text: "  - 타인에게 공개되는 정보입니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // 날짜 선택 버튼
                  GestureDetector(
                    onTap: () async {
                      final date = await showCupertinoModalPopup<DateTime>(
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 200.0,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.date,
                              initialDateTime: DateTime.now()
                                  .subtract(const Duration(days: 365 * 20)),
                              minimumDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 100)),
                              maximumDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 10)),
                              onDateTimeChanged: (date) {
                                setState(() {
                                  _birthDate = date;
                                });
                              },
                            ),
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _birthDate = date;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        _birthDate == null
                            ? '날짜 선택'
                            : '${_birthDate!.year}년 ${_birthDate!.month}월 ${_birthDate!.day}일',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // 다음 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 생년월일 유효성 검사 로직 구현
                      setState(() {
                        _currentPage++;
                      });
                      _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                    },
                    child: const Text('다음'),
                  ),
                ],
              ),
            ),
          ),
          // 아이디, 비밀번호 설정 페이지
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "아이디 / 비밀번호",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "  - 아이디는 추후에 변경 불가합니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            TextSpan(
                              text: "  - 타인에게 공개되지 않는 정보입니다.\n",
                              style: TextStyle(
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  // 아이디 입력 칸
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: '아이디',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // 비밀번호 입력 칸
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: '비밀번호',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // 회원가입 버튼
                  ElevatedButton(
                    onPressed: () {
                      // 회원가입 로직 구현
                      Navigator.pop(context);
                    },
                    child: const Text('회원가입'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 8.0,
              backgroundColor:
                  index == _currentPage ? Colors.grey[800] : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }
}
