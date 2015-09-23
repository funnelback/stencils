import com.funnelback.common.config.*;
import com.funnelback.common.io.store.xml.*;
import com.funnelback.socialmedia.fetcher.*;
import com.funnelback.socialmedia.processing.*;
import com.funnelback.socialmedia.utils.*;
import com.funnelback.socialmedia.youtube.v3.*;
import java.net.URL;
import java.util.LinkedList;
import com.funnelback.socialmedia.RateLimiter;
import com.google.api.services.youtube.YouTube;

Config config = ConfigFactory.createNoOptionsConfigWithLogging(new File(args[0]), args[1]);

AbstractRecordProcessor processor = new CollectionStoreRecordProcessor(new XmlStoreFactory(config));

//Your api key,
String apiKey= 'AIzaSyCwC_-MbNtnUoxNuJE-WMZyR29CPZHN4V4';

/**
* You should add your queries here, see https://www.youtube.com/watch?v=Im69kzhpR3I
*/
List<YouTubeQuery> queries = new LinkedList<>();

/**
* You should add your profiles to crawl here.
* Chanel ID's can be found a the metatag 'chanelID' on the chanels main page.
*/
List<String> channelIDs = [
	"UCFnWd6d9OggLixnow-3McjA"//RMIT
	,"UCO3krgSinpAjqXE1DU47-cA"//Monash Uni
];

// RP - Workaround for versions 14.2 and lowwer see https://jira.cbr.au.funnelback.com/browse/FUN-7722
queries.add(new UploadsChannelQuery(channelIDs){
            //@Override
            public PlayListQuery getAPLayListQuery(List<String> playListId) {
                return new PlayListQuery(playListId){
                    //@Override
                    public void execute(AbstractRecordProcessor recordProcessor, RateLimiter rateLimiter,
                        YouTube youtube, String apiKey2) throws InvalidQueryException {

                        for(String playList : this.getPlayListIDs()){
                            List<String> playListList = new LinkedList<>();
                            playListList.add(playList);
                            new PlayListQuery(playListList).execute(recordProcessor, rateLimiter, youtube, apiKey2);
                        }
                    }
                };
            }
        });
//For versions 15+ remove the workaround and above and uncomment the below.
//queries.add(new UploadsChannelQuery(channelIDs));

new YouTubeFetcher(processor, config, apiKey).execute(queries);

//Uncomment this if you want to view the returned XML in the update log.
//new YouTubeFetcher(new StdoutRecordProcessor(), config, apiKey).execute(queries);
