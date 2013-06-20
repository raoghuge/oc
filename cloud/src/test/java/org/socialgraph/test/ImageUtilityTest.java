package org.socialgraph.test;

import java.io.File;
import java.io.IOException;

import org.apache.http.HttpVersion;
import org.apache.http.ParseException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.mime.HttpMultipartMode;
import org.apache.http.entity.mime.MultipartEntity;
import org.apache.http.entity.mime.content.FileBody;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.CoreProtocolPNames;
import org.apache.http.util.EntityUtils;

public class ImageUtilityTest {
	public static String uploadToHostImage(String imageFile) throws ParseException, ClientProtocolException, IOException {
		HttpClient client = new DefaultHttpClient();
		client.getParams().setParameter(CoreProtocolPNames.PROTOCOL_VERSION, HttpVersion.HTTP_1_1);
		 
//		HttpPost    post   = new HttpPost( "http://192.168.1.8:8080/HostImages/ImageUploaderServlet" );
		HttpPost    post   = new HttpPost( "http://localhost:8080/HostImages/ImageUploaderServlet" );
		MultipartEntity entity = new MultipartEntity( HttpMultipartMode.BROWSER_COMPATIBLE );
		
		// For File parameters
		entity.addPart( "file", new FileBody(new File(imageFile) ));
	
		post.setEntity( entity );
	
		// Here we go!
		String response = EntityUtils.toString( client.execute( post ).getEntity(), "UTF-8" );
		 
		client.getConnectionManager().shutdown();
		return response;
	}
	
	public static void main(String [] arg) throws ParseException, ClientProtocolException, IOException{
		uploadToHostImage("C:/Users/Public/Pictures/Sample Pictures/Tulips.jpg");
	}
}
