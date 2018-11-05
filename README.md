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

:information_source: If you are on Funnelback hosting, the Stencils are pre-installed and no installation steps are necessary.

* Clone this repository inside `$SEARCH_HOME/share/stencils/`
* Create a symbolic link for the Groovy libraries:

```
# Linux
ln -s $SEARCH_HOME/share/stencils/src/main/groovy/com/funnelback/stencils $SEARCH_HOME/lib/java/groovy/com/funnelback/stencils

# Windows
mklink %SEARCH_HOME%\share\stencils\src\main\groovy\com\funnelback\stencils %SEARCH_HOME%\lib\java\groovy\com\funnelback\stencils
```

* Create a symbolic link for the static resources Jetty context:

```
# Linux
ln -s $SEARCH_HOME/share/stencils/src/main/resources/funnelback-stencils-resources.xml $SEARCH_HOME/web/conf/contexts-admin/funnelback-stencils-resources.xml
ln -s $SEARCH_HOME/share/stencils/src/main/resources/funnelback-stencils-resources.xml $SEARCH_HOME/web/conf/contexts-public/funnelback-stencils-resources.xml

# Windows
mklink %SEARCH_HOME%\share\stencils\src\main\resources\funnelback-stencils-resources.xml %SEARCH_HOME%\web\conf\contexts-admin\funnelback-stencils-resources.xml
mklink %SEARCH_HOME%\share\stencils\src\main\resources\funnelback-stencils-resources.xml %SEARCH_HOME%\web\conf\contexts-public\funnelback-stencils-resources.xml
```

To make use of the hook scripts, filters and workflow scripts in collections, please see the [documentation](src/README.md).

## Building & Development

Run `gradlew` (Linux/Mac) or `gradlew.bat` (Windows). This will download Gradle if necessary, then compile the Groovy sources and run the unit tests.

This is only needed if you want to develop the Stencils themselves. If you just want to use them, you don't need this (Just follow the installation instructions above).

## Compatibility

Development takes place on the `master` branch, which always points to the latest Funnelback version supported. Changes are then merged to per-version staging branches (e.g. `staging/15.8+`), and finally to the per-version production branches (e.g. `production/15.8+`) when ready. The version branches may be compatible with multiple Funnelback version (e.g. `15.8+` works with 15.8 and 15.10, and `15.12+` must be used for 15.12 and above).

Changes may be backported to multiple version branches depending if the fix applies to multiple Funnelback versions.

 Stencil branch  | Funnelback version(s)
 --------------- | ---------------------
 14.2+           | 14.2 - 15.0
 15.0+           | 15.0 - 15.6
 15.8+           | 15.8, 15.10 (:warning: requires patch levels 15.8.0.17 / 15.10.0.7 or above)
 15.12+          | 15.12 and above

New version branches are created when a feature is incompatible with older Funnelback versions. For example the 15.8 Stencil branch was created as the code base started making use of features not available in 15.6.

## GitHub public mirror

The Stencils are made publicly available on the Funnelback GitHub account. Every change made to a staging or production branch is synchronized with GitHub, via the GitLab CI configuration.

As a consequence Stencils should avoid pointing to / using internal resources not available to external users (Clients, Partners).

## Related Links

For more information regarding using stencils please refer to Stencils Confluence space (restricted to Funnelback internal users).
