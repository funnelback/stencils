package com.funnelback.stencils.filter.metadata

import com.funnelback.filter.api.DocumentType
import com.funnelback.filter.api.documents.BytesDocument
import com.funnelback.filter.api.mock.MockDocuments
import com.funnelback.filter.api.mock.MockFilterContext
import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import java.nio.charset.StandardCharsets

@RunWith(Parameterized.class)
class ExtractContentLengthTest {

    String expectedContentLength
    String expectedContentLengthFormatted

    ExtractContentLengthTest(String contentLength, String contentLengthFormatted) {
        this.expectedContentLength = contentLength
        this.expectedContentLengthFormatted = contentLengthFormatted
    }

    @Parameterized.Parameters
    static Collection<Object[]> data() {
        return [
            ['33779695', '32 MB'],
            ['1024', '1 KB'],
            ['1234567890', '1 GB'],
        ]
            .collect() { it as Object[] }
    }

    @Test
    void test() {
        def emptyDocument = MockDocuments.mockEmptyByteDoc()
        def metadata = emptyDocument.copyOfMetadata
        metadata.put('Content-Length', expectedContentLength)
        def mockDocument = MockDocuments.mockEmptyByteDoc()
            .cloneWithURI(new URI("https://www.example.org"))
            .cloneWithContent(
                DocumentType.MIME_XML_TEXT,
                Optional.of(StandardCharsets.UTF_8),
                '123'.bytes)
            .cloneWithMetadata(metadata)

        def context = MockFilterContext.emptyContext

        def filterResult = new ExtractContentLength().filterAsBytesDocument(mockDocument, context)
        def filterResultDocument = (BytesDocument) filterResult.filteredDocuments.first()


        Assert.assertEquals("custom-content-length should be $expectedContentLength",
            expectedContentLength, filterResultDocument.metadata.get('custom-content-length').first())
        Assert.assertEquals("custom-content-length-formatted should be $expectedContentLengthFormatted",
            expectedContentLengthFormatted, filterResultDocument.metadata.get('custom-content-length-formatted').first())
    }
}
