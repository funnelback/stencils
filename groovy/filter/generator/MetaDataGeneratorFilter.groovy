package com.funnelback.services.filter;

import java.text.*
import java.util.Calendar;
import java.util.regex.*;
import java.io.*;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Entities.EscapeMode;

import com.funnelback.common.*
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.log4j.Logger;

import groovy.xml.MarkupBuilder;
import groovy.json.JsonSlurper;

/*
  Uses Funnelback explore function to generate a set of subject meta data for a url
*/
@groovy.transform.InheritConstructors
public class MetadataGeneratorFilter extends com.funnelback.common.filter.ScriptFilterProvider
{
  private static final Logger logger = Logger.getLogger(MetaDataGeneratorFilter.class);

  public final static String SEARCH_HOME =  Environment.getValidSearchHome();

  public String collectionName;

  //needs to be detected from indexer options
  public final String META_DATA_DELIMITER_CONFIG_NAME = "filter.meta_data_generator.delimiter";
  public final String META_DATA_DELIMITER_DEFAULT = "|";
  public String metaDataDelimiter;

  public final String CHARACTER_BLACKLIST_CONFIG_NAME = "filter.meta_data_generator.character_blacklist";
  //Only accept letters and spaces
  public final String CHARACTER_BLACKLIST_DEFAULT = "[^a-zA-Z\\s]";
  public String charBlacklistRegEx;

  public final String BLACKLIST_CONFIG_NAME = "filter.meta_data_generator.blacklist";
  public final String BLACKLIST_DEFAULT = ".{1,2}";
  public String blacklistRegEx;

  public final String TARGET_META_DATA_CONFIG_NAME = "filter.meta_data_generator.meta_data";
  public final String TARGET_META_DATA_DEFAULT = "fb.subject";
  public String targetMetaData;

  public final String SERVER_CONFIG_NAME = "filter.meta_data_generator.server";
  public final String SERVER_DEFAULT = "http://search-au.funnelback.com/s/search.json";
  public String server;

  //Constructor
  public MetadataGeneratorFilter(String collectionName, boolean inlineFiltering)
  {
    super(collectionName, inlineFiltering);

    //Set the collection name
    this.collectionName = collectionName;

    //Read the settings required for the filter
    metaDataDelimiter =  readCollectionConfig(META_DATA_DELIMITER_CONFIG_NAME, META_DATA_DELIMITER_DEFAULT );
    charBlacklistRegEx = readCollectionConfig(CHARACTER_BLACKLIST_CONFIG_NAME, CHARACTER_BLACKLIST_DEFAULT );
    blacklistRegEx = readCollectionConfig(BLACKLIST_CONFIG_NAME, BLACKLIST_DEFAULT );
    targetMetaData = readCollectionConfig(TARGET_META_DATA_CONFIG_NAME, TARGET_META_DATA_DEFAULT );
    server = readCollectionConfig(SERVER_CONFIG_NAME, SERVER_DEFAULT );    
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

    Document doc;

    try
    {
      //Only run filter for html documents
      if(documentType ==~ /\.html|html/)
      {
        String subjects = extractSubjects(address)
        if(subjects != "")
        {
          doc = getDocument(input, address);
          addMetaData(doc, targetMetaData, subjects);
        }
      }
    }
    catch(Exception e)
    {
      //log the error
      println(e.toString ());
      logger.error(e.toString ());
    }

    //return the filtered html
    if(doc != null)
    {
      return doc.html();
    }
    else
    {
      return input;
    }         
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

 //Converts a string representation of a html page to a JSOUP Document object
 //Ensures that the character encoding of the document is maintained
 public Document getDocument(String input, String address)
 {
    Document doc;

    //Converts the String into InputStream
    InputStream is = new ByteArrayInputStream(input.getBytes());
    BufferedInputStream bis = new BufferedInputStream(is);
    bis.mark(Integer.MAX_VALUE);
    //Get the character set
    String c = TextUtils.getCharSet(bis);
    bis.reset();
    //Create the JSOUP document object with the calculated character set
    doc = Jsoup.parse(bis, c, address);      
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

  //Obtains the page preview and saves it into the destination folder
  public String extractSubjects(String address)
  {
    String output = "";

    try 
    {
      JsonSlurper objSlurper = new JsonSlurper();

      //Generate the URL which produces the subject
      String url =  generateURL(address);

      //Obtain a JSON object of the transaction
      def transaction = downloadJSON(url);

      //Get the subject and add it to the document
      output = getSubjects(transaction);
         
    }
    catch(Exception e) 
    {
      println("Unable to generate subject meta data for '${address}'");
      println("Error: '${e.toString()}'");

      logger.info("Unable to generate subject meta data for '${address}'");
      logger.info("Error: '${e.toString()}'");
    }

    return output;   
  }

  //Using the @address to create the url required which produces
  //the meta data
  public String generateURL(String address)
  {
    return server + "?" + 
    "collection=" + collectionName +
    "&query=explore:" + address
  }

  //Downloads the contents from a URL and outputs into the @filename
  public Object downloadJSON(String address) throws Exception
  {
    JsonSlurper objSlurper = new JsonSlurper();
    return objSlurper.parseText(address.toURL().getText());
  }

  //Extracts the subject from a json @transaction
  public String getSubjects(def transaction)
  {
    if(transaction.response.resultPacket.resultsSummary.fullyMatching > 0)
    {
      //Potential metadata is stored under query cleaned
      String exploreResponse = transaction.response.resultPacket.queryCleaned;
      
      //Cleanse items on the blacklist
      exploreResponse = exploreResponse.replaceAll(/${charBlacklistRegEx}/, "").trim();;

      TreeSet metadata = exploreResponse.split(" ") as TreeSet;

      //sort alphabetical
      Comparator c = [ compare:
        {
          a,b-> a.compareTo(b)? 0:1 
        }
      ] as Comparator

      metadata.sort(c);

      
      //Replace all spaces with the meta data delimeter
      String output = "";

      metadata.each()
      {
        if (!(it ==~ /${blacklistRegEx}/))
        {
          output = output + metaDataDelimiter + it;
        }
      }

      //remove the first and multiple delimiters
      output = output.replaceAll(/\|+/, metaDataDelimiter);
      output = output.replaceFirst(/\${metaDataDelimiter}/, "");

      return output;
    }
    else
    {
      throw new Exception("No data available in live view");
    }
  }

  public Comparator getComparator()
  {
    
  }

  //Adds or appends a meta data entry with @name and contents of @value
  public void addMetaData(Document doc, String name, String value)
  {
    //Add meta data to head
    Element head = doc.head();

    //Assumes that meta data names are unique
    Element meta = doc.select("meta[name=${name}]").first();

    if(meta != null)
    {
      //Append the new value to the existing content
      String newContents = meta.attr("content") + config.metaDataDelimiter + value;
      meta.attr("content", newContents);
    }
    else
    {
      //Add a new meta data with @name and content of @value
      head.appendElement("meta").attr("name", "${name}").attr("content", value);
    }
  }

  // A main method to allow very basic testing
  public static void main(String[] args)
  {
    def f = new MetaDataGeneratorFilter("demo-supercheap-auto-web", true).filter(new File("C:/Users/gioan/Desktop/test.html").getText(), ".html", "http://www.unisanet.unisa.edu.au/Staff/homepage.asp?Name=David.Pike");

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

