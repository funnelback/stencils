package com.funnelback.stencils.filter.metadata

import com.funnelback.filter.api.FilterContext
import com.funnelback.filter.api.FilterResult
import com.funnelback.filter.api.documents.NoContentDocument
import com.funnelback.filter.api.documents.BytesDocument
import com.funnelback.filter.api.filters.PreFilterCheck
import com.funnelback.filter.api.filters.BytesDocumentFilter
import org.apache.commons.io.FileUtils

/**
 * ExtractContentLength
 *
 * The Funnelback indexer converts the Content-Length HTTP header
 * to an internal field for filesize, however that field is only
 * 24-bit which means that any crawled documents larger than
 * 16.7 MB have an incorrect file size.
 *
 * This filter extracts the Content-Length into a custom metadata
 * field to store as a String which prevents integer overflow. A
 * formatted version of the filesize is also stored which represents
 * the document size in a human-readable format.
 *
 * The "custom-content-length" and "custom-content-length-formatted"
 * metadata sources injected by this filter must still be mapped to
 * metadata classes in the Funnelback Admin Interface.
 */

class ExtractContentLength implements BytesDocumentFilter {

    @Override
    PreFilterCheck canFilter(NoContentDocument noContentDocument, FilterContext filterContext) {
        return PreFilterCheck.ATTEMPT_FILTER
    }

    @Override
    FilterResult filterAsBytesDocument(BytesDocument document, FilterContext context) {
        def metadata = document.getCopyOfMetadata()
        if (metadata.get('Content-Length')) {
            def contentLength = metadata.get('Content-Length').get(0)
            def contentLengthFormatted = FileUtils.byteCountToDisplaySize(Long.parseLong(contentLength))
            metadata.put('custom-content-length', contentLength)
            metadata.put('custom-content-length-formatted', contentLengthFormatted)
        }
        return FilterResult.of(document.cloneWithMetadata(metadata))
    }
}
