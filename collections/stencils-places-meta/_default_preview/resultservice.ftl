<#ftl encoding="utf-8" />
<#--
   Stencil: Result List service
   By: Gioan Tran
   Description: A sample stencil which simply provides the basic out of the box functionality derived
    from the simple.ftl that is shipped with the product.
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Stencils which are to be included -->
<#assign stencils = ["core", "base", "places"] />

<#-- Include Project files -->
<#import "project.view.ftl" as project_view />
<#import "project.controller.ftl" as project_controller />

<#-- 
  The following code imports and assigns stencil namespaces automatically eg. core_view and core_controller.
  The code expects that the controller files are located under $SEARCH_HOME/web/templates/modernui/stencils-libraries/
  and the view files located under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/

  Note: The full path has been added to ensure that the correct folder is being picked up  
-->
<#list stencils as stencil>
  <#assign controller = "/web/templates/modernui/stencils-libraries/${stencil}.controller.ftl" stencilNamespaceController="${stencil?lower_case}_controller" />
  <#assign view ="/conf/${question.collection.id}/${question.profile}/${stencil}.view.ftl" stencilNamespaceView="${stencil?lower_case}_view" />  
  <@'<#import controller as ${stencilNamespaceController}>'?interpret />
  <@'<#import view as ${stencilNamespaceView}>'?interpret />
</#list>

<#-- 
  If for any reason you need to modify a controller (not recommended as it will no longer be upgraded as part of the stencils release cycle), you can remove the stencil from the stencils array, take a copy of the controller and move it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/. You will then need to import it using the following:

  <#import "<stencil name>.controller.ftl" as <stencil name>_controller>
  <#import "<stencil name>.view.ftl" as <stencil name>_view>

  e.g. If you are using the core and base stencil but you want to override the base.controller.ftl

  You will need to:
  - Copy base.controller.ftl from  $SEARCH_HOME/web/templates/modernui/stencils-libraries/ and store it under $SEARCH_HOME/conf/$COLLECTION_NAME/<profile>/
  - Change 'stencils = ["core", "base"]' to 'stencils = ["core"]'
  - Add '<#import "base.controller.ftl" as base_controller>' to the top of your file
  - Add '<#import "base.view.ftl" as base_view>' to the top of your file
--> 

              <@base_view.BreadCrumb />
              <@core_controller.Count />
              <@core_view.Results/>
              <@core_controller.QueryHistory />
              <@core_controller.SearchHistory />
              <@core_controller.Scope />
              <@core_controller.Blending />
              <@core_controller.CuratorExhibits />
              <@core_controller.Spelling />
              <@core_controller.NoResultSummary />
              <@core_controller.EntityDefinition />            
              <@core_controller.CuratorExhibitsList />
              <@core_controller.BestBets />
              <@core_controller.Pagination />
              <@core_controller.ContextualNavigation />
              <@core_controller.Cart />
              <@core_controller.Tools />
            

</#escape>