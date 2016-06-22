package com.funnelback.stencils.filter.scraper;

// Used for all the regular expressions
import java.util.regex.*;

// JSOUP for doc manipulation and selections
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Entities.EscapeMode;

// For the jackson annotation
import com.fasterxml.jackson.annotation.*;
import com.fasterxml.jackson.databind.annotation.*;

// Logging
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


// Represents one config entry in the metadata scraper config file
// Ignore all properties from the JSON if it not known
@JsonIgnoreProperties(ignoreUnknown = true)
public class MetadataScraperConfigEntry
{
	public final static String MINIMAL_HTML = "<html><head></head><body></body></html>";

	// Set up the logger
	private static final Logger logger = LogManager.getLogger(MetadataScraperConfigEntry.class);

	// Attributes of the config entry class
	private String url;
	private String metadataName = "";
	private String selector = "";
	private boolean negate = false;
	private MetadataScraperConfigEntryExtractionType extractionType;
	private String attributeName = "";
	private MetadataScraperConfigEntryProcessMode processMode;
	private String value;
	private String description;

	public MetadataScraperConfigEntry(
		String url,
		String metadataName,
		String selector,
		boolean negate,
		MetadataScraperConfigEntryExtractionType extractionType,
		String attributeName,
		MetadataScraperConfigEntryProcessMode processMode,
		String value,
		String description) throws Exception
	{
		this.setURL(url);
		this.setMetadataName(metadataName);
		this.setSelector(selector);
		this.setNegate(negate);
		this.setExtractionType(extractionType);
		this.setAttributeName(attributeName);
		this.setMetaValueType(metaValueType);
		this.setValue(value);
		this.setDescription(description);
	}

	// Jackson requires that objects specified in a collections requires an empty constructor
	private MetadataScraperConfigEntry()
	{
	}

	@JsonProperty("url")
	public String getURL()
	{
		return url;
	}

	@JsonSetter("url")
	public void setURL(String input)
	{
		url = input;
	}

	@JsonProperty("metadataName")
	public String getMetadataName()
	{
		return metadataName;
	}

	@JsonSetter("metadataName")
	public void setMetadataName(String input)
	{
		metadataName = input;
	}

	@JsonProperty("selector")
	public String getSelector()
	{
		return selector;
	}

	@JsonSetter("selector")
	public void setSelector(String input)
	{
		try
		{
			Document validationDoc = Jsoup.parse(MINIMAL_HTML);
			validationDoc.select(input);
			selector = input;
		}
		catch(Exception e)
		{
			throw new Exception("'${input}' is not a valid selector")
		}
	}

	@JsonProperty("negate")
	public boolean getNegate()
	{
		return negate;
	}

	@JsonSetter("negate")
	public void setNegate(boolean input)
	{
		negate = input;

		// Ensure that the process mode is set to CONSTANT as it is the
		// only valid value when negate is set to true
		if(negate == true)
		{
			setProcessMode(MetadataScraperConfigEntryProcessMode.CONSTANT);
		}
	}

	@JsonProperty("extractionType")
	public MetadataScraperConfigEntryExtractionType getExtractionType()
	{
		return extractionType;
	}

	// Extraction type must be from a finite list which has been defined in an enum
	@JsonSetter("extractionType")
	@JsonDeserialize(using = MetadataScraperConfigEntryExtractionTypeDeserializer.class)
	public void setExtractionType(MetadataScraperConfigEntryExtractionType input)
	{
		extractionType = input;
	}

	@JsonProperty("attributeName")
	public String getAttributeName()
	{
		return attributeName;
	}

	@JsonSetter("attributeName")
	public void setAttributeName(String input)
	{
		attributeName = input;
	}

	@JsonProperty("processMode")
	@JsonDeserialize(using = MetadataScraperConfigEntryProcessModeDeserializer.class)
	public MetadataScraperConfigEntryProcessMode getProcessMode()
	{
		return processMode;
	}

	// Process mode must be from a finite list which has been defined in an enum
	@JsonSetter("processMode")
	public void setProcessMode(MetadataScraperConfigEntryProcessMode input)
	{
		if(negate == true && input != MetadataScraperConfigEntryProcessMode.CONSTANT)
		{
			logger.info("Negate has been specified as 'true'. Automatically setting process mode to ${MetadataScraperConfigEntryProcessMode.CONSTANT}")
			processMode = MetadataScraperConfigEntryProcessMode.CONSTANT
		}
		else
		{
			processMode = input;
		}
	}

	@JsonProperty("value")
	public String getValue()
	{
		return value;
	}

	@JsonSetter("value")
	public void setValue(String input)
	{
		value = input;
	}

	@JsonProperty("description")
	public String getDescription()
	{
		return description;
	}

	@JsonSetter("description")
	public void setDescription(String input)
	{
		description = input;
	}

	// Returns true if the @input passed in matches the
	// url pattern stored
	public boolean matchURL(String input)
	{
		Matcher matches = input =~ /${this.url}/
		if(matches.find())
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	// Produces a String representation of the config entry
	public String toString ()
	{
		return "{ url: '${getURL()}'" +
		 ", meta name: '${getMetadataName()}'" +
		 ", selector: '${getSelector()}'" +
		 ", negate: '${getNegate()}'" +
		 ", extraction type: '${getExtractionType()}'" +
		 ", attribute name: '${getAttributeName()}'" +
		 ", process mode: '${getProcessMode()}'" +
		 ", value: '${getValue()}'" +
		 ", description: '${getDescription()}' }";
	}
}
