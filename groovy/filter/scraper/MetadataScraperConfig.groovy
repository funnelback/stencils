package com.funnelback.stencils.filter.scraper;

// Used for all the regular expressions
import java.util.regex.*;

// Logging
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

// JSON processing
import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.core.JsonParser;


// Represents a collection of config entries. It will provide various functions
// to manipulate and locate individual entries
public class MetadataScraperConfig
{
	private List<MetadataScraperConfigEntry> configEntries;
	private String metadataDelimiter;

	// Set up the logger
	private static final Logger logger = Logger.getLogger(MetadataScraperConfig.class);

	/*
		@filename: A file containing JSON which details the config rules for scraping
		@metadataDelimiter: The delimeter which is to be used to separate multiple entries within a metadata field
	*/
	public MetadataScraperConfig(String filename, String metadataDelimiter) throws Exception
	{
		configEntries = new ArrayList<MetadataScraperConfigEntry>();
		this.metadataDelimiter = metadataDelimiter;

		// Create the mapper object in order to manipulate the config file
		ObjectMapper mapper = new ObjectMapper();
		// Global mapper configurations to dictate the behaviour
		mapper.configure(JsonParser.Feature.ALLOW_COMMENTS, true);

		// Obtain a reference to the config file
		File jsonFile = new File(filename);

		// Convert the json file into json nodes which can be transversed and validated
		JsonNode rootNode = mapper.readValue(jsonFile, JsonNode.class);

		// Create a meta data scraper config entry for each entry in the json file
		rootNode.each()
		{
			node ->

			try
			{
				// Create an instance of the config entry class for the current node using the mapper
				configEntries.push(mapper.treeToValue(node, MetadataScraperConfigEntry.class));
				logger.info("Successfully added: '${node.toString()}'")
			}
			catch(Exception e)
			{
				// Print out error
				logger.info("The following entry is invalid: '${node.toString()}'");
				logger.info(e.getMessage());

				// Show the stack trace on debug mode only
				logger.debug(e);
			}
		}

		logger.info("Successfully read configurations from '${filename}' using ${metadataDelimiter} as the metadata delimeter");
	}

	// Returns true if the url matches any in the config
	public boolean containsURL(String URL)
	{
		boolean result = false;

		configEntries.each()
		{
			if(it.matchURL(URL))
			{
				result = true;
			}
		}

		return result;
	}

	public List<MetadataScraperConfigEntry> getConfigEntries()
	{
		return configEntries;
	}

	public String getMetadataDelimiter()
	{
		return metadataDelimiter;
	}
}
