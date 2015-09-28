Scrapers
=================

# Metadata Scraper

* Ever find the need to extract content from the body of the HTML and reinsert it as meta data?
* Do you always write a specific filter each time for each client and for each collection?
* Do you struggle with regular expressions?

This filter aims to solve these problems using a single configuration file. It allows the user to extract data using CSS selectors (e.g. ```div.myclass#myid[attribute=myattributename]```) and associate it back into the document as metadata.

## Getting Started
To implement this script, you will need to create/edit the following files:

* collection.cfg
* stencils.filter.scraper.metadata_scraper.json

Details of the above configuration files can be found below.

### collection.cfg

Enabling and configuring the metadata scraper filter is done via ```collection.cfg``` for each collection.

#### Enabling the Metadata Scraper Filter

To enable the metadata scraper filter, you will need to do is add the ```com.funnelback.stencils.filter.scraper.MetaDataScraperFilter```  to the [filter chain](http://docs.funnelback.com/filter_classes_collection_cfg.html). Below is an example:

```
filter.classes=CombinerFilterProvider,TikaFilterProvider,ExternalFilterProvider:DocumentFixerFilterProvider:com.funnelback.stencils.filter.scraper.MetaDataScraperFilter
```

#### Delimiter

You can also specify a delimiter which is used separate the content metadata field. This is useful to:

* Append new metadata to an existing metadata field
* Extract multiple fields and append them to the same metadata

The following is the config required to set the delimiter:

```
stencils.filter.scraper.metadata_scraper.delimiter=<delimiter>
```

* ```delimiter```: The delimiter to use. The default value is ```|```

### stencils.filter.scraper.metadata_scraper.json

The next step is to configure the filter by creating ```stencils.filter.scraper.metadata_scraper.json``` under the collection root folder.

i.e. ```$SEARCH_HOME/conf/$COLLECTION_NAME/stencils.filter.scraper.metadata-scraper.json```

This file needs to contain a JSON object specifying how the metadata scraper should run in the following format:

```json
[
	{
		"url" : "<url>",
		"metadataName" : "<metadata name>",
		"selector" : "<selector>",
		"negate" : "<negate",
		"extractionType" : "<extraction type>",
		"attributeName" : "<attribute name>",
		"processMode" : "<process mode>",
		"value" : "<value>",
		"description" : "<description>"
	}
]
```

* ```url```: The url pattern to apply the rule to as a regular expression
* ```metadata name```: The name of the new metadata
* ```selector```: The css style selector in which to obtain the contents
* ```negate```: optional - *true* / *false* - Reverses the logic of the selector so that the rule only runs if the selector is not found. If this option is set to *true*, the ```processMode``` must be set to __constant__.
* ```extraction type```: text, attr or html

	__text__ - Instructs the script to extract all content in between the tags. e.g  ```<div>text to be extracted</div>```. Note: if text is selected, you will need to specify a blank <attribute name>

	__attr__ - Instructs the filter to extract the contents from an attribute. e.g ```<a href="text to be extracted">```

	__html__ - Instructs the filter to extract the HTML contents of the tag. This is useful in order to assign full html markup to meta data. Please note that all single quotes and double will be replaced with ```&#39;``` and ```&#34;``` respectively.

* ```attribute name```: This is required if __attr__ is selected from extraction type. It determines which attribute the scripts will look at in order to extract the content.
* ```process mode```: This is required if __attr__ is selected from extraction type. Valid values are __regex__ or __constant__.

	__regex__: Specifies that the <Value> will be a regular expression where the contents that is to be extracted is the all "groups". i.e. Given the text "I am human and canine" and the regex "I am (human) and (canine)", the extracted value will be "humancanine". You can also ignore specific groups by using the non-capturing syntax of "?:" i.e. Given the text "I am human and canine" and the regular expression "I am (?:human) and (canine)", the extracted value will be "canine".

	__constant__: A hardcoded value which will be added to the metadata field.

* ```value```: Either a valid regular expression or a constant depending on what is specified for ```process mode```
* ```description```: A brief description of the purpose of the rule

An example of the the configuration can be found below:

```json
[
	{
		"url": "www\\.swinburne\\.edu\\.au/study/courses",
		"metadataName": "course.name",
		"selector": ".title-block h1",
		"extractionType": "text",
		"attributeName": "",
		"processMode": "regex",
		"value": "(.+)",
		"description": "Course name"
	}
]
```

The above will apply the metadata scraper filter to all urls which falls under Swinburne's study/courses subdirectories. It will extract the content ".title-block h1" (the heading) and add it into a metadata called "course.name".

*Note: It is possible for rules to refer to metadata created by a preceeding rules as they executed in the order that they are specified.*

## Example

http://www.swinburne.edu.au/business-law/staff-profiles/view.php?who=mgilding

```json
[
	{
		"url": "www\\.swinburne\\.edu\\.au/",
		"metadataName": "people.name",
		"selector": "td div h2",
		"extractionType": "text",
		"attributeName": "",
		"processMode": "regex",
		"value": "(.+)",
		"description": "Name"
	},
	{
		"url": "www\\.swinburne\\.edu\\.au/",
		"metadataName": "people.position",
		"selector": "td div>p:first-of-type",
		"extractionType": "text",
		"attributeName": "",
		"processMode": "regex",
		"value": "(.+)",
		"description": "Position"
	},
	{
		"url": "www\\.swinburne\\.edu\\.au/",
		"metadataName": "people.faculty",
		"selector": "td div>p:nth-child(3) strong",
		"extractionType": "text",
		"attributeName": "",
		"processMode": "regex",
		"value": "(.+)",
		"description": "Faculty"
	},
	{
		"url": "www\\.swinburne\\.edu\\.au/",
		"metadataName": "robots",
		"selector": "meta[name=people.name]",
		"negate": true,
		"processMode": "constant",
		"value": "noindex",
		"description": "Prevents the page from being index if no name is found"
	}
]

```

Produces:

```
- Successfully added: '{"url":"www\\.swinburne\\.edu\\.au/","metadataName":"people.name","selector":"td div h2","extractionType":"text","attributeName":"","processMode":"regex","value":"(.+)","description":"Name"}'
- Successfully added: '{"url":"www\\.swinburne\\.edu\\.au/","metadataName":"people.position","selector":"td div>p:first-of-type","extractionType":"text","attributeName":"","processMode":"regex","value":"(.+)","description":"Position"}'
- Successfully added: '{"url":"www\\.swinburne\\.edu\\.au/","metadataName":"people.faculty","selector":"td div>p:nth-child(3)
- Successfully added: '{"url":"www\\.swinburne\\.edu\\.au/","metadataName":"robots","selector":"meta[name=people.name]","negate":true,"processMode":"constant","value":"noindex","description":"Prevents the page from being index if no name is found"}'
- Added '<meta name="people.name" content="Michael GILDING" />'
- Added '<meta name="people.position" content="Executive Dean, Faculty of Business and Law" />'
- Added '<meta name="people.faculty" content="Faculty of Business and Law" />'
```


## Handy Tips

### Testing CSS Selectors

* In Firefox, the 'FireFinder' add-on can be a useful tool for checking your CSS Selector(s), highlighting the corresponding HTML elements.
* For Chrome, use "CSS Selector Tester"