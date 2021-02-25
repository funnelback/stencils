/**
 * Funnelback Custom Gather SFTP
 *
 * Retrieves a file from a remote SFTP server and stores/indexes that file.
 * Commonly used to retrieve JSON or XML documents.
 * See README for more details.
 */


import com.funnelback.common.io.store.RawBytesRecord
import com.funnelback.common.io.store.RawBytesStore
@Grab(group='com.jcraft', module='jsch', version='0.1.55')


// Funnelback Imports
import com.funnelback.common.io.store.XmlRecord
import com.funnelback.common.io.store.bytes.RawBytesStoreFactory
import com.funnelback.common.utils.XMLUtils
import com.funnelback.common.config.NoOptionsConfig
import com.funnelback.common.config.Config
import com.funnelback.socialmedia.utils.ConfigFactory

// Data Structure for metadata
import com.google.common.collect.ArrayListMultimap

// SSH Library
import com.jcraft.jsch.JSch
import com.jcraft.jsch.ChannelSftp
import com.jcraft.jsch.Session

class SFTPCustomGather {
    Config config
    def store
    List<Map<String, ?>> CONFIG_KEYS = [
        [
            varName: 'HOSTNAME',
            key: 'stencils.gather.sftp.hostname',
            mandatory: true
        ],
        [
            varName: 'USERNAME',
            key: 'stencils.gather.sftp.username',
            mandatory: true
        ],
        [
            varName: 'PASSWORD',
            key: 'stencils.gather.sftp.password',
            mandatory: true
        ],
        [
            varName: 'FILE',
            key: 'stencils.gather.sftp.file',
            mandatory: true
        ],
        [
            varName: 'MIME_TYPE',
            key: 'stencils.gather.sftp.mime_type',
            mandatory: true
        ],
        [
            varName: 'STORED_URL',
            key: 'stencils.gather.sftp.stored_url',
            mandatory: false
        ],
    ]
    Map<String, String> configValues
    boolean isXmlMime
    String collectionName

    /**
     * Initialize the SFTPCustomGather class variables
     * @param searchHome
     * @param collection
     * @return instance of SFTPCustomGather to be called in a chain
     */
    SFTPCustomGather init(File searchHome, String collection) {
        collectionName = collection
        config = ConfigFactory.createNoOptionsConfigWithLogging(searchHome, collection)
        configValues = [:]

        CONFIG_KEYS.each {
            def value = config.value(it['key'] as String)
            if (it.mandatory && !value) {
                throw new RuntimeException("${it['key']} is a mandatory configuration.")
            }
            configValues.put(it['varName'] as String, value)
        }

        store = new RawBytesStoreFactory(config).withFilteringEnabled(true).newStore()

        if (configValues['MIME_TYPE'] == 'text/xml' || 'application/xml') {
            isXmlMime = true
            store = store.asXmlStore()
        }

        return this
    }

    void gather() {
        putIntoStore(getInputStream())
    }

    /**
     * Downlaod the file from the SFTP endpoint and return the InputStream of the content
     */
    InputStream getInputStream() {
        // Set up the SSH connection
        def jsch = new JSch()
        Session session
        ChannelSftp sftp
        InputStream inputStream = null
        try {
            session = jsch.getSession(configValues['USERNAME'], configValues['HOSTNAME'])
            session.password = configValues['PASSWORD']
            session.setConfig("StrictHostKeyChecking", "no") // Avoid having to add the public key to ~/.known_hosts
            session.connect()

            // Retrieve the file via SFTP
            config.setProgressMessage("Downloading ${configValues['FILE']} from remote SFTP server")
            sftp = (ChannelSftp) session.openChannel("sftp")
            sftp.connect()
            inputStream = sftp.get(configValues['FILE'])
        } catch (error) {
            throw new RuntimeException("Error downloading ${configValues['FILE']} from ${configValues['HOSTNAME']}. Stack trace: ${error.toString()}")
        } finally {
            if (sftp) sftp.exit()
            if (session) session.disconnect()
        }

        return inputStream
    }

    /**
     * Adds the gathered input into the record store
     */
    void putIntoStore(InputStream inputStream) {
        store.open()
        try {
            def metadata = ArrayListMultimap.create()
            // Set the Content-Type
            metadata.put("Content-Type", configValues['MIME_TYPE'])

            def storedUrl = configValues['STORED_URL'] ?: "${collectionName}/datafile"

            byte[] bytes = inputStream.readAllBytes()

            if (isXmlMime) {
                // Create a Document instance from the downloaded file
                def xmlContent = XMLUtils.fromBytes(bytes)
                def record = new XmlRecord(xmlContent, storedUrl)
                store.add(record, metadata)
            } else {
                // Create a Record from the downloaded bytes
                def record = new RawBytesRecord(bytes, storedUrl)
                store.add(record, metadata)
            }
        } finally {
            // Close the store to end the gather process
            store.close()
        }
    }

    // main method is run when the custom gather is started
    static void main(String[] args) {
        File searchHome = new File(args[0])
        String collection = args[1]
        new SFTPCustomGather()
            .init(searchHome, collection)
            .gather()
    }

}
