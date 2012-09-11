<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="beerxml.xsl"/>

<xsl:param name="versions_file"/>

<xsl:template match="/">
	<html>
		<head>
			<title>
				<xsl:if test="string-length(/RECIPES/RECIPE/NAME) = 0">No title</xsl:if>
				<xsl:value-of select="/RECIPES/RECIPE/NAME" disable-output-escaping="yes"/>
			</title>
			<link rel="stylesheet" type="text/css" href="../recipe.css" />
			<script src="../js/tumblr.js" />
		</head>
		<body>
			<div id="topnav">
				<a href="../index.html">Home</a>
			</div>
			<xsl:apply-templates select="*"/>
			
			<h1>Versions</h1>
			<div id="versions">
				<xsl:apply-templates select="document($versions_file)/*"/>
			</div>
		</body>
	</html>
</xsl:template>

<xsl:template match="versions">
	<xsl:apply-templates select="version"/>
</xsl:template>

<xsl:template match="version">
	<div class="version">
		<div class="date">
			<a>
				<xsl:attribute name="href">versions/<xsl:value-of select="../@id"/>/<xsl:value-of select="@id"/>.html</xsl:attribute>
				<xsl:value-of select="date"/>
			</a>
		</div>
		<div class="versionmessage"><xsl:value-of select="message"/></div>
	</div>
</xsl:template>
	
</xsl:stylesheet>
