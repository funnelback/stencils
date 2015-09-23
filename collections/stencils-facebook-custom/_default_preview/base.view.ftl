<#ftl encoding="utf-8" />
<#--
   Stencil: Base
   By: Gioan Tran
   Description: <Description>
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#-- Import the main macros used to put together this app -->
<#import "/web/templates/modernui/stencils-libraries/base.controller.ftl" as base_controller/>

<#--
  Sample implementation of a facet breadcrumb which allows users
  to remove active facets
-->
<#macro BreadCrumb>
  <@base_controller.BreadCrumbSearch>
    <div class="js-refinements refinements">
      Refined by 
      <@base_controller.BreadCrumbs>
          <@base_controller.BreadCrumb tag="span" class="">
            <a href="<@base_controller.BreadCrumbUrl />">
              <button type="button" class="btn btn-default">
                <span class="glyphicon glyphicon-remove"></span> 
                <@base_controller.BreadCrumbName />
              </button>
            </a>
          </@base_controller.BreadCrumb>  
      </@base_controller.BreadCrumbs>
    </div>
  </@base_controller.BreadCrumbSearch>
</#macro>

</#escape>