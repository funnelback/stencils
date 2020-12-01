<#ftl encoding="utf-8" output_format="HTML" />
<#--
  Display a "Last visited X time ago" link for a result

  @param result Result to display the link for
-->
<#macro LastVisitedLink result>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session") && session?? && session.getClickHistory(result.indexUrl)??>
    <small class="text-success search-last-visited session-history-link"> 
      <button title="Click history" tabindex="0" class="btn-link text-success session-history-show border-0">
        <span class="far fa-clock"></span>
        Last visited ${prettyTime(session.getClickHistory(result.indexUrl).clickDate)}
      </button>
    </small>
  </#if>
</#macro>

<#--
  Display the click and search history
-->
<#macro SearchHistory>
  <#if question.collection.configuration.valueAsBoolean("ui.modern.session")>
    <section id="search-history" class="search-history mb-3">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <button tabindex="0" class="btn-link session-history-hide"><span class="fa fa-arrow-left"></span> Back to results</button>
            <h2 class="sr-only">Search history</h2>

            <div class="row">

              <#-- Click history -->
              <div class="col-md-6">
              <!-- ${session.clickHistory?size} -->
                <div class="card session-history-click-results">
                  <div class="card-header">
                    <h3>
                      <span class="fa fa-heart"></span> Recently clicked results
                      <button class="btn btn-danger btn-sm float-right session-history-clear-click" title="Clear click history"><span class="fa fa-times"></span> Clear</button>
                    </h3>
                  </div>
                  <div class="card-body">
                    <ul class="list-unstyled">
                      <#list session.clickHistory as h>
                        <li>
                          <a href="${h.indexUrl}">${h.title}</a> &middot; <span class="text-info">${prettyTime(h.clickDate)}</span>
                          <#if h.query??>
                            <span class="text-muted"> for &quot;${(h.query!"")?split("|")[0]?trim}&quot;</span>
                          </#if>
                        </li>
                      </#list>
                    </ul>
                  </div>
                </div>
              
                <div class="card session-history-click-empty">
                  <div class="card-header">
                    <h3><span class="fa fa-heart"></span> Recently clicked results</h3>
                  </div>
                  <div class="card-body">
                    <p class="text-muted">Your click history is empty.</p>
                  </div>
                </div>
              
              </div>

              <#-- Search history -->
              <div class="col-md-6">
              
                <div class="card session-history-search-results">
                  <div class="card-header">
                    <h3>
                      <span class="fa fa-search"></span> Recent searches
                      <button class="btn btn-danger btn-sm float-right session-history-clear-search" title="Clear search history"><span class="fa fa-times"></span> Clear</button>
                    </h3>
                  </div>
                  <div class="card-body">
                    <ul class="list-unstyled">
                      <#list session.searchHistory as h>
                        <li>
                          <a href="?${h.searchParams}">${h.originalQuery!} <small>(${h.totalMatching})</small></a> &middot; 
                          <span class="text-info">${prettyTime(h.searchDate)}</span>
                        </li>
                      </#list>
                    </ul>
                  </div>
                </div>
              
                <div class="card session-history-search-empty">
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
    <section id="search-cart" class="search-cart"></section>
  </#if>
</#macro>

<#macro CartTemplate>
  <script id="cart-template" type="text/x-handlebars-template">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <button id="flb-cart-box-back" class="btn-link" tabindex="0">
            {{>icon-block icon=backIcon}} {{>label-block label=backLabel}}
          </button>
          <h2 id="flb-cart-box-header" class="text-center d-flex justify-content-center align-items-center">
            {{>icon-block icon=headerIcon}} {{>label-block label=label}}
            <button id="flb-cart-box-clear" class="btn btn-xs btn-danger btn-clear" tabindex="0">
              {{>icon-block icon=clearIcon}} {{>label-block label=clearLabel}}
            </button>
          </h2>
          <div class="row search-results mt-3">
            <div class="col-md-12">
              <ul id="flb-cart-box-list" class="list-unstyled"></ul>
            </div>
          </div>
        </div>
      </div>
    </div>
  </script>
</#macro>

<#macro DefaultCartItemTemplate>
<script id="cart-template-default" type="text/x-handlebars-template">
<div class="card search-result-default">
  <div class="card-header cart-item-trigger-parent">
    <h4>
      <a href="{{indexUrl}}">{{#truncate 70}}{{title}}{{/truncate}}</a>
    </h4>
    <div class="card-subtitle text-muted">
      <cite>{{#cut "https://"}}{{indexUrl}}{{/cut}}</cite>
    </div>
  </div>
  <div class="card-body">
    <div class="card-text">
      {{#if metaData.image}}<img class="img-fluid float-right" alt="{{result.title}}" src="{{metaData.image}}">{{/if}}

      {{#if metaData.c}}
        {{#if metaData.date}}<small class="text-muted">{{ metaData.date }}:&nbsp;</small>{{/if}}
        {{metaData.c}}
      {{/if}}
    </div>
  </div>
</div>
</script>
</#macro>

<#macro Configuration>
  <#local host=httpRequest.getHeader('host')>
  <script type="text/javascript">
    window.addEventListener('DOMContentLoaded', function() {
      new Funnelback.SessionCart({
        apiBase: '${question.getCurrentProfileConfig().get("stencils.sessions.cart.api_base")!"https://${host}/s/cart.json"}',
        collection: '${question.collection.id}',
        iconPrefix: '',
        cartCount: {
          template: '{{>icon-block}} {{>label-block}} ({{count}})',
          icon: 'fas fa-star',
          label: 'Shortlist',
          isLabel: true
        },
        cart: {
          backIcon: 'fas fa-arrow-left',
          backLabel: 'Back to results',
          clearIcon: 'fas fa-times',
          label: ' Shortlist ',
          icon: 'fas fa-star',
          emptyMessage: '<span id="flb-cart-empty-message">No items in your shortlist</span>'
        },
        item: {
          templates: {
            <#list question.getCurrentProfileConfig().get("stencils.cart.collections")!?split(",") as collection>
              '${collection}': document.getElementById('cart-template-${collection}').text,
            </#list>
          },
          class: 'mb-3'
        },
        itemTrigger: {
          selector: '.cart-item-trigger-parent',
          labelAdd: 'Add to shortlist',
          iconAdd: 'far fa-star',
          labelDelete: 'Remove',
          iconDelete: 'fas fa-times',
          isLabel: true,
          class: 'btn btn-secondary float-right'
        }
      });
      new Funnelback.SessionHistory({
        searchApiBase: '${question.getCurrentProfileConfig().get("stencils.sessions.history.search.api_base")!"https://${host}/s/search-history.json"}',
        clickApiBase: '${question.getCurrentProfileConfig().get("stencils.sessions.history.click.api_base")!"https://${host}/s/click-history.json"}',
        collection: '${question.collection.id}',
        currentSearchHistorySelectors: ['.session-history-search-results'],
        currentClickHistorySelectors: ['.session-history-click-results']
      });
    });
  </script>
</#macro>
<#-- vim: set expandtab ts=2 sw=2 sts=2 :-->
