<%@page import="com.jcpdev.dto.Mail"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%
String room = request.getParameter("room");
String postid = request.getParameter("order_id");
String product_no = request.getParameter("p_no");
%>
	<input type="hidden" name="postid" value="<%=postid%>"  id="postid_<%=room%>">
	 <input type="hidden" name="product_no" value="<%=product_no%>"  id="product_no_<%=room%>">
	<div class="chat_footer_area">
		<input class="chat_input" type="text" contenteditable="true" id="content_<%=room%>"	placeholder="�޼����� �Է����ּ���.">
	</div>
	<button type="button" onclick="insert_mail('<%=room%>')">����</button>
	