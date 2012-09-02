<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:param name="recipes_doc"/>

<xsl:template match="/">
	<html>
		<head>
			<title>Homebrewing</title>
		</head>
		<body>
			<h1>Homebrewing</h1>
			<h2>Batches</h2>
			<xsl:apply-templates select="batches"/>
			<h2>Recipes</h2>
			<ol><xsl:apply-templates select="document($recipes_doc)/RECIPES"/></ol>
			<h2>Yeasts</h2>
			<xsl:apply-templates select="//batches/batch/yeasts/yeast"/>
		</body>
	</html>
</xsl:template>
	
<xsl:template match="batches">
	<table>
		<tr>
			<th>#</th>
			<th>Name</th>
			<th>Mash efficiency</th>
			<th>Brewhouse efficiency</th>
			<th>Apparent Attenuation</th>
		</tr>
		<xsl:apply-templates select="*"/>
	</table>
</xsl:template>

<xsl:template match="RECIPE">
	<li><a>
		<xsl:attribute name="href">recipe/<xsl:value-of select="NAME"/>.html</xsl:attribute>
		<xsl:value-of select="NAME" disable-output-escaping="yes"/></a></li>
</xsl:template>

<xsl:template match="batch">
	<tr>
		<td>
			<xsl:value-of select="@id"/>
		</td>
		<td>
			<a>
				<xsl:attribute name="href">batch/<xsl:value-of select="@id"/>.html</xsl:attribute>
				<xsl:value-of select="name" disable-output-escaping="yes"/>
			</a>
		</td>
		<td>
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((results/boil/@sg - 1) * 1000) * (results/boil/@volume * 0.264172)) div sum(data/ppg)"/>
			</xsl:call-template>
		</td>
		<td>
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((results/gravity/@og - 1) * 1000) * (results/gravity/@volume * 0.264172)) div sum(data/ppg)"/>
			</xsl:call-template>
		</td>
		<td>
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((results/gravity/@og - 1) * 1000) - ((results/gravity/@fg - 1) * 1000)) div ((results/gravity/@og - 1) * 1000)"/>
			</xsl:call-template>
		</td>
	</tr>
</xsl:template>

<xsl:template match="yeast">
	<li>
		<xsl:value-of select="lab"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="prodid"/>
	</li>
</xsl:template>

<xsl:template name="format-percent">
	<xsl:param name="value"/>
	<xsl:param name="precision"/>
	<span class="percent">
		<xsl:choose>
			<xsl:when test="string(number($value)) = 'NaN'"><xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$precision = 2">
						<xsl:value-of select="format-number($value * 100,&quot;#.##&quot;)"/>
					</xsl:when>
					<xsl:when test="$precision = 1">
						<xsl:value-of select="format-number($value * 100,&quot;#.#&quot;)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="format-number($value * 100,&quot;#&quot;)"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>%</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</span>
</xsl:template>

</xsl:stylesheet>
