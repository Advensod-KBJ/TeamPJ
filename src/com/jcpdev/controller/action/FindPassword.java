package com.jcpdev.controller.action;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jcpdev.dao.MemberDao;
import com.jcpdev.dto.Member;

public class FindPassword implements Action {

	
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response) throws javax.servlet.ServletException ,java.io.IOException {

		HttpSession session = request.getSession();
		request.setCharacterEncoding("UTF-8");
		String member_id =request.getParameter("member_id");
		String member_tel =request.getParameter("member_tel");
		String member_email =request.getParameter("member_email");
		
		if(session.getAttribute("readIdx") ==null){
			StringBuilder readIdx=new StringBuilder("/");
			session.setAttribute("readIdx", readIdx);
		}
		Map<String,String> map = new HashMap<>();
		map.put("member_id",member_id);
		map.put("member_tel",member_tel);
		map.put("member_email",member_email);
		System.out.println(map);
		MemberDao dao = MemberDao.getInstance();
		Member user_check = dao.findPassword(map);
		
		Member find_password = user_check;
		if(find_password != null){
			session.setAttribute("user_password",find_password.getMember_password());
		}
		ActionForward foward = new ActionForward();
		foward.isRedirect = true;
		foward.url="community/find_password_C.jsp";
		return foward;
	};
}