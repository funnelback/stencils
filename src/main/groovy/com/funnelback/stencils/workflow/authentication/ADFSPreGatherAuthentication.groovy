import com.funnelback.common.config.CollectionId
import com.funnelback.common.config.Config
import com.funnelback.common.config.NoOptionsConfig
import com.funnelback.http.cookies.SimpleCookieJar
import com.funnelback.http.forminteraction.FormInteractionConfigParsing
import com.funnelback.http.forminteraction.InCrawlFormInteractionInterceptor
import com.funnelback.http.forminteraction.RefreshablePreCrawlFormInteractionInterceptor
import okhttp3.Cookie
import okhttp3.HttpUrl
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import org.junit.Assert

import java.nio.charset.StandardCharsets

/**
 * ADFS Pre Gather Authentication
 *
 * Script to authenticate the crawler with a username and password
 * through a Microsoft Active Directory Federation Services login form.
 *
 * In collection.cfg, configure:
 * stencils.workflow.crawler.adfs.username
 * stencils.workflow.crawler.adfs.password
 * stencils.workflow.crawler.adfs.cookie_domain
 * stencils.workflow.crawler.adfs.start_url
 * stencils.workflow.crawler.adfs.post_response_page
 *
 * See the Stencils README for further details.
 */

if (args.length < 2) {
    println 'Error: $SEARCH_HOME and $COLLECTION_NAME are required arguments.'
    return 1
}

def searchHome = new File(args[0])
def collectionName = args[1]

// Create an object that can access the collection configuration
Config config = new NoOptionsConfig(searchHome, collectionName)

// username and password the crawler will use to authenticate
String USERNAME = config.value('stencils.workflow.crawler.adfs.username', null)
String PASSWORD = config.value('stencils.workflow.crawler.adfs.password', null)
// domain that the crawler requires the cookie for, i.e. secure.client.com
String COOKIE_DOMAIN = config.value('stencils.workflow.crawler.adfs.cookie_domain', null)
// start URL that redirects to the login form, this is also where the crawl typically begins
// optional if start_url is configured
String START_URL = config.value('stencils.workflow.crawler.adfs.start_url',
    config.value('start_url', null))
// SAML post response page
// Typically not viewable in a browser, a POST is sent to this page with Javascript after
// the POST from the username/password login form.
// Usually in the form of "https://secure.client.com/saml/postResponse"
// The port number may be required, i.e. "https://secure.client.com:443/saml/postResponse"
String POST_RESPONSE_PAGE = config.value('stencils.workflow.crawler.adfs.post_response_page', null)

// Set up a PrintStream to write to the cookies.txt file
def cookiesTxt = new File(searchHome, "conf${File.separator}${collectionName}${File.separator}cookies.txt")
PrintStream outputStream = new PrintStream(cookiesTxt, StandardCharsets.UTF_8)

// Set up the HTTP client
OkHttpClient.Builder builder = new OkHttpClient.Builder()
SimpleCookieJar cookieJar = new SimpleCookieJar()
builder.cookieJar(cookieJar)

// Add a pre-crawl form interaction step for the login form with the username/password
Set<FormInteractionConfigParsing.FormInteractionStep> configuredPreCrawlInteractions = new HashSet<>()
configuredPreCrawlInteractions.add(
    new FormInteractionConfigParsing.FormInteractionStep(
        START_URL,
        1,
        "parameters:[UserName=${URLEncoder.encode(USERNAME, "UTF-8")}&password=${URLEncoder.encode(PASSWORD, "UTF-8")}]"
    )
)

// Add an in-crawl form interaction step for the SAML POST response form that browsers send a POST by clicking the form
// with Javascript.
Set<FormInteractionConfigParsing.FormInteractionStep> configuredInCrawlInteractions = new HashSet<>()
configuredInCrawlInteractions.add(
    new FormInteractionConfigParsing.FormInteractionStep(
        POST_RESPONSE_PAGE,
        1,
        "parameters:[]"
    )
)

builder.interceptors()
    .add(new InCrawlFormInteractionInterceptor(configuredInCrawlInteractions, Set.of(),
        Long.MAX_VALUE, true, Optional.of(new CollectionId("testCollectionId"))))

builder.interceptors().add(new RefreshablePreCrawlFormInteractionInterceptor(configuredPreCrawlInteractions, 60 * 1000l, Optional.empty()))

// OkHttpTestUtils.tweakOkHttpClientBuilderForDebugging(builder)

OkHttpClient client = builder.build()

// This page is inaccessible unless the login process above is used
Request request = new Request.Builder().url(START_URL).build()

Response response = null
try {
    // Send the HTTP request
    response = client.newCall(request).execute()
    Assert.assertTrue(response.isSuccessful())

    List<Cookie> cookies = cookieJar.loadForRequest(HttpUrl.parse(START_URL))

    // Write the cookies assigned by the server to the cookies.txt configuration file
    for (Cookie cookie : cookies) {
        outputStream.println("${COOKIE_DOMAIN}\t" +
            "TRUE\t" +
            cookie.path() + "\t" +
            Boolean.toString(cookie.secure()).toUpperCase() + "\t" +
            cookie.expiresAt() + "\t" +
            cookie.name() + "\t" +
            cookie.value());
    }
} finally {
    // Regardless of the outcome, close the request when finished
    if (response != null) {
        response.close()
    }
}

outputStream.close()
