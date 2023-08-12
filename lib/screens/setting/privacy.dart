import 'package:flutter/material.dart';
import 'package:moa_app/constants/color_constants.dart';
import 'package:moa_app/constants/font_constants.dart';
import 'package:moa_app/widgets/app_bar.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    TextSpan subTitle(String text) {
      return TextSpan(
        text: '$text\n\n',
        style: const H4TextStyle(),
      );
    }

    TextSpan content({required String text, String? interval}) {
      return TextSpan(
        text: '$text${interval ?? '\n\n\n'}',
        style: const Body1TextStyle(),
      );
    }

    return Scaffold(
      appBar: const AppBarBack(
        title: '개인정보 처리방침',
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: RichText(
              text: TextSpan(
                  style: const TextStyle(color: AppColors.blackColor),
                  children: [
                const TextSpan(
                  text: '‘MOA’ 개인정보취급방침\n\n',
                  style: H3TextStyle(),
                ),
                content(
                    text:
                        '‘MOA’는 통신비밀보호법, 전기통신사업법, 정보통신망 이용촉진 및 정보보호 등에 관한 법률 등 정보통신서비스제공자가 준수하여야 할 관련 법령상의 개인정보보호 규정을 준수하며, 관련 법령에 의거한 개인정보취급방침을 정하여 이용자 권익 보호에 최선을 다하고 있습니다.'),
                subTitle('1. 개인정보의 수집 및 이용목적'),
                content(
                    text:
                        '개인정보는 생존하는 개인에 관한 정보로서 서비스 이용자를 식별할 수 있는 정보(당해 정보만으로는 특정개인을 식별할 수 없더라도 다른 정보와 용이하게 결합하여 식별할 수 있는 것을 포함)를 말합니다. ‘MOA’ 수집한 개인정보는 ‘MOA’ 서비스의 기본 기능 제공을 목적으로 활용합니다.'),
                subTitle('2. 수집하는 개인정보의 항목 및 수집방법'),
                content(
                    text:
                        '가. 수집하는 개인정보의 항목\n‘MOA’은 회원가입, 스터디 신청 등을 위해 아래와 같은 개인정보를 수집하고 있습니다.\n- 구글 로그인 정보: ID, 비밀번호, 이메일, 닉네임\n- 네이버 로그인 정보: ID, 비밀번호, 이메일, 닉네임\n- 카카오 로그인 정보: ID, 비밀번호, 이메일, 닉네임\n- 애플 로그인 정보: ID, 비밀번호, 이메일, 닉네임\n- 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보\n나. 개인정보 수집방법\n다음과 같은 방법으로 개인정보를 수집합니다.\n- 홈페이지 회원가입(소셜 로그인 정보를 전달 받음), 피드백 전송\n- 서비스 사용 중 이용자의 자발적 제공을 통한 수집'),
                subTitle('3. 개인정보의 활용'),
                content(
                    text:
                        '‘MOA’은 수집한 개인정보를 다음의 목적을 위해 활용합니다.\n- 회원 관리 회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 불만처리 등 민원처리, 고지사항 전달\n- 마케팅 및 광고에 활용, 신규 서비스(제품) 개발 및 특화, 이벤트 등 광고성 정보 전달, 인구통계학적 특성에 따른 서비스 제공 및 광고 게재, 접속 빈도 파악 또는 회원의 서비스 이용에 대한 통계'),
                subTitle('4. 개인정보의 보유 및 이용기간'),
                content(
                    text:
                        '이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.\n- ID, 비밀번호, 이메일, 닉네임, 서비스 이용기록, 접속 로그, 쿠키, 접속 IP 정보보존 이유 : 전자상거래등에서의 소비자보호에 관한 법률보존 기간 : 5년\n- 표시/광고에 관한 기록보존 이유 : 전자상거래등에서의 소비자보호에 관한 법률보존 기간 : 6개월\n- 계약 또는 청약철회 등에 관한 기록보존 이유 : 전자상거래등에서의 소비자보호에 관한 법률보존 기간 : 5년\n- 소비자의 불만 또는 분쟁처리에 관한 기록보존 이유 : 전자상거래등에서의 소비자보호에 관한 법률보존 기간 : 3년\n- 방문에 관한 기록\n보존 이유 : 통신비밀보호법\n보존 기간 : 3개월'),
                subTitle('5. 개인정보의 파기절차 및 방법'),
                content(
                    text:
                        '이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 개인정보 파기절차 및 방법은 다음과 같습니다.\n가. 파기절차\n- 이용자가 회원가입 등을 위해 입력한 정보는 목적이 달성된 후 별도의 DB로 옮겨져(종이의 경우 별도의 서류함) 내부 방침 및 기타 관련 법령에 의한 정보보호 사유에 따라(보유 및 이용기간 참조)일정 기간 저장된 후 파기됩니다.\n- 동 개인정보는 법률에 의한 경우가 아니고서는 보유되는 이외의 다른 목적으로 이용되지 않습니다.\n나. 파기방법\n- 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각을 통하여 파기합니다.\n- 전자적 파일 형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 삭제합니다.'),
                subTitle('6. 개인정보관리책임자 및 담당자의 연락처'),
                content(
                    text:
                        '‘MOA’ 서비스를 이용하며 발생하는 모든 개인정보보호 관련 민원을 개인정보관리책임자 혹은 담당부서로 신고하실 수 있습니다. ‘MOA’은 이용자들의 신고사항에 대해 신속하게 충분한 답변을 드릴 것입니다.\n- 이름 :\n- 연락처 :\n기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.\n- 개인정보침해신고센터 (www.118.or.kr / 118)\n- 정보보호마크인증위원회 (www.eprivacy.or.kr / 02-580-0533~4)\n- 대검찰청 첨단범죄수사과 (http://www.spo.go.kr / 02-3480-2000)\n- 경찰청 사이버테러대응센터 (www.ctrc.go.kr / 02-392-0330)'),
                subTitle('7. 고지의 의무'),
                content(
                    text:
                        '현 개인정보취급방침의 내용 추가, 삭제 및 수정이 있을 시에는 시행일자 최소 7일전부터 서비스 내 공지사항을 통해 공고할 것입니다.\n[시행일] 본 개인정보처리방침은 **2022년 7월 21일**부터 적용됩니다.'),
              ])),
        ),
      )),
    );
  }
}
