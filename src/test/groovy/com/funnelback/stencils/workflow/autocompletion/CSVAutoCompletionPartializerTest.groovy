package com.funnelback.stencils.workflow.autocompletion

import org.junit.Assert
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

@RunWith(Parameterized.class)
class CSVAutoCompletionPartializerTest {

    static final TEST_DATA = new File("src/test/resources/csv-auto-completion-partializer")

    private String testFile
    private String stopWordsFile

    CSVAutoCompletionPartializerTest(String testFile, String stopWordsFile) {
        this.testFile = testFile
        this.stopWordsFile = stopWordsFile
    }

    @Parameterized.Parameters
    static Collection<Object[]> data() {
        return [
                ["test1.csv", null],
                ["test2.csv", "stopwords"]
        ]
                .collect() { it as Object[] }
    }

    @Test
    void test() {
        def input = new File(TEST_DATA, testFile)

        def output = File.createTempFile(CSVAutoCompletionPartializerTest.class.getName(), ".csv")
        output.deleteOnExit()

        new CSVAutoCompletionsPartializer()
                .partialize(
                Optional.ofNullable(stopWordsFile ? new File(TEST_DATA, stopWordsFile) : null),
                input,
                output)

        Assert.assertEquals(
                new File(TEST_DATA, "${testFile}.expected").readLines(),
                output.readLines()
        )
    }
}
