<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
 <link rel="stylesheet" href="${applicationScope.contextPath}/resources/css/style.css" type="text/css" media="screen" />  
<script type="text/javascript"
	src="${applicationScope.contextPath}/resources/js/jquery-1.9.1.js"
	language="javascript"></script>
<script>

function getMessageFormatted(message) {
	var formattedMessage = "";
	if(message!=null) {
		var words = message.split(" ");
		
		var fineWord = "";
		for ( var i = 0; i < words.length; i++) {
			fineWord = words[i];
			appendWord = "";
			var patt=/http:/g;
			if(patt.test(fineWord) == true)
			{
				var urlRegex = /(https?:\/\/[^\s]+)/g;
				
				appendWord = fineWord.replace(urlRegex, "<a href='"+fineWord +"'>"+fineWord+"</a>");
			} else if(fineWord.indexOf('~')==0) {
				falseWord = fineWord.split("~");
				appendWord = "@" + falseWord[1]
			} else if(fineWord.indexOf('@')==0) {
				var username = fineWord.split("@");
				
				appendWord = "<a onclick='profile_pop(\""
					+ username[1]
					+ "\");'>" + fineWord + "</a>";
			} else if(fineWord.indexOf('#')==0 && fineWord.length!=1) {
				appendWord = "<a onclick='showTrendMessages(\""+ fineWord +"\");'>" + fineWord + "</a>";
			} else {
				appendWord = fineWord;
			}
			formattedMessage = formattedMessage + " " + appendWord;
			
		}
	}
	return formattedMessage;
}

function expand(msgVal)
{	
	 $.ajax({
     	type : "GET",
			url : "${applicationScope.URLShortner}/url/expand",
			data : {url : msgVal},
			success : function(data) 
			{
				window.location = data;
 			},
			error : function(e) {
				console.log(e);
				return false; 
			}
		}); 
	
}
</script>
</head>
<body>

</body>
</html>