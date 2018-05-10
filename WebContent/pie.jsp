<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>饼图</title>
<style type="text/css">
@import url(style.css);
</style>
<script type="text/javascript" src="echarts.js"></script>
<script type="text/javascript" src="jQuery.js"></script>
</head>
<body>
<ul>
<li><a href="main.jsp">主页</a></li>
<li><a href="column.jsp">柱形图</a></li>
<li><a href="pie.jsp">饼图</a></li>
<li><a href="line.jsp">折线图</a></li>
</ul>
    <div id="main" ></div>
    <script type="text/javascript">
    var websocket = null;
    var result;
    var res=new Array();
    for(var j=0;j<10;j++){
    	res[j]=0;
    }
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        websocket = new WebSocket("ws://localhost:8080/SoftProject/websocket");
    }
    else {
        alert('当前浏览器 Not support websocket')
    }

    //接收到消息的回调方法
    websocket.onmessage = function (event) {
        result=JSON.parse(event.data);
        res = JSON.parse(localStorage.getItem("res"));
        for(var i=0;i<10;i++){
        	res[i]+=result[i];
        }
        localStorage.setItem("res",JSON.stringify(res));

        // 基于准备好的dom，初始化echarts实例
        var myChart = echarts.init(document.getElementById('main'));

        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '各大品牌手机用户喜好量'
            },
            series : [
                {
                    name: '手机品牌',
                    type: 'pie',
                    radius: '55%',
                    data:[
                        {value:res[1], name:'华为'},
                        {value:res[2], name:'三星'},
                        {value:res[3], name:'苹果'},
                        {value:res[4], name:'小米'},
                        {value:res[5], name:'魅族'},
                        {value:res[6], name:'vivo'},
                        {value:res[7], name:'oppo'},
                        {value:res[8], name:'一加'},
                        {value:res[9], name:'锤子'}
                    ],
                    label : {
                    	normal : {
                    	formatter: '{b}:{c}: ({d}%)',
                    	    textStyle : {
                    	        fontWeight : 'normal',
                    	        fontSize : 15
                    	    }
                    	}
                    }

                }
            ]

        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    </script>
    <a href="login.html"><input type="button" name="back" value="退出登录"/></a>
</body>
</html>