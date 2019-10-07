/**
 * This file is used to tell Gradle to ignore any @Grab annotations inside the groovy scripts during build.
 * 
 * This is unfortunately necessary, the JUnit tests fail to compile when importing the dependencies
 * with @Grab (from Grapes via the Ivy library).
 * https://stackoverflow.com/a/4810624/11261138
 * 
 * When the @Grab annotations are ignored, any library that was grabbed in the filter has to be put into the
 * Gradle dependencies as well (the dependency has to be defined twice). See the build.gradle file for this
 * explanation.
 */

withConfig(configuration) {
  configuration.setDisabledGlobalASTTransformations(['groovy.grape.GrabAnnotationTransformation'] as Set)
}