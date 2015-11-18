package com.funnelback.stencils.filter.scraper;

// Obtain Funnelback specific settings
import com.funnelback.common.*;

// Stencil reliant libraries
import com.funnelback.stencils.util.Downloader;

// Used for all the regular expressions
import java.util.regex.*;

// JSOUP for doc manipulation and selections
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Entities.EscapeMode;

// Logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

/*
	Meta Data Scraper

	http://confluence.cbr.au.funnelback.com:8080/display/PNS/Groovy+Filter+-+Meta+Data+Scraper
*/
@groovy.transform.InheritConstructors
public class MetadataScraperFilter extends com.funnelback.common.filter.ScriptFilterProvider
{
	private static final Logger logger = Logger.getLogger(MetadataScraperFilter.class);

	public final static String CONFIG_FILENAME = "stencils.filter.scraper.metadata_scraper.json";
	public final static String SEARCH_HOME =  Environment.getValidSearchHome();

	public String collectionName;

	public final String METADATA_DELIMITER_CONFIG_NAME = "stencils.filter.scraper.metadata_scraper.delimiter";
	public final String METADATA_DELIMITER_DEFAULT = "|";
	public String metaDataDelimiter;

	// Class which represents all the meta data scraper config
	MetadataScraperService scraperService;

	// Constructor
	public MetadataScraperFilter(String collectionName, boolean inlineFiltering)
	{
		super(collectionName, inlineFiltering);

		// Set the collection name
		this.collectionName = collectionName;

		// Set the filename
		String filename = SEARCH_HOME + File.separator + "conf" + File.separator + collectionName + File.separator + CONFIG_FILENAME;

		metaDataDelimiter = config.value(METADATA_DELIMITER_CONFIG_NAME, METADATA_DELIMITER_DEFAULT);

		// Create the scraper service
		scraperService = new MetadataScraperService(filename, metaDataDelimiter);
	}

	// We filter all documents
	public Boolean isDocumentFilterable(String documentType)
	{
		return true;
	}

	/*
		called to filter document
		@input - text which is to be filtered such as html
		@documentType - html, doc, pdf etc
	*/
	public String filter(String input, String documentType)
	{
		return filter(input, documentType, getURL(input));
	}

	public String filter(String input, String documentType, String address)
	{
		logger.info("Processing content from URL: '${address}' - With document type of '${documentType}'");

		//do nothing if scraper config is not found and
		if(scraperService == null)
		{
			return input;
		}

		// For performance, ensure that we only process the current document with JSOUP if it is
		// being referenced in the scraper configs
		if(scraperService.containsURL(address) == false)
		{
			return input;
		}
		else
		{
			Document doc;

			try
			{
				doc = getDocument(input, address);

				if(documentType ==~ /\.html|html|\.pdf|pdf|/)
				{
					// Run the scraper service over the document
					scraperService.process(doc, address);
				}
			}
			catch(Exception e)
			{
				// Log the error,
				logger.error("Error with filtering", e);
			}

			// Return the filtered html
			if(doc != null)
			{
				return doc.html();
			}
			else
			{
				return input;
			}
		}
	}

	//Converts a string representation of a html page to a JSOUP Document object
	//Ensures that the character encoding of the document is maintained
	public Document getDocument(String input, String address)
	{
		Document doc;

		//Create the JSOUP document object with the calculated character set
		doc = Jsoup.parse(input, address);
		doc.outputSettings().escapeMode(EscapeMode.xhtml);

		return doc;
	}

	/*
		Created by Alwyn I think to obtain the URL if it is not available via the standard
		Filter() function.
	*/
	public String getURL(String input)
	{
		def matched = "";
		// Check for WARC style URL output
		def matcher = (input =~ /(?im)^\+\s+(http.+)$/);
		if (matcher.find())
		{
			matched = matcher[0][1];
			matched = matched.trim();
		}
		else
		{
			// If not matched, check for MirrorStore style URL output
			matcher = (input =~ /<BASE HREF="(http.+)">/);
			if (matcher.find())
			{
				matched = matcher[0][1];
				matched = matched.trim();
			}
		}

		return matched;
	}

	// A main method to allow very basic testing
	public static void main(String[] args)
	{
		// Download the content
		String address = "http://www.swinburne.edu.au/business-law/staff-profiles/view.php?who=mgilding";
		String input = Downloader.download(address);
		String collectionName = "stencils-people-generator-web"

		// Create an instance of the filter
		def f = new MetadataScraperFilter(collectionName, true);

		String output = f.filter(input, ".html", address);

		File outputFile = new File('MetaDataScraperFilter.output.html');
		println("Created '${outputFile.getAbsolutePath()}' with contents of the filtered file");

		outputFile.withWriter() // use withWriter("UTF-8") to force utf-8
		{
			writer ->

			writer.print(output);
		}
	}
}

