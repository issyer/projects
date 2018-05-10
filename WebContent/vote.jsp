<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>投票页</title>
</head>
<body>
<h1>您好，欢迎进入投票页面</h1>
<h3>请为您最喜爱的手机品牌投上一票吧</h3>
<form >
<input type="radio"  name="phone" value="huawei"/>华为
<input type="radio" name="phone" value="sanxing"/>三星
<input type="radio" name="phone" value="pingguo"/>苹果<br/>
<input type="radio"  name="phone" value="xiaomi"/>小米
<input type="radio" name="phone" value="meizu"/>魅族
<input type="radio"  name="phone" value="vivo"/>Vivo<br/>
<input type="radio"  name="phone" value="oppo"/>oppo
<input type="radio" name="phone" value="yijia"/>一加
<input type="radio"  name="phone" value="chuizi"/>锤子<br/><br/>
</form>
<input type="button" value="投票" onclick="send()"/>
    <button onclick="closeWebSocket()">关闭WebSocket连接</button>
<a href="login.html"><input type="button" name="back" value="退出登录"/></a>
</body>
<script type="text/javascript">
    var websocket = null;
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        websocket = new WebSocket("ws://localhost:8080/SoftProject/websocket");
    }
    else {
        alert('当前浏览器 Not support websocket')
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }
    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }
    var flag=0;
    //发送消息
    function send() {
    	
    	if(flag==1){
        	alert("您已经投过票啦！");
        }
        var message = document.getElementsByName("phone");
        for(var i=0; i<message.length; i++){
            if(message[i].checked&&flag==0){
            	websocket.send(message[i].value);    
            	flag=1;
            	alert("投票成功！");
            }
        }
        if(flag==0){
        	alert("请先为您喜爱的手机品牌投一票！");
        }
        
    }
</script>
</html>