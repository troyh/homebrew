<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="beerxml.xsl"/>

<xsl:template match="/">
	<html>
		<head>
			<title>
				<xsl:if test="string-length(recipe/beerxml/RECIPE/NAME) = 0">No title</xsl:if>
				<xsl:value-of select="recipe/beerxml/RECIPE/NAME" disable-output-escaping="yes"/>
			</title>
			<link rel="stylesheet" type="text/css" href="../recipe.css" />
			<script src="../js/tumblr.js" />
		</head>
		<body>
			<xsl:apply-templates select="*"/>
		</body>
	</html>
</xsl:template>

</xsl:stylesheet>
