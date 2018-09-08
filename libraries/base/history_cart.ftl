<#ftl encoding="utf-8" output_format="HTML" />

<#--
  Display a "Last visited X time ago" link for a result

  @param result Result to display the link for
  @param class CSS class to use. Defaults to text-success
-->
<#macro LastVisitedLink result icon="fa fa-clock-o" class="text-success">
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(result.indexUrl)??>
    <small class="${class} search-last-visited">
      <span class="${icon}"></span> <a title="Click history" href="#" class="${class}" data-ng-click="toggleHistory()">
        Last visited ${prettyTime(session.getClickHistory(result.indexUrl).clickDate)}
      </a>
    </small>
  </#if>
</#macro>

<#--
  Display the click and search history
-->
<#macro SearchHistory>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <section id="search-history" class="search-history" data-ng-cloak data-ng-show="isDisplayed('history')">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <a href="#" data-ng-click="hideHistory()"><span class="fa fa-arrow-left"></span> Back to results</a>
            <h2 class="sr-only">Search history</h2>

            <div class="row">

              <#-- Click history -->
              <div class="col-md-6" data-ng-controller="ClickHistoryCtrl">
                <div class="card" data-ng-show="!clickHistoryEmpty && <@fb.HasClickHistory />">
                  <div class="card-header">
                    <h3>
                      <span class="fa fa-heart"></span> Recently clicked results
                      <button class="btn btn-danger btn-sm float-right" title="Clear click history" data-ng-click="clear('Your history will be cleared')"><span class="fa fa-times"></span> Clear</button>
                    </h3>
                  </div>
                  <div class="card-body">
                    <ul class="list-unstyled">
                      <#list session.clickHistory as h>
                        <li><a href="${h.indexUrl}">${h.title}</a> &middot; <span class="text-info">${prettyTime(h.clickDate)}</span><#if h.query??><span class="text-muted"> for &quot;${h.query!}&quot;</#if></span></li>
                      </#list>
                    </ul>
                  </div>
                </div>

                <div class="card" data-ng-show="clickHistoryEmpty || !<@fb.HasClickHistory />">
                  <div class="card-header">
                    <h3><span class="fa fa-heart"></span> Recently clicked results</h3>
                  </div>
                  <div class="card-body">
                    <p class="text-muted">Your click history is empty.</p>
                  </div>
                </div>
              </div>

              <#-- Search history -->
              <div class="col-md-6" data-ng-controller="SearchHistoryCtrl">
                <div class="card" data-ng-show="!searchHistoryEmpty && <@fb.HasSearchHistory />">
                  <div class="card-header">
                    <h3>
                      <span class="fa fa-search"></span> Recent searches
                      <button class="btn btn-danger btn-sm float-right" title="Clear search history" data-ng-click="clear('Your history will be cleared')"><span class="fa fa-times"></span> Clear</button>
                    </h3>
                  </div>
                  <div class="card-body">
                    <ul class="list-unstyled">
                      <#list session.searchHistory as h>
                        <li><a href="?${h.searchParams}">${h.originalQuery!} <small>(${h.totalMatching})</small></a> &middot; <span class="text-info">${prettyTime(h.searchDate)}</span></li>
                      </#list>
                    </ul>
                  </div>
                </div>

                <div class="card" data-ng-show="searchHistoryEmpty || !<@fb.HasSearchHistory />">
                  <div class="card-header">
                    <h3><span class="fa fa-search"></span> Recent searches</h3>
                  </div>
                  <div class="card-body">
                    <p class="text-muted">Your search history is empty.</p>
                  </div>
                </div>
              </div>

            </div>
          </div>
        </div>
      </div>
    </section>
  </#if>
</#macro>

<#--
  Display the shopping cart / shortlist

  Different shortlist templates can be used depending the source collection
  the result is coming from (based on the <code>C</code> metadata).
-->
<#macro Cart>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <section id="search-cart" class="search-cart" data-ng-cloak data-ng-show="isDisplayed('cart')" data-ng-controller="CartCtrl">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <a href="#" data-ng-click="hideCart()"><span class="fa fa-arrow-left"></span> Back to results</a>
            <h2 class="text-center">
              <span class="fa fa-star"></span> Shortlist
              <button class="btn btn-danger btn-sm" title="Clear selection" data-ng-click="clear('Your selection will be cleared')"><span class="fa fa-times"></span> Clear</button>
            </h2>

            <div class="row search-results">
              <div class="col-md-12">

                <ul class="list-unstyled">
                  <li data-ng-repeat="item in cart">
                    <div data-ng-switch="item.metaData.C">

                      <#-- Output templates for all results depending on their source collection,
                        per configured in collection.cfg -->
                      <#list question.collection.configuration.valueKeys() as key>
                        <#if key?starts_with("stencils.template.shortlist.")>
                          <#assign itemCollection = key?substring("stencils.template.shortlist."?length)>
                          <#assign itemNamespace = question.collection.configuration.value(key)>
                          <#if .main[itemNamespace]??>
                            <div data-ng-switch-when="${itemCollection}">
                              <@.main[itemNamespace].ShortListTemplate />
                            </div>
                          </#if>
                        </#if>
                      </#list>

                      <#-- Default template for shortlist items -->
                      <div data-ng-switch-default>
                        <div class="card">

                          <div class="card-header">
                            <h4>
                              <a title="Remove" data-ng-click="remove(item.indexUrl)" href="javascript:;"><small class="fa fa-times"></small></a>
                              <a data-ng-href="{{item.indexUrl}}">{{item.title|truncate:70}}</a>
                            </h4>
                            <div class="card-subtitle text-muted">
                              <cite>{{item.indexUrl|cut:'http://'}}</cite>
                            </div>
                          </div>

                          <div class="card-body">
                            <div class="card-text">
                              <p>{{item.summary|truncate:255}}</p>
                            </div>
                          </div>

                        </div>
                      </div>
                    </div>
                  </li>
                </ul>

              </div>
            </div>

          </div>
        </div>
      </div>
    </section>
  </#if>
</#macro>

<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
