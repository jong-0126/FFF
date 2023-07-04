# FFF(FunFondFund)

<p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/프로젝트FFF2.png?raw=true"/></p>
<p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/FFF의미.png?raw=true"/></p>

인천일보 아카데미에서 진행한 팀 프로젝트 입니다.

음악 아티스트 펀딩 사이트 입니다.



# Description

- 개발 기간: 2023.02.27 ~ 2023.03.31 (약 5주)

- 참여 인원: 7명

- 사용 기술

<p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/사용한프로그램.png?raw=true"/></p>


  - Spring 4.0,  Apache Tomcat 9.0,  Tiles3,  BootStrap,  Mybatis,  Eclipse
  - Java,  Ajax,  Jquery,  MVC Pttern,JSP
  - Oracle 11g DataBase
  - CoolSMS,  Kakao Api

# 프로젝트 일정 및 데이터베이스 ERD

 <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/프로젝트 일정.png?raw=true"/></p>



 <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/프로젝트 ERd.png?raw=true"/></p>





- 담당 구현 파트

  - 프로젝트 개발환경 구축, 설계 참여 일정관리, 프로젝트 취합.

  - 펀딩 페이지, 관리자 페이지 구현

  - 펀딩 카테고리 페이지 구현(펀딩리스트. 장르별 정렬. 펀딩 마감처리.)

  - 펀딩 상세페이지 구현 (펀딩에 따른 후원금액 , 후원인원 증가. 티어별 가격 및 해택에 따른 결제 기능 구현, 결제 정보 생성) 
  
  - 펀딩, 공연예매 결제 기능 구현 (카카오 단편결제 API를 이용한 결제시스템 구현)

  - GitHub 레포지토리 생성


    

# Views

- **메인**

  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/메인화면.gif?raw=true"/></p>
  
  
  
  - **회원가입**

  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/휴대폰인증.gif?raw=true"/></p>




- **펀딩** 

   <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/펀딩상세.gif?raw=true"/></p>





- **공연 예매**

 <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/공연예매.gif?raw=true"/></p>



- **아티스트 SNS**

  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/sns페이지.gif?raw=true"/></p>


# Implementation

- #### 펀딩 리스트
  
  - **펀딩 리스트 출력 **
    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/펀딩리스트1.gif?raw=true"/></p>


    1. isotope 플러그인을 사용하여 장르별 정렬 기능 구현.

    2. JsonView를 설정해 Json형태로 데이터를 가져와 Ajax통신으로 펀딩 목록들 페이지에 출력.

  - **펀딩 마감처리 및 펀딩 정보 출력**
    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/펀딩 체크.png?raw=true"/></p>


    1. Oracle 배치 프로시저, 스케줄러를 사용하여 펀딩 마감처리, 후원 성공여부 판단.
    
    2. Java의 DecimalFormat클래스를 사용하여 천단위 콤마(금액 표기하기) 표기



 

------


- #### 펀딩 상세 페이지

  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/펀딩 상세페이지.png?raw=true"/></p>

  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/펀딩 상세페이지2.png?raw=true"/></p>
  
  <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/후원 티어1.png?raw=true"/></p>

  - **펀딩 상세페이지 정보 업데이트 및 예외**

    1. Mybatis 쿼리문을 이용하여 펀딩 게시글의 상세정보를 가져오고 JsonView를 설정하여 Json형태로  데이터를 가져와 Ajax 통신으로 펀딩 상세페이지를 구성.
    2. Mybatis 쿼리문을 이용하여 사용하여 후원 이후 해당 펀딩의 데이터베이스 현재 후원금액 및 후원인원 정보를 실시간으로 업데이트.
    3. Jquery를 사용하여 비회원일 경우, 펀딩 마감 이후 후원하기 기능 Block 처리


------


  - **펀딩 결제**
      <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/카카오결제.png?raw=true"/></p>


    1. Jquery를 사용하여 티어별 후원하기 클릭 시 해당하는 티어의 해택 정보 및 가격 가져오게 구현.
    2. 카카오페이 버튼 클릭시 카카오페이 단편결제 팝업창 표시. QR를 통하여 결제 진행. 
    3. 구매 완료시 카카오페이를 통한 결제완료 정보를  Json형태로 데이터를 가져와 Ajax 결제정보를 팝업창에 표기.


------       


- #### 공연 예매 리스트
  
  - **공연예매 리스트 출력 **
    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/공연리스트1.png?raw=true"/></p>
    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/공연리스트2.png?raw=true"/></p>


    1. isotope 플러그인을 사용하여 장르별 정렬 기능 구현.

    2. JsonView를 설정해 Json형태로 데이터를 가져와 Ajax통신으로 공연 목록들 페이지에 출력.
    3. Java File 클래스를 이용하여 해당하는 공연 리스트의 포스터, 브로셔 이미지 주소를 가져와 화면에 표기.


------

- #### 공연예매 상세 페이지


  - **공연예매 상세페이지 정보 업데이트 및 예외**

    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/공연예매 상세페이지.png?raw=true"/></p>
    <p align="center"><img src="https://github.com/jjwa2/-FFF/blob/master/이미지파일/공연예매 완료.png?raw=true"/></p>
    
    
    1. Mybatis 쿼리문을 이용하여 펀딩 게시글의 상세정보를 가져오고 JsonView를 설정하여 Json형태로  데이터를 가져와 Ajax 통신으로  상세페이지를 구성.
    2. Jquery를 사용하여 비회원일 경우, 공연 마감 이후 공연예매 기능 Block 처리
    3. 공연예매 이후 Java Mail 라이브러리를 통하여 공연티켓 정보 이메일 발송 처리. 

------




