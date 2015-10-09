package com.funnelback.stencils.util;

import org.apache.commons.net.util.TrustManagerUtils;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;

// Logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

// Utility class used to dowload content
public class Downloader
{
  // Downloads the content from the specified URL
  public static String download(String url, String username ="", String password="")
  {
    String strResults = "";

    try
    {
      SSLContext sc = SSLContext.getInstance("SSL");

      TrustManager [] managers = TrustManagerUtils.getAcceptAllTrustManager();
      sc.init(null, managers, new java.security.SecureRandom());
      HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

      // Set up the connection to pass the url and the username and password details
      URL requestURL = new URL(url);

      URLConnection conn = (URLConnection)requestURL.openConnection();
      conn.setRequestProperty("Accept-Charset", "UTF-8");
      conn.setRequestMethod("GET");
      conn.setConnectTimeout(15000);
      conn.setReadTimeout(15000);
      conn.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.0; ru; rv:1.9.0.11) Gecko/2009060215 Firefox/3.0.11 (.NET CLR 3.5.30729)");

      // set the username and password
      if(username != "" && password != "")
      {
        String encoding = new sun.misc.BASE64Encoder().encode("${username}:${password}".getBytes());
        conn.setRequestProperty("Authorization", "Basic " + encoding);        
      }

      conn.connect();

      //get all the content from the connection
      strResults = conn.getInputStream().getText();
    }
    catch (Exception e)
    {
      println(e);
    }

    return strResults;
  }

  // A main method to allow very basic testing
  public static void main(String[] args)
  {
    String address = "http://funnelback.com";

    // Download the content
    String output = Downloader.download(address);

    File outputFile = new File('Downloader.output.html');
    println("Created '${outputFile.getAbsolutePath()}' with contents of the filtered file");
    
    outputFile.withWriter() // use withWriter("UTF-8") to force utf-8
    {
      writer ->
      
      writer.print(output);  
    }
  }  
}