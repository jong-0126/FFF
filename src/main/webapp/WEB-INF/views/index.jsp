<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<!-- 웹 페이지가 Internet Explorer 브라우저에서 렌더링 될 때, 사용할 호환성 모드를 지정 
	   페이지가 렌더링 될 때 오래된 호환성 모드를 사용하는 데에서 발생할 수 있는 문제를 예방할 수 있습니다. -->
<meta http-equiv="X-UA-Compatible" content="IE=edge"> 
<!-- 웹 페이지의 뷰포트 설정을 정의합니다.
 	  웹 페이지가 다양한 기기 및 화면 크기에 적절하게 맞춰진 너비와 확대/축소 정도를 사용하도록 설정합니다 -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="https://unpkg.com/aos@2.3.1/dist/aos.css"> 
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script> 


<!-- 메인페이지 관련 CSS 링크 -->
<link rel="stylesheet" href="/resources/style/index-main.css">
<link rel="stylesheet" href="/resources/style/login.css">

  
<!-- 풋터에 필요한 CDN -->
<link href="https://fonts.googleapis.com/css2?family=Tourney:ital,wght@1,100&display=swap" rel="stylesheet">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Do+Hyeon&family=Noto+Serif+KR:wght@300&display=swap" rel="stylesheet">

<%@  include file="/WEB-INF/views/include/head.jsp" %>

<title>mainPage</title>


<script type="text/javascript">

$(document).ready(function() {
	  
	// AOS 라이브러리 초기화 : 스크롤 애니메이션 효과를 지원하는 AOS 라이브러리를 초기화 
	
    AOS.init({
        duration: 1000, //애니메이션 지속시간 설정
        easing: 'ease-in-out', // 이징(easing) 이 "ease-in-out"으로 설정됩니다.애니메이션의 시작 부분에서는 가속되었다가 중간 구간에서는 일정한 속도를 유지하고, 마지막 부분에 다다를 때 다시 속도가 감속되어 아주 부드러운 전환 효과가 나타나게 됩니다.
        once: true // "once: true"를 통해 애니메이션이 한 번만 실행됩니다.
    });
    
    const images = ['/resources/images/bg-img/bg-3.jpg', '/resources/images/bg-img/bg-2.jpg', '/resources/images/bg-img/bg-1.jpg'];
    
    let currentIndex = 0; // 현재 이미지 인덱스를 추적하는 변수 'currentIndex'를 초기화합니다.

    function changeImage() {	// 이미지 바꾸기 함수 정의
      currentIndex++;			
      if (currentIndex >= images.length) {		//currentIndex가 이미지 개수보다 같거나 커지면 0으로 초기화
        currentIndex = 0;
      }
      const imgElement = document.querySelector('.main-item-image'); //'.main-item-image' 선택자를 통해 이미지 엘리먼트를 찾아, 이미지 소스를 번갈아가며 변경합니다.
      imgElement.classList.remove('active');
      setTimeout(() => {
        imgElement.src = images[currentIndex];
        if (currentIndex !== 0) {
          imgElement.classList.add('active');
        }
      }, 500);
    }

    setInterval(changeImage, 5000);

    setInterval(changeImage, 5000);
    
  
	$("#loginbtn").on("click",function(){
		$("#userId").focus();
	});
	
	$("#userId").on("keypress", function(e){
		
		if(e.which == 13)	//엔터키인 경우
		{	
			fn_loginCheck();
		}
		
	});
	
	$("#userPwd").on("keypress", function(e){
		
		if(e.which == 13)	//엔터키인 경우
		{	
			fn_loginCheck();
		}
		
	});
	
	//로그인 버튼 선택시
	$("#Login").on("click", function() {
		fn_loginCheck();
	});
	
});

//로그인 체크
function fn_loginCheck(){
	
	if($.trim($("#userId").val()).length <= 0){	//$.trim(): 가져온 문자열 값에서 앞뒤로 있는 공백 문자를 제거합니다. val(): 해당입력 필드의 값을 가져옴
		
		alert("아이디를 입력하세요.");
		$("#userId").val("");
		$("#userId").focus();
		return;
	}
	
	if($.trim($("#userPwd").val()).length <= 0){
		
		alert("비밀번호를 입력하세요.");
		$("#userPwd").val("");
		$("#userId").focus();
		return;
	}
	
	$.ajax({
		type: "POST",					//HTTP method (여기서는 "POST")를 설정합니다.
		url: "/user/login", 			// 서버에 전송할 요청 URL (/user/login)을 설정합니다.
		data:{							// userID와 userPwd 항목의 값을 전송할 객체를 설정합니다.
			userId: $("#userId").val(),
			userPwd: $("#userPwd").val()
		},
		datatype:"JSON",				//응답 데이터 유형을 JSON으로 설정합니다.
		beforeSend:function(xhr){		//요청을 보내기 전에 수행할 작업을 정의합니다.
			xhr.setRequestHeader("AJAX", "true");	//여기서는 요청 헤더 "AJAX"를 "true"로 설정합니다.
		},
		success:function(response){		//요청이 성공적으로 완료된 경우 실행할 콜백 함수를 정의합니다.
										//이 함수는 서버로부터 받은 응답을 처리하는 데 사용됩니다.
			if(!icia.common.isEmpty(response))	//서버 응답이 비어 있지 않은 경우에만 아래의 작업을 수행합니다:
				{
					icia.common.log(response);
					
					var code = icia.common.objectValue(response, "code", -500);	//응답 객체로부터 코드 값을 가져옵니다. 기본값은 -500입니다.
					
					if(code == 0){
						location.href = "/index";
					}
					else{
						if(code == -1){
							alert("비밀번호가 올바르지 않습니다.");
							$("userId").focus();
						}
						else if(code == 404){
							alert("아이디와 일치하는 사용자 정보가 없습니다.");
							$("userId").focus();
						}
						else if(code == 400){
							alert("파라미터 값이 올바르지 않습니다.");
							$("userId").focus();
						}
						else if(code == 700){
							alert("탈퇴된 회원입니다.");
							$("userId").focus();
						}
						else{
							alert("오류가 발생했습니다.");
							$("#userId").focus();
						}
					}
				}
			else{
				alert("오류가 발생하였습니다.");
				$("#userId").focus();
			}
		},
		error:function(xhr, status, error){	//요청이 실패한 경우 실행할 콜백 함수를 정의합니다. 
			icia.common.error(error);		//여기서는 에러를 출력합니다.
		}
		
	});
}

//아이디 7일 저장
$(document).ready(function(){
	
	// 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 저장된 쿠키 값이 없으면 공백처리
	var key = getCookie("key");
	$("#userId").val(key);
	
	// 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
	if($("#userId").val() != ""){
		$("#checkId").attr("checked", true);	// ID 저장하기를 체크 상태로 두기.
	}
	
	//"ID 저장하기" 체크박스의 상태를 변경할 때 쿠키를 설정하거나 삭제합니다.
	$("#checkId").change(function(){
		if($("#checkId").is(":checked")){
			setCookie("key", $("#userId").val(), 7);
		}else{
			deleteCookie("key");
		}
	});
	
    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
    $("#userId").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
        if($("#checkId").is(":checked")){ // ID 저장하기를 체크한 상태라면,
            setCookie("key", $("#userId").val(), 7); // 7일 동안 쿠키 보관
        }
    
    });
    
    $("#idFind").on("click",function(){
    	location.href="/user/idFind";
    }); 
    
    $("#pwFind").on("click",function(){
    	location.href="/user/pwFind";
    }); 
	
});

// 쿠키 저장하기 
// setCookie => saveid함수에서 넘겨준 시간이 현재시간과 비교해서 쿠키를 생성하고 지워주는 역할
function setCookie(cookieName, value, exdays) {
	var exdate = new Date();					//exdate 변수를 생성하여 현재 날짜를 저장합니다.
	exdate.setDate(exdate.getDate() + exdays);	//exdate.setDate() 메서드를 사용해 만료 날짜를 설정합니다. 현재 날짜에 exdays를 더합니다.
	var cookieValue = escape(value)				//cookieValue 변수를 설정합니다. 
			+ ((exdays == null) ? "" : "; expires=" + exdate.toGMTString()); //주어진 값(value)의 이스케이프 문자로 된 문자열과 만료일을 설정합니다. 
																			 //만료일이 주어지지 않은 경우(exdays == null), 만료일 필드에 빈 문자열을 설정합니다.
	document.cookie = cookieName + "=" + cookieValue;
}

// 쿠키 삭제
//이렇게 하면 "username"이란 이름의 쿠키가 삭제됩니다. 
//실제로 쿠키는 삭제되지 않지만, 만료 날짜를 과거로 설정함으로써 브라우저에서 해당 쿠키를 무시하도록 합니다.
function deleteCookie(cookieName) {
	var expireDate = new Date();						//expireDate 변수를 생성하여 현재 날짜를 저장합니다.
	expireDate.setDate(expireDate.getDate() - 1);		//expireDate.setDate() 메서드를 사용해 만료 날짜를 설정합니다. 이때 현재 날짜에서 1일을 빼서 과거로 설정합니다.
	document.cookie = cookieName + "= " + "; expires="	//마지막으로 document.cookie를 설정하여 쿠키를 삭제 처리합니다.
			+ expireDate.toGMTString();					// 이때 쿠키 이름을 지정하고 해당 쿠키의 만료 날짜를 과거로 설정합니다.
}

// 쿠키 가져오기
function getCookie(cookieName) {
	cookieName = cookieName + '=';		// '='을 추가하는 이유 : 나중에 전체 쿠키 문자열에서 쿠키 값을 찾는 데 사용할 수 있습니다.
	var cookieData = document.cookie;	// cookieData 변수에 현재 웹 문서에서 사용할 수 있는 모든 쿠키의 문자열을 저장합니다.
	var start = cookieData.indexOf(cookieName); // start 변수에 cookieName이 시작하는 쿠키 데이터의 인덱스 위치를 저장합니다. 쿠키가 존재하지 않으면 -1이 반환됩니다.
	var cookieValue = '';
	if (start != -1) { // 쿠키가 존재하면
		start += cookieName.length;	// start 변수에 저장된 인덱스를 쿠키 이름의 길이만큼 증가시킵니다. 이렇게 하면 쿠키 값의 시작 인덱스를 얻게 됩니다.
		var end = cookieData.indexOf(';', start);	//end 변수에 ';' 문자의 인덱스 위치를 저장합니다. ';' 문자는 쿠키 값이 끝나는 지점을 나타냅니다. ';' 문자가 없는 경우, 즉 마지막 쿠키인 경우 -1이 반환됩니다.
		if (end == -1) 				// 만약 end가 -1인 경우, 즉 ';' 문자가 없는 경우, end에 쿠키 데이터 문자열의 길이를 설정하여 마지막 쿠키 값의 끝 인덱스를 얻습니다.
			end = cookieData.length;	
		cookieValue = cookieData.substring(start, end);	//쿠키 값의 시작 인덱스인 start와 끝 인덱스인 end 사이의 부분 문자열을 cookieValue 변수에 저장합니다. 이것은 해당 쿠키의 값을 나타냅니다.
	}
	return unescape(cookieValue); //저장된 cookieValue 값을 반환하기 전에 unescape 함수를 사용하여 이스케이프된 문자를 복원합니다. 결과적으로 원래 쿠키 값이 반환됩니다.
}

function fn_fdView(fdBbsSeq)
{
	document.bbsForm.fdBbsSeq.value = fdBbsSeq;	 //폼 요소의 fdBbsSeq 필드의 값을 인수로 전달된 fdBbsSeq 값으로 설정합니다. 이렇게 하면 특정 값이 폼 필드에 입력되게 됩니다.
	document.bbsForm.action = "/funding/fdView"; //폼의 액션 속성을 "/funding/fdView"로 변경합니다. 이를 통해 폼 데이터가 이 URL로 전송되도록 설정합니다. 액션 속성은 폼 데이터를 처리할 서버 측 웹 페이지나 프로그램의 URL을 가리킵니다.
	document.bbsForm.submit();					 //변경된 액션 주소와 함께 폼을 전송합니다. 이를 통해 서버에 폼 데이터가 전송되면서 페이지 이동이 발생합니다.
}

</script>

</head>


<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp" %>
	<div class="main-background">
	  <img class="main-item-image active" src="/resources/images/bg-img/bg-4.jpg">
	  <img class="main-item-image" src="/resources/images/bg-img/bg-2.jpg">
	  <img class="main-item-image" src="/resources/images/bg-img/bg-3.jpg">
	  <div class="main-image">
	    <div class="main-item">
	      <span class="main-item3">함께 만드는 공연펀드 사이트</span>
	      <h4 class="main-title main-sub">FUN, FOND, FUND<BR></h4>
	    </div>
	  </div>
	</div>
	
	<div class="main-fundinglist">
    	
	    <div class="main-fundinglist-banner-container">
	     <img class="main-fundinglist-banner" src="/resources/images/therise5_z.jpg">
	    </div>
    
		<div class="main-fundinglist-title">
			R E C E N T
		</div>

      	<div class="main-fundinglist-recent-contain" data-aos="zoom-in">
	       	<c:forEach items="${wrapper.recent}" var="board">
	      
	      		<div class="main-fundinglist-recent">
		      		<a href="javascript:void(0)" class="fdList" onclick="fn_fdView(${board.fdBbsSeq})">
			      		<div class="main-fundinglist-recent-imagebox">
			      			<img class="main-fundinglist-recent-image" src="/resources/upload/${board.fdFileName}">
			      		</div>
	     		 	</a>
			      	<div class="main-fundinglist-recent-content">
			      		펀딩콘텐츠<br>
			      		${board.userId} - ${board.fdBbsTitle}
			      	</div>
	     	 	</div>
	      	</c:forEach>
      	</div>
      	
		<div class="main-fundinglist-subtitle">
			R E C O M M E N D
		</div>
      
       	<div class="main-fundinglist-recommend-contain">
			<c:forEach items="${wrapper.recommend}" var="bborad">
	    		<div class="main-fundinglist-recommend" data-aos="fade-up" data-aos-duration="1000">
	        		<a href="javascript:void(0)" class="fdList" onclick="fn_fdView(${bborad.fdBbsSeq})">
	      				<div class="main-fundinglist-recommend-imagebox">
	      					<img class="main-fundinglist-recommend-image" src="/resources/upload/${bborad.fdFileName}">
	      				</div>
	      			</a>
		      		<div class="main-fundinglist-recommend-content">
		      			펀딩콘텐츠<br>
		      			${bborad.userId} - ${bborad.fdBbsTitle}
		      		</div>
	      		</div>
	      </c:forEach>
      </div>
    </div>
    
    <div class="main-artistlist">
    	<div class="main-artistlist-title">
      		A R T I S T
      	</div>
      
     	<div class="main-artistlist-main">
        	<div class="main-artistlist-main-recommend-contain">
				<c:forEach var="Main" items="${mainArtist}" varStatus="status">	
	        		<div class="main-artistlist-main-recommend" data-aos="zoom-in">
	      				<div class="main-artistlist-main-recommend-imagebox">
	      					<img class="main-artistlist-main-recommend-image" src="/resources/upload/${Main.fileProfileName}">
	      				</div>
	      				<div class="main-artistlist-main-recommend-content">
	      					${Main.userCategoly}<br>
	      					${Main.userId} - ${Main.userIntroduce}
	      				</div>
	      			</div>
	      		</c:forEach>
      		</div>
    	</div>
		<%@ include file="/WEB-INF/views/include/footer.jsp" %>
	</div>
	
	<!--로그인 모달 창-->
    <div class="modal fade" id="exampleModal" tabindex1="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    	<div class="modal-dialog">
        	<div class="modal-content">
            	<div class="background-wrap">
              		<div class="background"></div>
            	</div>
            	<form id="accesspanel" class="accesspanel" action="login" method="post">
              		<h1 id="litheader">FFF</h1>
              		<div class="inset">
                		<p>
                  			<input type="text" name="userId" id="userId" placeholder="ID">
                		</p>
                		<p>
                  			<input type="password" name="userPwd" id="userPwd" placeholder="Password">
                		</p>
                		<div style="text-align: center;">
                  			<div class="checkboxouter">
                    			<input type="checkbox" name="rememberme" id="checkId" value="Remember">
                    			<label class="checkbox"></label>
                  			</div>
                  			<label for="remember">Remember me for 7 days</label>
                		</div>
                		<input class="loginLoginValue" type="hidden" name="service" value="login" />
           			</div>
              		<p class="p-container">
                		<input type="button" name="Login" id="Login" value="Login" >
                 		<div class="regformbtn">
              				<input type="button" name="idFind" id="idFind"  class="idpwFind" value="아이디 찾기" ><a href="/user/idFind"></a>
               				<input type="button" name="pwFind" id="pwFind" class="idpwFind" value="비밀번호 찾기" ><a href="/user/pwFind"></a>
                		</div>
        		 	</p>
            	</form>
       		</div>
       	</div>
   	</div>
	<!--로그인 모달창 끝-->
    
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="fdBbsSeq" value="" />
	</form>
    
</body>
</html>