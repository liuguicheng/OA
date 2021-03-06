<%@page import="java.text.SimpleDateFormat"%>
<%@page import="tools.GetTime"%>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="pojo.TDatadic"%>
<%@page import="datadic.dao.TDatadicDAO"%>
<%@page
	import="org.springframework.context.support.ClassPathXmlApplicationContext"%>
<%@page import="org.springframework.context.ApplicationContext"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
	+ request.getServerName() + ":" + request.getServerPort()
	+ path + "/";
	
	/* session.getAttribute("suser"); */
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<base href="<%=basePath%>">

<title>数据类别</title>

<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

<link rel="stylesheet" type="text/css" href="<%=path%>/css/reg.css">
<script type="text/javascript">

function hide(id) 
{
		var tbody = document.getElementById("tbody" + id);
		var img = document.getElementById("img" + id);
		if (tbody.style.display == "none") 
		{
			tbody.style.display = "block";
			img.src = "<%=path%>/jsp/datadic/image/collapse.gif";
			img.title = "点击隐藏大类别";
		} else {
			tbody.style.display = "none";
			img.src = "<%=path%>/jsp/datadic/image/expand.gif";
			img.title = "点击显示大类别";
		}
}

function remove(id) {
		if(confirm('确认删除该类别？')){
			var formname="form"+id;
			
			var form=document.getElementById(formname);
			//alert(form);
			//request.setParameter("submitdel")="delete";
			form.action="<%=path%>/jsp/datadic/showData.jsp?submitdel=remove&id="+id;
			form.submit();
		}
	}
</script>

</head>

<body>
	<table border="0" align="center" width="60%" style="margin-top: 50px">

		<%
			SimpleDateFormat sdf = new SimpleDateFormat();// 格式化时间 
			sdf.applyPattern("yyyy-MM-dd HH:mm:ss");
			ApplicationContext context = new ClassPathXmlApplicationContext(
					"applicationContext.xml");
			TDatadicDAO dao = (TDatadicDAO) context.getBean("TDatadicDAO");

			if (request.getParameter("submitupd") != null) {
				String id = request.getParameter("id");
				String sname = request.getParameter("typeName");
				/* String suser = session.getAttribute("user"); */
				String suser = "update";
				Date dateupd = GetTime.time();
				//System.out.println(dateupd);
				TDatadic instance = dao.findById(Integer.valueOf(id));

				if (sname != null && !sname.equals("") && sname.length() > 1
						&& sname.length() < 20) {
					List<TDatadic> list = dao.findByDpid(String
							.valueOf(instance.getDpid()));

					boolean eq = true;
					if (list != null) {
						for (TDatadic datadic : list) {
							if (sname.equals(datadic.getDname())
									&& datadic.getDisdel() != 1) {
								eq = false;

							}
						}
					}
					if (eq) {

						instance.setDname(sname);
						instance.setDupdatedate(dateupd);
						instance.setDupdateuser(suser);
						dao.attachDirty(instance);

					} else {
		%>
		<tr>
			<td colspan="6"><font color="red">该类别中已有此项</font></td>
		</tr>
		<%
			}
				} else {
		%>
		<tr>
			<td colspan="6"><font color="red">名称格式不正确（应输入长度为2-19的名称）</font>
			</td>
		</tr>
		<%
			}

			} else if (request.getParameter("submitdel") != null) {
				String id = request.getParameter("id");
				TDatadic instance = dao.findById(Integer.valueOf(id));
				/* String suser = session.getAttribute("user"); */
				String suser = "delete";
				Date datedel = GetTime.time();
				if (instance.getDpid() == 0) {

					List<TDatadic> deldatadics = dao.findAll();

					for (TDatadic datadic : deldatadics) {

						if (datadic.getDpid().equals(instance.getDid())) {
							datadic.setDupdatedate(datedel);
							datadic.setDupdateuser(suser);
							datadic.setDisdel(1);
							dao.attachDirty(datadic);
						}
					}
				}
				instance.setDupdatedate(datedel);
				instance.setDupdateuser(suser);
				instance.setDisdel(1);
				dao.attachDirty(instance);
			} else if (request.getParameter("submitadd") != null) {
		%>
		<jsp:forward page="addData.jsp"></jsp:forward>
		<%
			}
		%>

		<tr>
			<td colspan="6" style="text-align: center;">
				<form action="<%=path%>/jsp/datadic/showData.jsp" name="formadd%>"
					id="formadd" method="post">
					<!-- <a href="AddTypeServlet">添加</a> -->
					<input type="submit" name="submitadd" value="添加">
				</form>
			</td>
		</tr>
		<tr bgcolor="#2f99e0">
			<th></th>
			<th>名称</th>
			<th>创建时间</th>
			<th>修改者</th>
			<th>修改时间</th>
			<th>操作</th>


		</tr>

		<%
			//java代码段 
			List<TDatadic> tDatadics = dao.findAll();
			for (TDatadic datadic : tDatadics) {
				if (datadic.getDpid() == 0 && datadic.getDisdel() == 0) {
		%>
		<form
			action="<%=path%>/jsp/datadic/showData.jsp?id=<%=datadic.getDid()%>"
			id="form<%=datadic.getDid()%>" method="post">
			<tr bgcolor="#cde9fc">
				<td width="2%"><img alt="点击伸缩"
					src="<%=path%>/jsp/datadic/image/collapse.gif"
					id="img<%=datadic.getDid()%>"
					onclick="hide(<%=datadic.getDid()%>);" /></td>

				<td><input type="text" name="typeName"
					value="<%=datadic.getDname()%>" />
				</td>
				<td><%=sdf.format(datadic.getDdate())%></td>
				<td><%=datadic.getDupdateuser()%></td>
				<td><%=sdf.format(datadic.getDupdatedate())%></td>

				<td><input type="submit" name="submitupd" value="修改"> <input
					type="button" name="submitdel" value="删除"
					onclick="remove(<%=datadic.getDid()%>)" /></td>


			</tr>
		</form>


		<%
			}
		%>

		<tbody id="tbody<%=datadic.getDid()%>">
			<%
				for (TDatadic datadic2 : tDatadics) {
						if (datadic2.getDpid().equals(datadic.getDid())
								&& datadic2.getDisdel() == 0) {
			%>
			<form
				action="<%=path%>/jsp/datadic/showData.jsp?id=<%=datadic2.getDid()%>"
				id="form<%=datadic2.getDid()%>" method="post">
				<tr>
					<td></td>
					<td><input type="text" name="typeName"
						id="typeName<%=datadic2.getDid()%>"
						value="<%=datadic2.getDname()%>" /></td>
					<td><%=sdf.format(datadic2.getDdate())%></td>
					<td><%=datadic2.getDupdateuser()%></td>
					<td><%=sdf.format(datadic2.getDupdatedate())%></td>

					<td><input type="submit" name="submitupd" value="修改">

						<input type="button" name="submitdel" value="删除"
						onclick="remove(<%=datadic2.getDid()%>)" /></td>
				</tr>
			</form>
			<%
				}
			%>
			<%
				}
			%>
		</tbody>
		<%
			}
		%>



	</table>

</body>
</html>
