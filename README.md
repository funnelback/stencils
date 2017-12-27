# Stencils

Welcome to the shared Stencils repository. This holds the shared components used by all the Stencils (Groovy hook scripts, templates, etc.)

## Structure

Stencils are built with [Gradle](https://gradle.org/). For this reason, the main Groovy sources are under the `src/` folder, with `main` containing the code and `test` the unit tests. The folder structure is:

 Name                    | Purpose 
 ----------------------- | -------
 [src/](src)             | Groovy libraries (used in Filters or Public UI Hook Scripts). See [documentation](src/README.md).
 [libraries/](libraries) | Stencils FreeMarker files. 
 [resources/](resources) | External files such as JavaScript and CSS. 

## Installation

* Clone this repository inside `$SEARCH_HOME/share/stencils`
* Create a symbolic link for the Groovy libraries:

```
ln -s $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils $SEARCH_HOME/lib/java/groovy/com/funnelback/stencils
```

* Create a symbolic link for the static resources Jetty context:

```
ln -s $SEARCH_HOME/share/stencils/src/main/resources/funnelback-stencils-resources.xml $SEARCH_HOME/web/conf/contexts-admin/funnelback-stencils-resources.xml
ln -s $SEARCH_HOME/share/stencils/src/main/resources/funnelback-stencils-resources.xml $SEARCH_HOME/web/conf/contexts-public/funnelback-stencils-resources.xml
```

To make use of the hook scripts, filters and workflow scripts in collections, please see the [documentation](src/README.md).

## Building

Run `gradlew` (Linux/Mac) or `gradlew.bat` (Windows). This will download Gradle if necessary, then compile the Groovy sources and run the unit tests.

## Compatibility

Development takes place on the `master` branch, which always points to the latest Funnelback version supported. Changes are then merged to per-version staging branches (e.g. `15.8-staging`), and finally to the per-version production branches (e.g. `15.8-production`) when ready.

Changes may be backported to multiple version branches depending if the fix applies to multiple Funnelback versions.

 Stencil branch  | Funnelback version(s)
 --------------- | ---------------------
 14.2            | 14.2 - 15.0
 15.0            | 15.0 - 15.6
 15.8            | 15.8, 15.10 (:warning: requires patch levels 15.8.0.17 / 15.10.0.7 or above)
 15.12           | 15.12+


New version branches are created when a feature is incompatible with older Funnelback versions. For example the 15.8 Stencil branch was created as the codebase started making use of features not available in 15.6.

## Related Links

For more information regarding using stencils please refer to [Stencils confluence space] (https://confluence.cbr.au.funnelback.com/display/STEN/Stencils)
