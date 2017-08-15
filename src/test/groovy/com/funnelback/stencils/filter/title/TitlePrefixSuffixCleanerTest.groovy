package com.funnelback.stencils.filter.title

import com.funnelback.common.filter.jsoup.FilterContext
import com.funnelback.common.filter.jsoup.SetupContext
import org.jsoup.nodes.Document
import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

class TitlePrefixSuffixCleanerTest {

    def setupContext
    def filterContext
    def document

    @Before
    void before() {
        setupContext = Mockito.mock(SetupContext.class)
        filterContext = Mockito.mock(FilterContext.class)
        document = Mockito.mock(Document.class)

        Mockito.when(filterContext.document).thenReturn(document)
    }

    @Test
    void testPrefix() {
        Mockito.when(setupContext.getConfigSetting(TitlePrefixSuffixCleaner.CONFIG_KEY_NAMESPACE + ".strip-prefix"))
            .thenReturn("A prefix \\| ")

        def filter = new TitlePrefixSuffixCleaner()
        filter.setup(setupContext)

        Mockito.when(document.title()).thenReturn("A prefix | Title")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Title")

        Mockito.reset(document)
        Mockito.when(document.title()).thenReturn("Not the right prefix | Title")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Not the right prefix | Title")
    }

    @Test
    void testSuffix() {
        Mockito.when(setupContext.getConfigSetting(TitlePrefixSuffixCleaner.CONFIG_KEY_NAMESPACE + ".strip-suffix"))
                .thenReturn("\\s+\\|\\s+A suffix")

        def filter = new TitlePrefixSuffixCleaner()
        filter.setup(setupContext)

        Mockito.when(document.title()).thenReturn("Title  |    A suffix")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Title")

        Mockito.reset(document)
        Mockito.when(document.title()).thenReturn("Title | Not the right suffix")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Title | Not the right suffix")
    }

    @Test
    void testPrefixAndSuffix() {
        Mockito.when(setupContext.getConfigSetting(TitlePrefixSuffixCleaner.CONFIG_KEY_NAMESPACE + ".strip-prefix"))
                .thenReturn("A prefix ")
        Mockito.when(setupContext.getConfigSetting(TitlePrefixSuffixCleaner.CONFIG_KEY_NAMESPACE + ".strip-suffix"))
                .thenReturn(" A suffix")

        def filter = new TitlePrefixSuffixCleaner()
        filter.setup(setupContext)

        Mockito.when(document.title()).thenReturn("A prefix Title A suffix")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Title")

        Mockito.reset(document)
        Mockito.when(document.title()).thenReturn("Title without prefix or suffix")
        filter.processDocument(filterContext)
        Mockito.verify(document).title("Title without prefix or suffix")
    }

    @Test
    void testNotConfigured() {
        def filter = new TitlePrefixSuffixCleaner()
        filter.setup(setupContext)

        Mockito.when(document.title()).thenReturn("Document Title")
        filter.processDocument(filterContext)
        Mockito.verify(document, Mockito.never()).title(Mockito.any())
    }

}
