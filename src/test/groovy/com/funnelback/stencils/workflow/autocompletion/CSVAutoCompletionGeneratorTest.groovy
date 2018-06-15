package com.funnelback.stencils.workflow.autocompletion

import org.junit.Assert
import org.junit.Test

class CSVAutoCompletionGeneratorTest {

    static final File TEST_SEARCH_HOME = new File("src/test/resources/csv-auto-completion-generator")

    @Test
    void testGetCSVFile() {
        def generator = new CSVAutoCompletionGenerator(TEST_SEARCH_HOME)

        Assert.assertEquals(
                "src/test/resources/csv-auto-completion-generator/conf/coll/prof/auto-completion.csv",
                generator.getCSVFile("coll", "prof").path)
    }

    @Test
    void testGetURL() {
        def generator = new CSVAutoCompletionGenerator(TEST_SEARCH_HOME)

        Assert.assertEquals(
                "http://localhost:12345/s/search.html?collection=coll&profile=prof&view=view&form=auto-completion&query=a+query&start_rank=12&num_ranks=34",
                generator.getURL("coll", "prof", "view", 12, 34, "a query").toExternalForm())
    }

}
