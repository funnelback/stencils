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
public class MetadataScraperConfigEntryProcessModeDeserializer extends JsonDeserializer
{
	private static final Logger logger = LogManager.getLogger(MetadataScraperConfigEntryProcessModeDeserializer.class);

	@Override
	public MetadataScraperConfigEntryProcessMode deserialize(JsonParser jp, DeserializationContext dc) throws IOException, JsonProcessingException
	{
		MetadataScraperConfigEntryProcessMode type = MetadataScraperConfigEntryProcessMode.get(jp.getValueAsString());

		if (type != null)
		{
			return type;
		}
		else
		{
			String validValues = MetadataScraperConfigEntryProcessMode.values().join(", ");
			throw new JsonMappingException("'${jp.getValueAsString()}' is an invalid value for 'processMode'. Valid values are ${validValues}");
		}
	}
}
