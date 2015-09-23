<#ftl encoding="utf-8" />
<#--
	Funnelback App: Experts
	By: Gioan Tran
	Description: <Description>

	Note: Do not modify this file for specific implementations as customisations will be lost during 
	Funnelback App upgrades. Customisations should be completed in the experts.ftl file.    
-->

<#--
  Sets HTML encoding as the default for this file only - use <#noescape>...</#noescape> around anything which should not be escaped.
  Note that if you include macros from another file, they are not affected by this and must hand escaping themselves
  Either by using a similar escape block, or ?html escapes inline.
-->
<#escape x as x?html>

<#import "/web/templates/modernui/funnelback_classic.ftl" as s/>
<#import "/web/templates/modernui/funnelback.ftl" as fb/>

<#macro jsDefault>
  <#-- Evenly spaces and animates elements on a page when page resizes -->
  <script type="text/javascript" src="resources/${question.collection.id}/${question.profile}/masonry.pkgd.min.js"></script>
</#macro>

</#escape>