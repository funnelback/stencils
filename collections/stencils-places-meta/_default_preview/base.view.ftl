<#ftl encoding="utf-8" />
<#--
  Stencil: Base
  By: Gioan Tran
  Description: Views common to most search apps.
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
<#import "/share/stencils/libraries/base.controller.ftl" as base_controller/>

<#--
  Sample implementation of a facet breadcrumb which allows users
  to remove active facets
-->
<#macro BreadCrumb>
  <@base_controller.BreadCrumbSearch>
  <div style="margin-bottom:0.5em">
    <div class="js-refinements refinements">
     <small>Refined by</small><br>
      <@base_controller.BreadCrumbs>
          <@base_controller.BreadCrumb tag="span" >

            <a href="<@base_controller.BreadCrumbUrl />" class="label label-default" style="margin-right:0.1em">
                <i class="fa fa-times" style="color:#fff;"></i>
                <@base_controller.BreadCrumbName />
            </a>
          </@base_controller.BreadCrumb>
      </@base_controller.BreadCrumbs>
    </div>
  </div>
  </@base_controller.BreadCrumbSearch>
</#macro>


<#--
  ResultsDisplaySelectbox
  @author Robert Prib
  @desc Creates a select box that allows the user to select between different search results layouts
 -->
<#macro ResultsDisplaySelectbox>
<div class="btn-group">
  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
    View &nbsp;&nbsp; <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li class="<#compress><@base_controller.IfDefCGIEquals name="display" value="list" trueIfEmpty=true>active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["display=list","num_ranks=10","groupSize=1"] />">
        <span class="glyphicon glyphicon-th-list"></span> List
      </a>
    </li>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="display" value="grid" >active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["display=grid","num_ranks=12","groupSize=2"] />">
        <span class="glyphicon glyphicon-th"></span> Grid
      </a>
    </li>

  </ul>
</div>
</#macro>

<#--
  ResultsPerPageSelectbox
  @author Robert Prib
  @desc Creates a select box that allows the user to select between set number of results per page.
 -->
<#macro ResultsPerPageSelectbox>
  <!-- Split button -->
<div class="btn-group">
  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
    Limit &nbsp;&nbsp; <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">

    <#-- Result limit options for List view results -->
    <@base_controller.IfDefCGIEquals name="display" value="list"  trueIfEmpty=true>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="10" trueIfEmpty=true>active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=10"] />">
        <span class="glyphicon glyphicon-th-list"></span> 10
      </a>
    </li>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="50">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=50"] />">
        <span class="glyphicon glyphicon-th-list"></span> 50
      </a>
    </li>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="100">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=100"] />">
        <span class="glyphicon glyphicon-th-list"></span> 100
      </a>
    </li>
    </@base_controller.IfDefCGIEquals>

    <#-- Result limit options for Grid or Masonry view results -->
    <@base_controller.IfDefCGIEquals name="display" value="(grid|masonry)" >
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="12" trueIfEmpty=true>active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=12"] />">
        <span class="glyphicon glyphicon-th-list"></span> 12
      </a>
    </li>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="60">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=60"] />">
        <span class="glyphicon glyphicon-th-list"></span> 60
      </a>
    </li>
    <li class="<#compress><@base_controller.IfDefCGIEquals name="num_ranks" value="120">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["num_ranks=120"] />">
        <span class="glyphicon glyphicon-th-list"></span> 120
      </a>
    </li>
    </@base_controller.IfDefCGIEquals>
  </ul>
</div>
</#macro>

<#--
  ResultsGroupPerSelectbox

  @author Robert Prib
  @desc Creates a select box that allows the user to select to group results by numeric amount per row.
 -->
<#macro ResultsGroupPerSelectbox>

<div class="btn-group">
  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
    Group &nbsp;&nbsp; <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">
    <li class="<#compress><@base_controller.IfDefCGIEquals name="groupSize" value="2" trueIfEmpty=true>active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["groupSize=2"] />">
         2
      </a>
    </li>

    <li class="<#compress><@base_controller.IfDefCGIEquals name="groupSize" value="3">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["groupSize=3"] />">
        3
      </a>
    </li>

    <li class="<#compress><@base_controller.IfDefCGIEquals name="groupSize" value="4">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["groupSize=4"] />">
         4
      </a>
    </li>
  </ul>
</div>
</#macro>

<#--
  ResultsSortBySelectbox

  @author Robert Prib
  @desc Creates a select box that allows the user to sort results by different options
 -->
<#macro ResultsSortBySelectbox>

<div class="btn-group">
  <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
    Sort &nbsp;&nbsp; <span class="caret"></span>
  </button>
  <ul class="dropdown-menu" role="menu">

    <li class="<#compress><@base_controller.IfDefCGIEquals name="sort" value="relevance" trueIfEmpty=true>active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["sort=relevance"] />">
        Relevancy
      </a>
    </li>

    <li class="<#compress><@base_controller.IfDefCGIEquals name="sort" value="prox" >active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["sort=prox"] />">
         Proximity
      </a>
    </li>

    <li class="<#compress><@base_controller.IfDefCGIEquals name="sort" value="date" >active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["sort=date"] />">
         Date
      </a>
    </li>

    <li class="<#compress><@base_controller.IfDefCGIEquals name="sort" value="shuffle">active</@base_controller.IfDefCGIEquals></#compress>">
      <a href="<@base_controller.CreateSearchURL CGIs=["sort=shuffle"] />">
         Random
      </a>
    </li>
  </ul>
</div>
</#macro>

</#escape>