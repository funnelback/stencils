import com.funnelback.common.config.*;
import com.funnelback.common.io.store.xml.*;
import com.funnelback.socialmedia.fetcher.*;
import com.funnelback.socialmedia.processing.*;
import com.funnelback.socialmedia.flickr.*;
import com.restfb.*;
import com.flickr4java.flickr.*;
import com.funnelback.socialmedia.utils.*;

Config config = ConfigFactory.createNoOptionsConfigWithLogging(new File(args[0]), args[1]);

/**
* Flickr api key and secret
*
* To get these go to http://www.flickr.com/services/apps/create/apply/ or
* go to http://www.flickr.com/services/api/registered_keys.gne to see a list
* of your API keys
*/
String apiKey = "858b150f88081ee098481155eb49aad8";
String apiSecret = "f505f4e557c01cd0";

/**
* User authentication tokens
*
* To get this Run:
* java -cp '$SEARCH_HOME/lib/java/all/*' com.funnelback.socialmedia.flickr.FlickrAuthentication 858b150f88081ee098481155eb49aad8 f505f4e557c01cd0
* java -cp %SEARCH_HOME%\lib\java\all\^* com.funnelback.socialmedia.flickr.FlickrAuthentication apiKey apiSecret
*/
String userAuthToken = "72157651652143610-932382089af6b609";
String userAuthTokenSecret = "1cc073d0ff98bb91";

/**
* You should add your profiles to crawl here.
*/
/**
* Your user's id (nsid), this user's photo stream can be crawled.
* http://idgettr.com/
*/
List<String> userIds = [
  "8281358@N05"//https://www.flickr.com/photos/rmit/

];
List<String> groupIds = [
  "76212889@N00"//https://www.flickr.com/groups/milkcrates/
];


//Create the Flickr connector[s]
//A Flickr connector that can access private data.
Flickr flickr = FlickrFactory.createFlickr(apiKey, apiSecret, userAuthToken, userAuthTokenSecret);
//The following connector can only crawl public pages.
Flickr flickrPublic = FlickrFactory.createFlickr(apiKey, apiSecret);

/**
* You should add your queries here
*/
	//The user should have joined groupId if you want all photos from the group.
 //new FlickrQueryGroupPhotos(flickr, groupId)
  //As we are using flickrPublic we will only be able to get what is public on the group.
  //Although the photos we miss might actually be public themselves.
  //new FlickrQueryGroupPhotos(flickrPublic, anotherGroupId)
List<FlickrQuery> queries = []
userIds.each {
	queries.push( new FlickrQueryUserStream(flickr, it) );
}

groupIds.each {
   queries.push( new FlickrQueryGroupPhotos(flickr, it) );
}

//Run our queries and place the results into Funnelback.
AbstractRecordProcessor processor = new CollectionStoreRecordProcessor(new XmlStoreFactory(config));
new FlickrFetcher(processor, config).execute(queries);

//Uncomment this if you want to view the returned XML in the update log.
//new FlickrFetcher(new StdoutRecordProcessor(),config).execute(queries);
