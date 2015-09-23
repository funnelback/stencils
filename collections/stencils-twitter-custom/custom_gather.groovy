import com.funnelback.common.config.*;
import com.funnelback.common.io.store.xml.*;
import com.funnelback.socialmedia.fetcher.*;
import com.funnelback.socialmedia.processing.*;
import com.funnelback.socialmedia.twitter.*;
import twitter4j.TwitterFactory;
import twitter4j.conf.ConfigurationBuilder;
import com.funnelback.socialmedia.utils.*;


Config config = ConfigFactory.createNoOptionsConfigWithLogging(new File(args[0]), args[1]);

ConfigurationBuilder cb = new ConfigurationBuilder();
cb.setDebugEnabled(false)
//Go to https://dev.twitter.com/apps/new to get this information    
    .setOAuthConsumerKey("D400Wpiag5QObV4dOWnpXxI2K")
    .setOAuthConsumerSecret("hgVT6SGiOU4rjg9ZrHIT3LyMjKGfL0Uejmpuikvy4bT5Kk3o84")
    .setOAuthAccessToken("346388818-5NTRXCuVtkbubP10cvpeoJrn4hfW0s9P6yiYx4bN")
    .setOAuthAccessTokenSecret("Gt5OZt7DqG3T1WdMaaE6MaXNs7voD4yHFmAB1ye0o4dM3");

TwitterFactory tf = new TwitterFactory(cb.build());

/**
* You should add your profiles to crawl here.
* The parameters are
*/
List<String> profiles = [
    "RMIT"
    ,"MonashUni"
];

List<TwitterQuery> queries = [];

profiles.each {
    queries.push( new TwitterQuery(it) );
}

//Run our queries and place the results into Funnelback.
AbstractRecordProcessor processor = new CollectionStoreRecordProcessor(new XmlStoreFactory(config));
new TwitterFetcher(processor, config, tf).execute(queries);

//Uncomment this if you want to view the returned XML in the update log.
//new TwitterFetcher(new StdoutRecordProcessor(), config, tf).execute(queries);
