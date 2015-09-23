
import com.funnelback.common.Environment; // To get SEARCH_HOME env var
import org.apache.commons.lang.StringEscapeUtils;
import java.util.regex.*;

import java.net.URLEncoder;
import org.apache.commons.codec.binary.Base64;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;

def logger = org.apache.log4j.Logger.getLogger("com.funnelback.MyHookScript");

/*
  All functions - Begin
*/

addZeroBaseValueFacet();

/*
  All functions - End
*/

/*
  Function definitions
*/

public void addZeroBaseValueFacet()
{
	def logger = org.apache.log4j.Logger.getLogger("com.funnelback.MyHookScript");

	// Only add the zero facet values to the extra searchers
	// Unable to target FACETED_NAVIGATION as the extraSearches map is not available
	// at this point in this script
	if(transaction?.response != null)
	{
		def response = transaction?.response;
		 
		// Represents the facet which maps to the person's initial
		String rmcField = 'a';
		 
		('A'..'Z').each() 
		{ 
			letter ->

			String rmc = rmcField + ':' + letter;
			if(response?.resultPacket?.rmcs[rmc] == null) 
			{
			 	response.resultPacket.rmcs[rmc] = 0;
			}
		}		
	}
}

