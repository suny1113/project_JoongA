<%@page import="vo.ShowMemVO"%>
<%@page import="vo.ReviewVO"%>
<%@page import="dao.ReviewDAO"%>
<%@page import="vo.NoticeVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dao.NoticeDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관람후기</title>
<style>
	*{
		font-family: "G마켓 산스 TTF";
	}
	
	#container{
		/* background : skyblue;  */
		width : 55%;
		margin : 0 auto;
	}
	#notice{
		width :220px;
		height : 150px;
		margin-top: 100px;
	}
	#title{
		width : 300px;
		font-size: 40px;
		color : black;
	}
	span{
		color: #970119;
	}
	table, th, td{
		border-collapse : collapse;
		padding : 5px;
	}
	#rTable{
		width : 1000px;
		border-top: 1px solid black;
		border-bottom : 1px solid #C8C8C8;
	}
	th{
		padding : 5px;
	}
	td{
		text-align : center;
		
	}
	#col1{ width : 5% }
	#col2{ width : 15% }
	#col3{ width : 40% }
	#col4{ width : 10% }
	#col5{ width : 10% }
	#col6{ width : 7% }
	#col7{ width : 13% }
	
	.pageImg{
		width : 20px;
		height : 20px;
	}
	
	#pageMove{
		text-align : center;
		padding : 20px;
	}
	
	a:link{
		text-decoration: none;
		color : black;
		font-size: 25px;
		padding : 5px;
	}
	a:visited{
		color : black;
	}
	a:hover{
		color : red;
	}
	#nowPage{
		width : 150px;
		height : 30px;
		background : #EFEFEF;
	}
	#totalPage{
		margin-left : 5px;
		color : #737373;
	}
	#detail{
		font-size: 15px;
	}
	#detail:hover{
		color : black;
		text-decoration: underline;
	}
	#btn{
		text-align: right;
	}
	.btn2{
		background : #EFEFEF;
		margin-right: 15px;
		border : 1px solid #EFEFEF;
		border-radius: 3px;
		width : 90px;
		height : 30px;
	}
	.btn2:hover{
		background: #CAA7C7;
	}
	h3{
		margin-bottom : 10px;
	}
	#reviewImg{ width : 100px; height : 150px }
	
	#write{
		text-align: right;
	}
	.star{
		width: 17px;
		height: 17px;
		background : silver;
	}
	input[type=radio]{
		display: none;
	}
	#review{
		width : 35px;
		height : 35px;
	}
	body{
		background-image: url("../images/bgh9.svg");
		background-size: 100%;
		background-repeat: no-repeat;
	}
	#pg{
		padding-left: 18px;
	}
	.bor{
		border-bottom: 1px solid #EFEFEF;
		text-align: center;
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script type="text/javascript">
	
	function allCheck(){
		var checkAll = document.getElementById("checkAll");
			var ck = document.getElementsByName("ck");
			for(var i=0; i<ck.length; i++){
				ck[i].checked = checkAll.checked;
			}
		}
		
	function del(){
		var del = document.getElementById("del");
			if($('input[name=ck]:checked').val() == null){
				alert("삭제할 관람평을 선택해주세요.");
			}else if(confirm("선택한 관람평을 삭제하시겠습니까?")==true){
				document.getElementById("frm").submit();
			}else{
				return false;
			}
		}
		
	function reviewWrite(){
		
		var write = document.getElementById("reviewWrite");
			location.href = "reviewWrite.jsp";
		}
	
</script>
</head>
<body>
	
	<%
		ReviewDAO dao = new ReviewDAO();
		int totalCount = dao.getTotal();
	
		int perPage = 3;
	
		int totalPage = (totalCount % perPage == 0) ? totalCount/perPage : totalCount/perPage+1;
	
		int currentPage;
		
		int startPage = 1;
		int endPage = 5;
		
		// 현재 페이지?
		String cp = request.getParameter("cp");
		if(cp == null){
			currentPage = 1;
		}else{
			currentPage = Integer.parseInt(cp);
		}
		
		
		
		// <<, >> 맨 앞, 맨 뒤로가기 기능
		if(currentPage <= 0){
			currentPage = 1;
		}
		
		if(currentPage <= 5){
			startPage = 1;
			endPage = 5;
		}
		
		
		// <, > 페이지 이동 기능
		int num1 = 5;
		int num2 = 10;
		int sp = 6;
		int ep = 10;
		for(int i = 1; i <= totalPage/4; i++){
			if(currentPage > num1 && currentPage <=num2){
				startPage = sp;
				endPage = ep;
			}
			num1 = num1+5;
			num2 = num2+5;
			sp = sp+5;
			ep = ep+5;
			if(endPage > totalPage){
				endPage = totalPage;
			}
		}
		
		
		
		 if(endPage > totalPage){
			endPage = totalPage;	
		 }
	
		  if(startPage > endPage){
			 currentPage = endPage;
			 startPage = startPage-5;
		 } 
		
		// 현재 페이지에 따라 검색할 시작번호, 끝번호
		// 1페이지일때 1~5, 2페이지일때 6~10
		int startNo = (currentPage -1) * perPage +1;
		int endNo = currentPage * perPage;
		
		ArrayList<ReviewVO> list = dao.selectAll(startNo, endNo);
		 

		%>
		<jsp:include page="header.jsp" />
		<div id="container">
		<div id="notice"><span id="title"><img src="../images/review.png" alt="" id="review" />관람후기</span></div>
		<h3>총 <span><%=totalCount%></span>건이 검색되었습니다.</h3>
			<form action="reviewDeleteOk.jsp" method="GET" id="frm">
				<table id="rTable">
					<tr>
				<%
					// admin 계정인지 아닌지 테스트
					ShowMemVO vo2 = (ShowMemVO)session.getAttribute("vo");
					if(vo2!=null){
						if(vo2.getId().equals("admin")){
				%>
					<th><input type="checkbox" name="" id="checkAll" onclick="allCheck()" /></th>
				<%		
						}
					}
				%>
						<th id="col1" class="bor">번호</th>
						<th id="col2" class="bor">사진</th>
						<th id="col3" class="bor">제목</th>
						<th id="col4" class="bor">작성자</th>
						<th id="col5" class="bor">작성일</th>
						<th id="col6" class="bor">조회수</th>
						<th id="col7" class="bor">별점</th>
					</tr>
					<%
						for(ReviewVO vo : list){
					%>	
					
					<tr>
					<%
						if(vo2!=null){
							if(vo2.getId().equals("admin")){
					%>
						<td  class="bor"><input type="checkbox" name="ck" value="<%=vo.getReview_no()%>" /></td>
					<%		
							}
						}
					%>
						<td  class="bor"><%=vo.getReview_no() %></td>
						<td  class="bor"><img src="../images/<%=vo.getMain_img()%>" alt="" id="reviewImg"/></td>
						<td  class="bor"><a href="reviewDetail.jsp?review_no=<%=vo.getReview_no()%>" id="detail"><%=vo.getReview_title() %></a></td>
						<td  class="bor"><%=vo.getReview_writer() %></td>
						<td  class="bor"><%=vo.getReview_date() %></td>
						<td  class="bor"><%=vo.getReview_hits() %></td>
						<td  class="bor">
					<%
						if(vo.getReview_rate()==1){
					%>
						<div id="rate">
								<label><input type="radio" name="rating" id="star1" value="1"/><img src="../images/star.png" alt="" class="star" id="s1" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star2" value="2"/><img src="../images/star.png" alt="" class="star" id="s2" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star3" value="3"/><img src="../images/star.png" alt="" class="star" id="s3" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star4" value="4"/><img src="../images/star.png" alt="" class="star" id="s4" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star5" value="5"/><img src="../images/star.png" alt="" class="star" id="s5" style="background: silver"/></label>
						</div>
					<%		
						}else if(vo.getReview_rate()==2){
					%>		
						<div id="rate">
								<label><input type="radio" name="rating" id="star1" value="1"/><img src="../images/star.png" alt="" class="star" id="s1" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star2" value="2"/><img src="../images/star.png" alt="" class="star" id="s2" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star3" value="3"/><img src="../images/star.png" alt="" class="star" id="s3" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star4" value="4"/><img src="../images/star.png" alt="" class="star" id="s4" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star5" value="5"/><img src="../images/star.png" alt="" class="star" id="s5" style="background: silver"/></label>
						</div>
					<% 		
						}else if(vo.getReview_rate()==3){
					%>		
						<div id="rate">
								<label><input type="radio" name="rating" id="star1" value="1"/><img src="../images/star.png" alt="" class="star" id="s1" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star2" value="2"/><img src="../images/star.png" alt="" class="star" id="s2" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star3" value="3"/><img src="../images/star.png" alt="" class="star" id="s3" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star4" value="4"/><img src="../images/star.png" alt="" class="star" id="s4" style="background: silver"/></label>
								<label><input type="radio" name="rating" id="star5" value="5"/><img src="../images/star.png" alt="" class="star" id="s5" style="background: silver"/></label>
						</div>	
					<%		
						}else if(vo.getReview_rate()==4){
					%>		
						<div id="rate">
								<label><input type="radio" name="rating" id="star1" value="1"/><img src="../images/star.png" alt="" class="star" id="s1" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star2" value="2"/><img src="../images/star.png" alt="" class="star" id="s2" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star3" value="3"/><img src="../images/star.png" alt="" class="star" id="s3" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star4" value="4"/><img src="../images/star.png" alt="" class="star" id="s4" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star5" value="5"/><img src="../images/star.png" alt="" class="star" id="s5" style="background: silver"/></label>
						</div>
					<%		
						}else if(vo.getReview_rate() == 5){
					%>		
						<div id="rate">
								<label><input type="radio" name="rating" id="star1" value="1"/><img src="../images/star.png" alt="" class="star" id="s1" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star2" value="2"/><img src="../images/star.png" alt="" class="star" id="s2" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star3" value="3"/><img src="../images/star.png" alt="" class="star" id="s3" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star4" value="4"/><img src="../images/star.png" alt="" class="star" id="s4" style="background:#DCD551"/></label>
								<label><input type="radio" name="rating" id="star5" value="5"/><img src="../images/star.png" alt="" class="star" id="s5" style="background:#DCD551"/></label>
						</div>
					<%		
						}
					%>
						<input type="hidden" name="reviewNo" value="<%=vo.getReview_no()%>" />
						</td>
					</tr>
					<%
						}
					
					%>
					<tr>
						<td colspan = "8" id="pageMove">
								<div id="nowPage"><h4 id="pg">페이지<%=currentPage%>/<span id="totalPage"><%=totalPage%></span></h4></div>
							<%
								if(vo2!=null){
									if(!vo2.getId().equals("admin")){	
							%>
								<div id="write"><input type="button" value="리뷰작성" class="btn2" onclick="reviewWrite()" style="padding: 0;"/></div>
							<%
									}
								}
							%>	
								<a href="review.jsp?cp=1"><img src="../images/left2.png" class="pageImg" alt="" /></a>
								<a href="review.jsp?cp=<%=startPage-5%>"><img src="../images/left1.png" class="pageImg" alt="" /></a>
							<%
							
								for(int i = startPage; i <= endPage; i++){
									
							%>
								
							
								<a href="review.jsp?cp=<%=i%>"><%=i %></a>
								<%
								}
								%>
								<a href="review.jsp?cp=<%=startPage+5%>"><img src="../images/right1.png" class="pageImg" alt="" /></a>
								<a href="review.jsp?cp=<%=totalPage%>"><img src="../images/right2.png" class="pageImg" alt="" /></a>
							<%
								if(vo2!=null){
									if(vo2.getId().equals("admin")){
							%>
								<div id="btn"><input type="button" value="관람평 삭제" class="btn2" onclick="del()" style="padding: 0"/></div>
							<%
									}
								}
							%>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<jsp:include page="footer.jsp" />
</body>
</html>