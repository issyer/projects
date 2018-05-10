package softProject;


import java.io.IOException;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.websocket.*;
import javax.websocket.server.ServerEndpoint;

import net.sf.json.JSONArray;  

/**
 * @ServerEndpoint 注解是一个类层次的注解，它的功能主要是将目前的类定义成一个websocket服务器端,
 * 注解的值将被用于监听用户连接的终端访问URL地址,客户端可以通过这个URL来连接到WebSocket服务器端
 */
@ServerEndpoint("/websocket")
public class SocketServer {
    //静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;
    private int []piaoshu=new int[10];
    //concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。若要实现服务端与单一客户端通信的话，可以使用Map来存放，其中Key可以为用户标识
    private  static CopyOnWriteArraySet<SocketServer> webSocketSet = new CopyOnWriteArraySet<SocketServer>();

    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;
    /**
     * 连接建立成功调用的方法
     * @param session  可选的参数。session为与某个客户端的连接会话，需要通过它来给客户端发送数据
     */
    @OnOpen
    public void onOpen(Session session){
        this.session = session;
        webSocketSet.add(this);     //加入set中
        addOnlineCount();           //在线数加1
        //System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
        JSONArray jsonArray = JSONArray.fromObject(piaoshu);
        for(SocketServer item: webSocketSet){
            try {

                item.sendMessage(jsonArray.toString());
            } catch (IOException e) {
                e.printStackTrace();
                continue;
            }
        }      
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose(){
        webSocketSet.remove(this);  //从set中删除
        subOnlineCount();           //在线数减1
        //System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     * @param message 客户端发送过来的消息
     * @param session 可选的参数
     */
    @OnMessage
    public void onMessage(String message,Session session) {

        if(message.equals("huawei")){
        	piaoshu[1]=1;
        	for(int i=2;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("sanxing")){
        	piaoshu[2]=1;
        	piaoshu[1]=0;
        	for(int i=3;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("pingguo")){
        	piaoshu[3]=1;
        	for(int i=1;i<3;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=4;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("xiaomi")){
        	piaoshu[4]=1;
        	for(int i=1;i<4;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=5;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("meizu")){
        	piaoshu[5]=1;
        	for(int i=1;i<5;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=6;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("vivo")){
        	piaoshu[6]=1;
        	for(int i=1;i<6;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=7;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("oppo")){
        	piaoshu[7]=1;
        	for(int i=1;i<7;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=8;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("yijia")){
        	piaoshu[8]=1;
        	for(int i=1;i<8;i++){
        		piaoshu[i]=0;
        	}
        	for(int i=9;i<10;i++){
        		piaoshu[i]=0;
        	}
        }else if(message.equals("chuizi")){
        	piaoshu[9]=1;
        	for(int i=1;i<9;i++){
        		piaoshu[i]=0;
        	}
        }      
        JSONArray jsonArray = JSONArray.fromObject(piaoshu);  

        //群发消息
        for(SocketServer item: webSocketSet){
            try {

                item.sendMessage(jsonArray.toString());
            } catch (IOException e) {
                e.printStackTrace();
                continue;
            }
        }
    }

    /**
     * 发生错误时调用
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session,Throwable error){
        System.out.println("发生错误");
        error.printStackTrace();
    }

    /**
     * 这个方法与上面几个方法不一样。没有用注解，是根据自己需要添加的方法。
     * @param message
     * @throws IOException
     */
    public void sendMessage(String message) throws IOException{
        this.session.getBasicRemote().sendText(message);
        //this.session.getAsyncRemote().sendText(message);
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
    	SocketServer.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
    	SocketServer.onlineCount--;
    }
}