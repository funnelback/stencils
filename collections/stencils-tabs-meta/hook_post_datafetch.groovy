import org.apache.log4j.Logger;

/*
  All functions - Begin
*/

// Re-populate known facets if none is generated
populateEmptyFacets();

/*
  Custom function definitions
*/

// Re-populate known facets if none is generated. This is to be used to ensure
// knowns tabs are always displayed even if the search produces no results for that
// tab
public void populateEmptyFacets()
{
  if(transaction?.question != null
    && transaction?.response != null)
  {
    StencilTabService.populateTabs(transaction.question, transaction.response);
  }
}

/*
  This is a class which will perform common tab related tasks on the Funnelback data model
*/
public class StencilTabService
{
  private static String PROPERTIES_CONFIG_SEPARATOR = "=";
  private static String COLLECTION_CONFIG_SEPARATOR = ".";
  private static String GSCOPE_CONFIG_SEPARATOR = ",";
  private static String METADATA_CONFIG = "stencils.tabs.full_facet.metadata";
  private static String GSCOPE_CONFIG = "stencils.tabs.full_facet.gscope";

  private static Logger logger = org.apache.log4j.Logger.getLogger("com.funnelback.stencils.tabs.hook_post_datafetch");

  /*
    Reads from the collection.cfg file to see if tabs needs to be prepopulated.

    i.e. Repopulates facets with 0 results.

    e.g.
      If there are three possible tabs (A, B and C), but there are no results for items under
      tab C, this function will ensure that the C facet is re-injected with the count of 0

    collection.cfg config needs to follow the format specified below:
    stencils.tabs.full_facet.gscope=x
    stencils.tabs.full_facet.metadata.<metadata class>.1=<value>
    stencils.tabs.full_facet.metadata.<metadata class>.2=<value>

    e.g.
      stencils.tabs.full_facet.gscope=1,2,3,4
      stencils.tabs.full_facet.metadata.tabs.1=web
      stencils.tabs.full_facet.metadata.tabs.2=courses

  */
  public static void populateTabs(def question, def response)
  {
    try
    {
      // Read the config from the collection.cfg
      List<Integer> gscopeRMCS = getConfigFullFacetGscope(question);
      // Ensure empty facets are repopulated
      populateEmptyFacetsGScope(response, gscopeRMCS);

      // Read the config from the collection.cfg
      Map metadataRMCS = getConfigFullFacetMetadata(question);
      // Ensure empty facets are repopulated
      populateEmptyFacetsMetadata(response, metadataRMCS);
    }
    catch(Exception e)
    {
      logger.error("Error with populating empty tabs", e);
    }
  }

  /*
    Reads the collection.cfg settings from @question in order to
    find out the gscope rmcs which needs to always appear

    It expects the configurations to be in the following format:
    stencils.tabs.full_facet.gscope=<x> where x is the number of the gscope

    e.g.
      stencils.tabs.full_facet.gscope=5
      stencils.tabs.full_facet.gscope=1,2,3,4
  */
  private static List<Integer> getConfigFullFacetGscope(def question)
  {
    List<Integer> output = [];

    String config = question.collection.configuration.value(GSCOPE_CONFIG);

    // Split the delimitered list into an array list of integers
    if(config != null)
    {
      output = config.split(GSCOPE_CONFIG_SEPARATOR).collect {it.toInteger()};
    }

    return output;
  }

  /*
    Ensures that facets based off gscopes in the @rmcs list are always displayed

    e.g. If there are three possible tabs (A, B and C), but there are no results for items under
    tab C, this function will ensure that the C facet is re-injected with the count of 0
  */
  private static void populateEmptyFacetsGScope(def response, List<Integer> rmcs)
  {
    if (response != null)
    {
      // Normally, facets with the value of 0 is not present
      // The following re-inject the facets back
      rmcs.each()
      {
        gscopeValue ->

        if(response.resultPacket.gScopeCounts[gscopeValue] == null)
        {
          response.resultPacket.gScopeCounts[gscopeValue] = 0;
        }
      }
    }
  }

  /*
    Reads the collection.cfg settings from @question in order to
    find out the gscope rmcs which needs to always appear.

    It is expected that the configuration are in the following format:
    stencils.tabs.full_facet.metadata.<metadata class>.1=<value>
    stencils.tabs.full_facet.metadata.<metadata class>.2=<value>

    e.g.
      stencils.tabs.full_facet.metadata.tabs.1=web
      stencils.tabs.full_facet.metadata.tabs.2=courses
  */
  private static Map getConfigFullFacetMetadata(def question)
  {
    Map output = [:];

    question.collection.configuration.valueKeys().each()
    {
      configKey ->

      if(configKey.startsWith(METADATA_CONFIG))
      {
        // Remove the config name and the following collection config separator
        String processedConfig = configKey.replace(METADATA_CONFIG + COLLECTION_CONFIG_SEPARATOR, "");

        // Get the index of the collection config separator
        int collectionConfigSeperatorIndex = processedConfig.indexOf(COLLECTION_CONFIG_SEPARATOR);

        if(collectionConfigSeperatorIndex > 0)
        {
          // Obtain the metadata class of the facet we want to check on
          // i.e. We only want the <metadata class> from <metadata class>.1
          String metadataClass = processedConfig.substring(0, collectionConfigSeperatorIndex);

          // Get the corresponding value of the metadata class
          String value =  question.collection.configuration.value(configKey);

          // Ensure that an list exists for all specified metadata class
          if(output[metadataClass] == null)
          {
            output[metadataClass] = [];
          }

          // Add the metadata class and value to the Map container
          output[metadataClass].push(value);
        }
      }
    }

    return output;
  }

  /*
    Ensures that facets based off metadata in the @rmcs list are always displayed

    e.g. If there are three possible tabs (A, B and C), but there are no results for items under
    tab C, this function will ensure that the C facet is re-injected with the count of 0
  */
  private static void populateEmptyFacetsMetadata(def response, Map rmcs)
  {
    if (response != null)
    {
      // Normally, facets with the value of 0 is not present
      // The following re-inject the facets back
      rmcs.each()
      {
        currentMetaDataClass, value ->

        value.each()
        {
          currentFacetValue ->

          if (response.resultPacket.rmcs["${currentMetaDataClass}:${currentFacetValue}"] == null)
          {
            response.resultPacket.rmcs["${currentMetaDataClass}:${currentFacetValue}"] = 0;
          }
        }
      }
    }
  }


}
