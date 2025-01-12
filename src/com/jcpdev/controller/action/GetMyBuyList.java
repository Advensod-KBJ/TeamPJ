package com.jcpdev.controller.action;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.jcpdev.dao.MemberDao;
import com.jcpdev.dao.ProductDao;
import com.jcpdev.dto.Member;
import com.jcpdev.dto.Product;

public class GetMyBuyList implements Action {

	@Override
	public ActionForward execute(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// 판매내역 가져오기
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html");

		ProductDao dao = ProductDao.getInstance();
		HttpSession session = request.getSession();
		String id = (String)session.getAttribute("user_id");
		MemberDao mdao = MemberDao.getInstance();
		
		Member user =  mdao.getInfo(id);
		List<Product> list = dao.getMyBuyList(user);

		request.setAttribute("list", list);

		ActionForward foward = new ActionForward();
		foward.isRedirect = false;
		foward.url = "/view/purchaselist.jsp";
		return foward;
	}

}