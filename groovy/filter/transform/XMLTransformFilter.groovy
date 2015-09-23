package com.funnelback.services.filter;

import org.apache.log4j.Logger;
import java.text.*
import java.util.regex.*;
import java.io.*;
import java.text.*

import com.funnelback.common.*
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

import groovy.util.slurpersupport.*;

@groovy.transform.InheritConstructors
public class XMLTransformFilter extends com.funnelback.common.filter.ScriptFilterProvider
{
	private static final Logger logger = Logger.getLogger(XMLTransformFilter.class);

	// the google API url base is a constant
	public static final String GOOGLE_API_URL = "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=";

  public final static String XML_SOURCE = "xml_source";
  public final static String XML_OFFLINE = "xml_offline";

  public String xmlSourceFolder = "";
  public String xmlSourceFolderOffline = "";

  public int id = 0;

  public final static String HTML_ELEMENT_REGEX = "<[^>]+>"

  //Constructor
  public XMLTransformFilter(String collectionName, boolean inlineFiltering)
  {
    super(collectionName, inlineFiltering);

    String searchHome = Environment.getValidSearchHome()

    xmlSourceFolder = searchHome + File.separator + "conf" + File.separator + collectionName + File.separator + XML_SOURCE + File.separator;
    xmlSourceFolderOffline = searchHome + File.separator + "conf" + File.separator + collectionName + File.separator + XML_OFFLINE + File.separator;    
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

    GPathResult xml;

    try
    {
      //Only run filter for html documents
      //CHANGE: Add URL to ensure that the filter only runs on certain documents
      if(documentType ==~ /\.html|html/)
      {
        xml = getXMLDocument(input);
        process(xml);               
      }
    }
    catch(Exception e)
    {
      //log the error
      println(e.toString ());
      logger.error(e.toString ());
    }

    //return the filtered html
    if(xml != null)
    {
      return xml.toString();
    }
    else
    {
      return input;
    }  
 	}

  public String process(GPathResult xml)
  {
    // Loop through each record in the xml and generate their respective
    // transformed xml records
    xml.'rdf:Description'.each()
    {
      // Generate XML
      processExpert(it);
    }

  }

  public String processExpert(GPathResult expert)
  {
    // Extract the author
    String authorID = cleanseHTMLElements(expert.'@rdf:about'.text());
    String firstname = cleanseHTMLElements(expert.'foaf:firstName'.text());
    String surname = cleanseHTMLElements(expert.'foaf:lastName'.text());

    // Create an XML record for each publication
    expert.'fb:publication'.each()
    {
      write(generateXML(authorID, it.text(), firstname, surname), generateFileName(authorID))
    }   
  }

  public String generateXML(String authorID, String publication, String firstname = "", String surname = "" )
  {
    String xml = 
    """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<records>
  <record>
    <authorID><![CDATA[${authorID}]]></authorID>
    <firstname><![CDATA[${firstname}]]></firstname>
    <surname><![CDATA[${surname}]]></surname>
    <publicationTitle><![CDATA[${publication}]]></publicationTitle>
  </record>
</records>"""
    return xml;
  }

  // Writes the xml to the specified file. The file parameter must contain the full
  // Path and filename.
  public void write(String xml, String filename)
  {
    logger.info("Writing '${filename}'");

    // Create a new file object for the xml
    File newFile = new File(generateFullFilePath(filename));

    // Ensure that the directory exists
    File parentDirectory = newFile.getParentFile();

    if(!parentDirectory.exists())
    {
      parentDirectory.mkdirs();
    }

    PrintWriter pw;

    try
    {
      // Open a print writer stream to write the contents of the xml to file in utf8 format
      pw = new PrintWriter(new OutputStreamWriter(new FileOutputStream(newFile),"UTF8"));

      pw.print(xml);

      // Commit the changes to disk and close the file
      pw.flush();
    }
    catch(Exception e)
    {
      // Rethrow the exception
      throw e;
    }
    finally
    {
      // Ensure that we always close the file
      if (pw != null)
      {
        pw.close();
      }
    }
  }
  // Returns a file safe name for @name
  public String generateFileName(String name)
  {
    name = name.replaceAll("http://www.findanexpert.unimelb.edu.au/individual/", "");
    
    return getID().padLeft(6,"0") + "_" + URLEncoder.encode(name, "UTF-8") + ".xml";    
  }

  // Return the full path and file name of the file to add/update/delete
  public String generateFullFilePath(String filename)
  {
    return getOfflineFolder() + filename;
  }

  //returns the full source folder
  public String getSourceFolder()
  {
    return xmlSourceFolder;
  }

  //returns the full offline folder
  public String getOfflineFolder()
  {
    return xmlSourceFolderOffline;
  }  

  // Generates an ID
  public String getID()
  {
    // TEMP CODE
    if(id > 20000)
      throw new Exception("limit exceeded");

    String output = id++;

    return output.toString();
  }

  // Remove all html elements (<a> </p> <strong> etc.) from @input
  public String cleanseHTMLElements(String input)
  {
    return input.replaceAll(/${HTML_ELEMENT_REGEX}/, "");
  }

 	//Attempts to obtain the value of the @configName found in collection.cfg
 	//Defaults to @defaultValue
 	public String readCollectionConfig(String configName, String defaultValue )
 	{
    String output = "";
    //Setup the URL Config
    try 
    {
      output = config.value(configName);

      if(output == null)
      {
        throw new Exception("No config found for '${configName}'")
      }
    }
    catch(Exception e) 
    {
      output = defaultValue;
      
      println("Unable to find any value for ${configName}. Using default value of '${defaultValue}'");
      logger.info("Unable to find any value for ${configName}. Using default value of '${defaultValue}'");
    }

    return output;
 	}

  /**
  * Read the configuration file and store valid lines
  * @param configFile Location of the config file
  * @throws IOException
  */
  private Map readCollectionConfig(String prefix) throws IOException {
    Map<String, String> data = config.getConfigData();
    
    def output = [:];

    data.each()
    {
      key, value ->
        try 
        {
          if(key.startsWith(ENTRY_PREFIX))
          {
            int delimiterLocation =  value.indexOf(configDelimiter);

            if(delimiterLocation > 0)
            {            
              String name = value.substring(0, delimiterLocation);
              String selector = value.substring(delimiterLocation+1)
              
              //Ensure that the selector is valid. Invalid selectors will throw an exception
              validateSelector(selector);
              
              //add the <name>:<value> string pair to the map
              output.put(name,selector);
            }
            else
            {
              logger.warn("Invalid line '${key}:${value}' in configuration file for collection '${collectionName}'");
            }
          }
          
        }
        catch(Exception e) 
        {
          logger.warn("Invalid line '${key}:${value}' in configuration file for collection '${collectionName}'");
          logger.warn(e.toString());
        }        
    }

    return output;
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

  //Parse the input and returns an XmlParser
  public GPathResult getXMLDocument(String input)
  {
    Map namespace = 
    [
      "geo" : "http://aims.fao.org/aos/geopolitical.owl#",
      "skos" : "http://www.w3.org/2004/02/skos/core#",
      "ero" : "http://purl.obolibrary.org/obo/",
      "event" : "http://purl.org/NET/c4dm/event.owl#",
      "fn" : "http://www.w3.org/2005/xpath-functions#",
      "pvs": "http://vivoweb.org/ontology/provenance-support#",
      "dc": "http://purl.org/dc/elements/1.1/",
      "vivo": "http://vivoweb.org/ontology/core#",
      "swrlb": "http://www.w3.org/2003/11/swrlb#",
      "vitro": "http://vitro.mannlib.cornell.edu/ns/vitro/0.7#",
      "rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
      "bibo": "http://purl.org/ontology/bibo/",
      "foaf": "http://xmlns.com/foaf/0.1/",
      "oext": "http://oracle.com/semtech/jena-adaptor/ext/function#",
      "owl": "http://www.w3.org/2002/07/owl#",
      "dcterms": "http://purl.org/dc/terms/",
      "scires": "http://vivoweb.org/ontology/scientific-research#",
      "ouext": "http://oracle.com/semtech/jena-adaptor/ext/user-def-function#",
      "fb": "http://www.funnelback.com/ontology/",
      "xsd": "http://www.w3.org/2001/XMLSchema#",
      "swrl": "http://www.w3.org/2003/11/swrl#",
      "rdfs": "http://www.w3.org/2000/01/rdf-schema#",
      "fae": "http://www.findanexpert.unimelb.edu.au/ontology/"
    ]

  	return new XmlSlurper().parseText(input).declareNamespace(namespace);
  }

  //Allows for basic testing
  public static void main(String[] args)
  {
    def f = new XMLTransformFilter("demo-supercheap-auto-web", true).filter(new File("C:/Users/gioan/Desktop/test.html").getText(), ".html", "http://www.hrcareers.com.au/jobs/10924/technical-learning-manager/index.cfm");

    /* Write out results UTF-8 mode */
    PrintWriter objPW;
    try
    {                    
      File extMDFile = new File('C:/Users/gioan/Desktop/results.html');
      //open a print writer stream to write the contents of the xml to file in utf8 format
      objPW = new PrintWriter(new OutputStreamWriter(new FileOutputStream(extMDFile),"UTF8"));
      objPW.print(f);

      //commit the changes to disk and close the file
      objPW.flush();
    }
    catch(Exception e)
    {
       println e.toString();
       throw e;
    }
    finally
    {
      //ensure that we always close the file
      if (objPW != null)
      {
        objPW.close();
      }
    }
  }
}
