# Stencils libraries

This folder contains FTL libraries for common functionalities.

These libraries should be *copied in* the collections, rather than imported
so that future Stencils upgrades won't break collections.

## Configuration Settings

Some templates can be configured using settings in the collection.cfg. These templates and their configuration settings can be found here:

* [Base Templates](base/)
* [Tabs](tabs/)
* [Autocompletion](autocompletion/)

## v1 Libraries

:warning: This folder contains a lot of libraries for the v1 of the Stencils which are
deprecated. Any files under "views" or "controllers" is part of the v1 Stencils and can
be ignored. They are kept for backwards compatibility with implementations using the
v1 Stencils.