import com.funnelback.common.config.*;
import com.funnelback.common.io.store.xml.*;
import com.funnelback.socialmedia.fetcher.*;
import com.funnelback.socialmedia.processing.*;
import com.funnelback.socialmedia.facebook.*;
import com.restfb.*;
import com.funnelback.socialmedia.utils.*;

Config config = ConfigFactory.createNoOptionsConfigWithLogging(new File(args[0]), args[1]);

/**
* Your app id and app secret.
*
* You are going to need this to access pages which require you to log in to view them.
* To get this you will first need a Facebook account. You will then need to go to
* https://developers.facebook.com/apps and create an app, this will give you your
* app Id and app secret.
*/
String appId = "1444644072494648";
String appSecret = "569a0c7d7a4759e67be94ecb86b833ec";

/**
* The facebook id of your page.
*
* To find this go to you facebook page for example:
* www.facebook.com/YourFacebookPage
* Now change www to graph
* graph.facebook.com/YourFacebookPage
* Look for the "id" entry, its value is your page id.
*/

//Set up the Facebook connectors
facebookClientDefault = new DefaultFacebookClient();
String appAccessToken = facebookClientDefault.obtainAppAccessToken(appId,appSecret).getAccessToken();
facebookClientApp = new DefaultFacebookClient(appAccessToken);

/**
* You should add your profiles to crawl here.
*/
List<String> profiles = [
    "AusINSArchitects"
    ,"australianmarketinginstitute"
    ,"AustralianInstituteOfCoaching"
    ,"AustInstituteCreativeDesign"
    ,"AIPPOfficial"
    ,"CertifiedHero"
    ,"aimcomau"
    ,"melbuni"
    ,"latrobe"
    ,"Australian.Catholic.University"
    ,"swinburneuniversityoftechnology"
    ,"RMITuniversity"
];

List<FacebookQuery> queries = [];

//Comment out any of the queries below to exclude crawling page, posts or event content type for a profile.
profiles.each {
    queries.push( new FacebookQueryPage(facebookClientApp, it) );
    queries.push( new FacebookQueryPost(facebookClientApp, it + "/posts" ) )
    queries.push( new FacebookQueryEvent(facebookClientApp, it + "/events") );
}

//Add custom queries here e.g.
//queries.push( new FacebookQueryPage(facebookClientApp, "XX") );

//Run our queries and place the results into Funnelback.
AbstractRecordProcessor processor = new CollectionStoreRecordProcessor(new XmlStoreFactory(config));
new FacebookFetcher(processor, config).execute(queries);

//Uncomment this if you want to view the returned XML in the update log.
//new FacebookFetcher(new StdoutRecordProcessor(), config).execute(queries);
