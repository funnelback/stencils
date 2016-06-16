package com.funnelback.stencils.filter.scraper;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.annotation.*;

import java.io.IOException;

// Logging
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


// Class to help deserialise string representation of enums
public class MetadataScraperConfigEntryExtractionTypeDeserializer extends JsonDeserializer
{
	private static final Logger logger = LogManager.getLogger(MetadataScraperConfigEntryExtractionTypeDeserializer.class);

	@Override
	public MetadataScraperConfigEntryExtractionType deserialize(JsonParser jp, DeserializationContext dc) throws IOException, JsonProcessingException
	{
		MetadataScraperConfigEntryExtractionType type = MetadataScraperConfigEntryExtractionType.get(jp.getValueAsString());

		if (type != null)
		{
			return type;
		}
		else
		{
			String validValues = MetadataScraperConfigEntryExtractionType.values().join(", ");
			throw new JsonMappingException("'${jp.getValueAsString()}' is an invalid value for 'extractionType'. Valid values are ${validValues}");
		}
	}
}
