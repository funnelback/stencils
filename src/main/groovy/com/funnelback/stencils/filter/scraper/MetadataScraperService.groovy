package com.funnelback.stencils.filter.scraper;

// Used for all the regular expressions
import java.util.regex.*;

import com.funnelback.stencils.filter.scraper.MetadataScraperConfigEntryExtractionType;

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

// Represents a class which invokes a metadata scraper config onto
// a document
public class MetadataScraperService
{
	MetadataScraperConfig config;

	// Set up the logger
	private static final Logger logger = Logger.getLogger(MetadataScraperService.class);

	public MetadataScraperService(String filename, String metadataDelimiter)
	{
		config = new MetadataScraperConfig(filename, metadataDelimiter);
	}

	// Returns true if the url matches any in the config
	public boolean containsURL(String address)
	{
		return config.containsURL(address);
	}

	// Scrap the data in the document based on the meta data config rules
	public void process(Document doc, String address)
	{
		config.getConfigEntries().each()
		{
			if(it.matchURL(address))
			{
				processEntry(doc, it);
			}
		}
	}

	// Extract the contents from the @doc specified using the configuration @entry
	// and add back as meta data
	private void processEntry(Document doc, MetadataScraperConfigEntry entry)
	{
		Elements matches = doc.select(entry.selector);

		// Cater for negate scenario
		// i.e. Data is only being processed no results are found
		if(entry.getNegate() == true && matches.first() == null )
		{

			String contentData = extractData("", entry.getProcessMode(), entry.getValue());
			addMetaData(doc, entry.getMetadataName(), contentData);
		}
		// Process all matches
		else if(entry.getNegate() == false && matches.first() != null)
		{
			for(Element element: matches)
			{
				//Obtain the data which is to be stored in the contents
				String contentData = processElement(element, entry.getExtractionType(), entry.getAttributeName());
				contentData = extractData(contentData, entry.getProcessMode(), entry.getValue());

				//Add the contents to the document if something is found
				if(contentData != "")
				{
					addMetaData(doc, entry.getMetadataName(), contentData);
				}
			}
		}
	}

	// Extracts the contents of the element based on the @extraction type.
	// e.g.
	// text between tags - <div>text to be extracted</div>
	// text in an attribute - <a href="text to be extracted"> </a>
	private String processElement(Element element, MetadataScraperConfigEntryExtractionType extractionType, String attributeName = "")
	{
		String result = "";

		if(element != null)
		{
			switch(extractionType)
			{
				//Return only the text and ignore all html elements and attributes
				case MetadataScraperConfigEntryExtractionType.TEXT:
					result = element.text();
					break;
				case MetadataScraperConfigEntryExtractionType.ATTR:
					result = element.attr(attributeName);
					break;
				// Return the full html including elements and attributes
				case MetadataScraperConfigEntryExtractionType.HTML:
					result = element.html();
				default:
					break;
			}
		}

		return result;
	}

	// Extracts the data from the string based on @processMode
	// e.g.
	// regex: this wont be extracted |but this will| - regex - |(.*)| will extract
	//       "but this will"
	// constant: this wont be extracted - constant - FIXED_CONSTANT will extract
	//       "FIXED_CONSTANT"
	private String extractData(String input, MetadataScraperConfigEntryProcessMode processMode, String value)
	{
		String output = "";
		switch(processMode)
		{
			case MetadataScraperConfigEntryProcessMode.REGEX:
				// efault regex to (.+) if none is provided
				if(value == null || value == "''" || value=="\"\"")
				{
					 value = "(.+)";
				}

				Matcher matches = input =~ /${value}/;

				String seperator = "";
				while(matches.find())
				{
					int numberGroups = matches.groupCount();

					// Only extract data if at least one group is specified
					if(numberGroups > 0)
					{
						String newData = "";

						// Extract all values within the group
						for(int i = 1 ; i <= numberGroups; i++)
						{
							newData = newData + matches.group(i);
						}

						// Only add if data is not empty
						if(newData != "")
						{
							output = output + newData;
							output = output + seperator;

							// Add the separator only after the first item
							seperator = config.getMetadataDelimiter();
						}
					}
				}
				break;
			case MetadataScraperConfigEntryProcessMode.CONSTANT:
				output = value;
				break;
		}

		return output;
	}

	// Adds or appends a meta data entry with @name and contents of @value
	private void addMetaData(Document doc, String name, String value)
	{
		// Add meta data to head
		Element head = doc.head();

		// Assumes that meta data names are unique
		Element meta = doc.select("meta[name=${name}]").first();

		if(meta != null)
		{
			// Append the new value to the existing content
			String newContents = meta.attr("content") + config.getMetadataDelimiter() + value ;
			meta.attr("content", newContents);
			logger.info("Updated '${meta.toString()}'");
		}
		else
		{
			// Add a new meta data with @name and content of @value
			meta = head.appendElement("meta").attr("name", "${name}").attr("content", value);
			logger.info("Added '${meta.toString()}'");
		}
	}
}