/**
 * Funnelback Custom Gather SFTP
 *
 * Retrieves a file from a remote SFTP server and stores/indexes that file.
 * Commonly used to retrieve JSON or XML documents.
 * See README for more details.
 */

@Grab(group='com.jcraft', module='jsch', version='0.1.55')


// Funnelback Imports
import com.funnelback.common.io.store.XmlRecord
import com.funnelback.common.io.store.bytes.RawBytesStoreFactory
import com.funnelback.common.utils.XMLUtils
import com.funnelback.common.config.NoOptionsConfig
import com.funnelback.common.config.Config

// Data Structure for metadata
import com.google.common.collect.ArrayListMultimap

// SSH Library
import com.jcraft.jsch.JSch
import com.jcraft.jsch.ChannelSftp

if (args.length < 2) {
    println 'Usage: custom_gather.groovy $SEARCH_HOME $COLLECTION_NAME'
    return 1
}

def searchHome = new File(args[0])
def collectionName = args[1]

Config config =  new NoOptionsConfig(searchHome, collectionName)

// Validate required fields are in collection configuration
def HOSTNAME_CONFIG = 'sftp.gather.hostname'
def USERNAME_CONFIG = 'sftp.gather.username'
def PASSWORD_CONFIG = 'sftp.gather.password'
def FILE_CONFIG = 'sftp.gather.file'
def USE_STORE_CONFIG = 'sftp.gather.use_store'
def STORED_URL_CONFIG = 'sftp.gather.stored_url'

def mandatoryConfigurations = [HOSTNAME_CONFIG, USERNAME_CONFIG, PASSWORD_CONFIG, FILE_CONFIG]
mandatoryConfigurations.each { configKey ->
    if (!config.value(configKey)) {
        throw new RuntimeException("${configKey} value must be set in the collection configuration. Exiting...")
    }
}

// Retrieve the file from the SFTP endpoint and store it in a temporary file
def jsch = new JSch()

def outFile = new File(searchHome, "data/${collectionName}/offline/data/data.xml")

// Set up the SSH connection
def session = jsch.getSession(config.value(USERNAME_CONFIG), config.value(HOSTNAME_CONFIG))
session.password = config.value(PASSWORD_CONFIG)
session.setConfig("StrictHostKeyChecking", "no") // Avoid having to add the public key to ~/.known_hosts
session.connect()

// Retrieve the file via SFTP
def sftp = (ChannelSftp) session.openChannel("sftp")
sftp.connect()
sftp.get(config.value(FILE_CONFIG), outFile.absolutePath)
sftp.exit()

session.disconnect()

println ""
println "Downloaded ${outFile.length()} bytes from ${config.value(HOSTNAME_CONFIG)} to ${outFile.absolutePath}"
println ""

// The default behavior is to use the store, a config setting must be used to override this default
if (!(config.value(USE_STORE_CONFIG) == 'false')) {
    // Create a Store instance to store gathered data
    def store = new RawBytesStoreFactory(config)
        .withFilteringEnabled(true)
        .newStore()
        .asXmlStore()

    store.open()

    def metadata = ArrayListMultimap.create()
    // Set the Content-Type for XML
    metadata.put("Content-Type", "text/xml")

    // Create a Document instance from the downloaded file
    def xmlContent = XMLUtils.fromFile(outFile)
    def storedUrl = config.value(STORED_URL_CONFIG) ?: "${collectionName}/datafile"
    def record = new XmlRecord(xmlContent, storedUrl)
    store.add(record, metadata)

    // Delete the raw XML file because it's now in the store
    outFile.delete()

    // Close the store to end the gather process
    store.close()
}
