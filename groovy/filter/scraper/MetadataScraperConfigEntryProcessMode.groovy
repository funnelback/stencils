package com.funnelback.stencils.filter.scraper;

// For the jackson annotation
import com.fasterxml.jackson.annotation.*;
import com.fasterxml.jackson.databind.annotation.*;

// Contains all the valid options for the extraction type in the meta data scraper
// Ignore all properties from the JSON if it not known
@JsonIgnoreProperties(ignoreUnknown = true)
public enum MetadataScraperConfigEntryProcessMode
{
	REGEX("REGEX", "Regular expression"),
	CONSTANT("CONSTANT", "Extract the content within an attribute");

	String id;
	String description;

	// Private constructor required for the JSON deserialisation process
	private MetadataScraperConfigEntryProcessMode(String id, String description)
	{
		this.id = id;
		this.description = description;
	}

	/*
		Gets a MetadataScraperConfigProcessModeCodes using the id or null if the requested enum doesn't exist.
		@param id String
		@return ExtractionTypeCodes
	*/
	public static MetadataScraperConfigEntryProcessMode get(String id)
	{
		if (id != null)
		{
			// Using for loop as .each() still executes even if a return statement is encountered
			for (MetadataScraperConfigEntryProcessMode current: MetadataScraperConfigEntryProcessMode.values())
			{
				if (id.equalsIgnoreCase(current.id))
				{
					return current;
				}
			}
		}

		return null;
	}
}