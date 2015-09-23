<#ftl encoding="utf-8" />

<#escape x as x?html>

<#assign searchUrl = "/s/search.html?" >
<#assign StencilsThirdpartyResourcesPrefix = "${SearchPrefix}stencils-resources/thirdparty/" >

<!DOCTYPE html>
<html lang="en-us">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="robots" content="nofollow">
	<!--[if IE]><meta http-equiv="X-UA-Compatible" content="IE=edge"><![endif]-->

	<title>Stencils</title>

	<link rel="stylesheet" href="${SearchPrefix}thirdparty/bootstrap-3.0.0/css/bootstrap.min.css">
	<link rel="stylesheet" href="${StencilsThirdpartyResourcesPrefix}bootstrap-3.3.5-dist/css/bootstrap.min.css">
	<link rel="stylesheet" href="${SearchPrefix}stencils-resources/base/css/font-awesome-4.3.0/css/font-awesome.min.css">

	<!--[if lt IE 9]>
		<script src="${SearchPrefix}thirdparty/html5shiv.js"></script>
		<script src="${SearchPrefix}thirdparty/respond.min.js"></script>
	<![endif]-->

</head>
<body>

	<div class="jumbotron" id="deployment" style="margin:0.2em 0">
		<div class="container">
			<h1>Stencils</h1>

			<h2><span class="glyphicon glyphicon-ok"></span> Core</h2>
			<p class="lead">The starter search setup.</p>
			<h3>Implementation Examples</h3>
			<div class="list-group">
				<a href="${searchUrl}collection=stencils-core-meta&query=!padrenull" class="list-group-item">
					<h4 class="list-group-item-heading">Basic</h4>
					<p class="list-group-item-text">Your basic starter search</p>
				</a>
				<a href="${searchUrl}collection=stencils-core_panels-meta&query=!padrenull" class="list-group-item">
					<h4 class="list-group-item-heading">Panels</h4>
					<p class="list-group-item-text"> Search with list and grid view selectors and panel flavoured search result format.</p>
				</a>
			</div>

			<h2><i class="fa fa-share-square"></i> Social Media</h2>
			<p class="lead">Best practice implementations for social media search.</p>
			<h3>Implementation Examples</h3>
			<div class="list-group">
				<a href="${searchUrl}collection=stencils-social-meta&query=!padrenull" class="list-group-item">
					<h4 class="list-group-item-heading">Search & Find</h4>
					<p class="list-group-item-text">Search with list and grid view selectors and panel flavoured search result format.</p>
				</a>
			</div>

			<h2><i class="fa fa-facebook-square"></i> Facebook </h2>
			<p class="lead">Best practice implementations for facebook search.</p>
			<h3>Implementation Examples</h3>
			<div class="list-group">
				<a href="${searchUrl}collection=stencils-facebook-meta&query=!padrenull" class="list-group-item">
					<h4 class="list-group-item-heading">Search & Find</h4>
					<p class="list-group-item-text">Search with list and grid view selectors and panel flavoured search result format.</p>
				</a>
				<#-- <a href="#" class="list-group-item">
					<h4 class="list-group-item-heading">Search and Discover (TODO)</h4>
					<p class="list-group-item-text">Search with a focus more on discovery of content .</p>
				</a>
				<a href="#" class="list-group-item">
					<h4 class="list-group-item-heading">Integrated into Another Search (TODO)</h4>
					<p class="list-group-item-text">See facebook results within another search implementation like the core.</p>
				</a>
				<a href="#" class="list-group-item">
					<h4 class="list-group-item-heading">Facebook Embed styles (TODO)</h4>
					<p class="list-group-item-text">See facebook results styled using facebook embed code.</p>
				</a> -->

				<h2><i class="fa fa-twitter-square"></i> Twitter</h2>
				<p class="lead">Best practice implementations for twitter search.</p>
				<h3>Implementation Examples</h3>
				<div class="list-group">
					<a href="${searchUrl}collection=stencils-twitter-meta&query=!padrenull" class="list-group-item">
						<h4 class="list-group-item-heading">Search & Find</h4>
						<p class="list-group-item-text">Search with list and grid view selectors and panel flavoured search result format.</p>
					</a>
					<#-- <a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Search and Discover (TODO)</h4>
						<p class="list-group-item-text">Search with a focus more on discovery of content .</p>
					</a>
					<a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Integrated into Another Search (TODO)</h4>
						<p class="list-group-item-text">See facebook results within another search implementation like the core.</p>
					</a>
					<a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Twitter Embed styles (TODO)</h4>
						<p class="list-group-item-text">See twitter results styled using twitter embed code.</p>
					</a> -->
				</div>

				<h2><i class="fa fa-youtube-square"></i> Youtube</h2>
				<p class="lead">Best practice implementations for youtube search.</p>
				<h3>Implementation Examples</h3>
				<div class="list-group">
					<a href="${searchUrl}collection=stencils-youtube-meta&query=!padrenull" class="list-group-item">
						<h4 class="list-group-item-heading">Search & Find</h4>
						<p class="list-group-item-text">Search with list and grid view selectors and panel flavoured search result format.</p>
					</a>
					<#-- <a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Search and Discover (TODO)</h4>
						<p class="list-group-item-text">Search with a focus more on discovery of content .</p>
					</a>
					<a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Integrated into Another Search (TODO)</h4>
						<p class="list-group-item-text">See facebook results within another search implementation like the core.</p>
					</a>
					<a href="#" class="list-group-item">
						<h4 class="list-group-item-heading">Youtube Video Embed style (TODO)</h4>
						<p class="list-group-item-text">See youtube videos embeded in result.</p>
					</a> -->
				</div>

				<h2><i class="fa fa-flickr"></i> Flickr</h2>
				<p class="lead">Best practice implementations for flickr search.</p>
				<h3>Implementation Examples</h3>
				<div class="list-group">
					<a href="${searchUrl}collection=stencils-flickr-meta&query=!padrenull" class="list-group-item">
						<h4 class="list-group-item-heading">Search & Find</h4>
						<p class="list-group-item-text">Search with list and grid view selectors and panel flavoured search result format.</p>
					</a>
				</div>
				<#--	/Close jumbotron-->
			</div>
		</div>
	</div>

</body>
</html>
</#escape>
