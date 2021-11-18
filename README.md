# Music Player

네이버 부스트코스의 프로젝트 A (http://www.boostcourse.org/mo326/lecture/256081)

# 프로젝트 분석

## 레이아웃

1. 모든 뷰가 가로 중앙 정렬된다.

2. 기기를 회전해도 비율 유지된다.

3. - 버튼과 타이머는 크기 유지된다.

4. - Seek Bar는 양 옆 margin이 유지된다.

## 기능

1. 버튼을 누르면 음원이 play/pause가 되고 아이콘이 바뀐다.
2. 음원 진행 사항에 따라 Slider와 타이머가 변경된다.
3. Slider를 움직이면 타이머 숫자가 변경된다.
4. Slider를 움직이는 동안은 음원이 계속 재생된다.
5. Slider를 놓으면 해당 지점으로 음원이 점프된다.

# 작업 기록

## 2021-11-17

- 이미지 에셋 추가 (https://jeong9216.tistory.com/143)

## 2021-11-18

- 화면 구성 : UIButton, UILabel, UISlider 추가
- 인터페이스 빌더 객체와 코드를 연결
