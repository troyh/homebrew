<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exslt="http://exslt.org/common">

<xsl:template match="/">
	<html>
		<head>
			<title>Homebrewing</title>
			<link rel="stylesheet" type="text/css" href="recipe.css" />
		</head>
		<body>
			<h1>Homebrewing</h1>
			<h2>Batches</h2>
			<xsl:apply-templates select="batches"/>
			<h2>Recipes</h2>
			<ol><xsl:apply-templates select="document('recipeindex.xml')/recipes"/></ol>
			<h2>Yeasts</h2>
			<xsl:apply-templates select="//batches/batch/yeasts/yeast"/>
		</body>
	</html>
</xsl:template>
	
<xsl:template match="batches">
	<table id="batches">
		<tr>
			<th>#</th>
			<th>Name</th>
			<th>Mash efficiency</th>
			<th>Brewhouse efficiency</th>
			<th>Apparent Attenuation</th>
		</tr>
		<xsl:apply-templates select="*"/>
		<tr>
			<th></th>
			<th>Average</th>
			<th>
				<xsl:variable name="total">
					<xsl:for-each select="batch">
						<val><xsl:value-of select="(((results/boil/@sg - 1) * 1000) * (results/boil/@volume * 0.264172)) div sum(data/ppg)"/></val>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="allvals" select="exslt:node-set($total)/val[string(.) != 'NaN']"/>
				<xsl:value-of select="format-number(sum($allvals) div count($allvals) * 100,&quot;#&quot;)"/>%
			</th>
			<th>
				<xsl:variable name="total">
					<xsl:for-each select="batch">
						<val><xsl:value-of select="(((results/gravity/@og - 1) * 1000) * (results/gravity/@volume * 0.264172)) div sum(data/ppg)"/></val>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="allvals" select="exslt:node-set($total)/val[string(.) != 'NaN']"/>
				<xsl:value-of select="format-number(sum($allvals) div count($allvals) * 100,&quot;#&quot;)"/>%
			</th>
			<th>
				<xsl:variable name="total">
					<xsl:for-each select="batch">
						<val><xsl:value-of select="(((results/gravity/@og - 1) * 1000) - ((results/gravity/@fg - 1) * 1000)) div ((results/gravity/@og - 1) * 1000)"/></val>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="allvals" select="exslt:node-set($total)/val[string(.) != 'NaN']"/>
				<xsl:value-of select="format-number(sum($allvals) div count($allvals) * 100,&quot;#&quot;)"/>%
			</th>
		</tr>
	</table>
</xsl:template>

<xsl:template match="recipe">
	<li><a>
		<xsl:attribute name="href"><xsl:value-of select="substring(@filename,1,string-length(@filename)-4)"/>.html</xsl:attribute>
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
