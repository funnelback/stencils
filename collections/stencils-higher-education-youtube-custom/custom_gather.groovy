import com.funnelback.common.config.*;
import com.funnelback.common.io.store.xml.*;
import com.funnelback.socialmedia.fetcher.*;
import com.funnelback.socialmedia.processing.*;
import com.funnelback.socialmedia.youtube.*;
import com.funnelback.socialmedia.utils.*;
import java.net.URL;

Config config = ConfigFactory.createNoOptionsConfigWithLogging(new File(args[0]), args[1]);

AbstractRecordProcessor processor = new CollectionStoreRecordProcessor(new XmlStoreFactory(config));

/**
* You should add your queries here
*/
List<YouTubeQuery> queries = 
    [
        //A query for the videos of user 'OpenSourceCMS'.
        new YouTubeUserQuery("UniversityOfTasmania"),
        //A query using a gdata youtube API URL, to create one of these URLs see:
        //https://developers.google.com/youtube/2.0/developers_guide_protocol_video_feeds
        //new YouTubeFeedQuery(new URL("http://gdata.youtube.com/feeds/api/videos?q=squiz"))
    ];

new YouTubeFetcher(processor, config).execute(queries);

//Uncomment this if you want to view the returned XML in the update log.
//new YouTubeFetcher(new StdoutRecordProcessor(), config).execute(queries);
