<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exslt="http://exslt.org/common">

<xsl:output omit-xml-declaration="yes" indent="no" method="text"/>

<xsl:include href="formatting.xsl"/>

<xsl:key name="hops-by-use" match="HOP" use="USE"/>

<xsl:variable name="data">	
	<xsl:for-each select="RECIPE/FERMENTABLES/FERMENTABLE">
		<ppg><xsl:value-of select="AMOUNT * 2.20462 * (YIELD div 100 * 46)"/></ppg>
	</xsl:for-each>
</xsl:variable>

<xsl:template name="sumppg">
	<xsl:value-of select="ppg"/>
</xsl:template>
	
<xsl:template match="RECIPE">
<xsl:text>{
</xsl:text>
	<xsl:variable name="foo">	
		<xsl:for-each select="FERMENTABLES/FERMENTABLE">
			<ppg><xsl:value-of select="AMOUNT * 2.20462 * (YIELD div 100 * 46)"/></ppg>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="totppg" select="sum(exslt:node-set($foo)/ppg)"/>
	<xsl:variable name="CALC_OG_GU" select="($totppg * EFFICIENCY div (BATCH_SIZE * 0.264172)) div 100"/>
	<xsl:variable name="CALC_FG_GU" select="$CALC_OG_GU - ((EFFICIENCY div 100) * $CALC_OG_GU)"/>
	<xsl:text>&#09;"name":"</xsl:text>
	<xsl:call-template name="translateDoubleQuotes">
		<xsl:with-param name="string" select="NAME"/>
	</xsl:call-template>
	<xsl:text>",
	</xsl:text>
	<xsl:apply-templates select="STYLES"/><xsl:if test="count(STYLES)">,</xsl:if>
	<xsl:text>&#09;"type":"</xsl:text><xsl:value-of select="TYPE"/><xsl:text>",
	</xsl:text>
	<xsl:text>&#09;"batch_size":</xsl:text><xsl:value-of select="BATCH_SIZE"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"boil_time":</xsl:text><xsl:value-of select="format-number(BOIL_TIME,&quot;#&quot;)"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"total_ppg":</xsl:text><xsl:value-of select="$totppg"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"efficiency":</xsl:text><xsl:value-of select="EFFICIENCY"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"OG":</xsl:text><xsl:value-of select="format-number($CALC_OG_GU div 1000 + 1,&quot;#.000&quot;)"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"FG":</xsl:text><xsl:value-of select="format-number($CALC_FG_GU div 1000 + 1,&quot;#.000&quot;)"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"ABV":</xsl:text><xsl:value-of select="format-number(($CALC_OG_GU - $CALC_FG_GU) * 131 div 1000,&quot;#.##&quot;)"/><xsl:text>,
	</xsl:text>
	<xsl:text>&#09;"ADF":</xsl:text><xsl:value-of select="format-number((1 - ($CALC_FG_GU div $CALC_OG_GU)) * 100,&quot;#.##&quot;)"/><xsl:text>,
	</xsl:text>

	<!-- From http://www.mrmalty.com/pitching.php:
		
	(0.75 million) X (milliliters of wort) X (degrees Plato of the wort)  
			
	2x as much for lagers
		
	-->
	<xsl:variable name="YEAST_CELLS_REQD" select="0.75 * (BATCH_SIZE * 1000) * ($CALC_OG_GU div 4) div 1000 * ((STYLES/STYLE/CATEGORY_NUMBER &lt; 6) + 1)"/>
	<!-- Assumes a 75% viability of yeast -->
	<xsl:text>&#09;"yeast_starter_slurry":</xsl:text><xsl:value-of select="format-number($YEAST_CELLS_REQD div 2.5 * (1 div .75),&quot;#&quot;)"/><xsl:text>,
</xsl:text>
	<!-- In billions of cells -->
	<xsl:text>&#09;"yeast_starter_cells":</xsl:text><xsl:value-of select="format-number($YEAST_CELLS_REQD,&quot;#&quot;)"/><xsl:text>,
	"ingredients":{
</xsl:text>
		<xsl:text>&#09;&#09;"fermentables":</xsl:text><xsl:apply-templates select="FERMENTABLES"/><xsl:text>,
</xsl:text>
		<xsl:text>&#09;&#09;"hops":</xsl:text><xsl:apply-templates select="HOPS"/><xsl:text>,
</xsl:text>
		<xsl:text>&#09;&#09;"miscellaneous":[</xsl:text><xsl:apply-templates select="MISCS"/><xsl:text>],
</xsl:text>
		<xsl:text>&#09;&#09;"yeast":</xsl:text><xsl:apply-templates select="YEASTS"/><xsl:text>
	},
</xsl:text>
	<xsl:apply-templates select="NOTES"/>
}
</xsl:template>


<xsl:template match="FERMENTABLES">
	<xsl:text>{"total_weight":</xsl:text><xsl:value-of select="sum(FERMENTABLE[TYPE=&quot;Grain&quot;]/AMOUNT)"/><xsl:text>,</xsl:text>
	<xsl:text>&#09;&#09;"list":[</xsl:text>
		<xsl:for-each select="FERMENTABLE">
			<xsl:apply-templates select="."/>
			<xsl:if test="position()!=last()">,</xsl:if>
		</xsl:for-each>
	<xsl:text>]}</xsl:text>
</xsl:template>


<xsl:template match="FERMENTABLE">
	<xsl:text>{
			"amount":</xsl:text><xsl:value-of select="AMOUNT"/><xsl:text>,
			"yield":</xsl:text><xsl:value-of select="YIELD"/><xsl:text>,
			"pct":</xsl:text><xsl:value-of select="format-number(AMOUNT div sum(../FERMENTABLE/AMOUNT) * 100,&quot;#.##&quot;)"/>,<xsl:text>
			"name":"</xsl:text><xsl:value-of select="NAME"/><xsl:text>",
			"type":"</xsl:text><xsl:value-of select="TYPE"/><xsl:text>",
			"srm":</xsl:text><xsl:value-of select="format-number(COLOR,&quot;#&quot;)"/><xsl:text>
		}
		</xsl:text>
</xsl:template>
	
<xsl:template match="HOPS">
	{
		"total_weight":<xsl:value-of select="sum(HOP/AMOUNT)"/>,
		"mash":[<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Mash'"/></xsl:call-template>],
		"first_wort": [<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'First Wort'"/></xsl:call-template>],
	    "boil":[<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Boil'"/></xsl:call-template>],
		"aroma":[<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Aroma'"/></xsl:call-template>],
		"dry_hop":[<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Dry Hop'"/></xsl:call-template>]
	}
</xsl:template>

<xsl:template name="display-hops">
	<xsl:param name="use"/>
	<xsl:if test="count(key('hops-by-use',$use)) > 0">
	<xsl:for-each select="key('hops-by-use',$use)">
		<xsl:apply-templates select="."/>
		<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>
	</xsl:if>
</xsl:template>

<xsl:template match="HOP">
	<xsl:text>{
		"amount":</xsl:text><xsl:value-of select="AMOUNT"/><xsl:text>,
		"name": "</xsl:text><xsl:value-of select="NAME"/><xsl:text>",
		"alpha": </xsl:text><xsl:value-of select="format-number(ALPHA,&quot;#.##&quot;)"/><xsl:text>,
</xsl:text>
		<xsl:if test="USE = 'Boil' or USE = 'Dry Hop'">
			<xsl:text>&#09;&#09;"time":</xsl:text><xsl:value-of select="format-number(TIME,&quot;#&quot;)"/><xsl:text>,
</xsl:text>
		</xsl:if>
		<xsl:text>&#09;&#09;"form":"</xsl:text><xsl:value-of select="FORM"/><xsl:text>"
     }</xsl:text>
</xsl:template>

<xsl:template match="MISCS">
	<xsl:for-each select="MISC">
		<xsl:apply-templates select="."/>
		<xsl:if test="position()!=last()">,</xsl:if>
	</xsl:for-each>
</xsl:template>

<xsl:template match="MISC">
	<xsl:text>{"amount":</xsl:text><xsl:value-of select="AMOUNT"/><xsl:text>,
</xsl:text>
	<xsl:text>"name":"</xsl:text><xsl:value-of select="NAME"/><xsl:text>",
</xsl:text>
	<xsl:text>"time":</xsl:text><xsl:value-of select="TIME"/><xsl:text>}
</xsl:text>
</xsl:template>

<xsl:template match="YEASTS">
	[<xsl:apply-templates select="YEAST"/>]
</xsl:template>

<xsl:template match="YEAST">
	{
		"lab":"<xsl:value-of select="LABORATORY"/>",
		"prod_id":"<xsl:value-of select="PRODUCT_ID"/>",
		"name": "<xsl:value-of select="NAME"/>",
		"temperature_lo":<xsl:value-of select="number(MIN_TEMPERATURE)"/>,
		"temperature_hi":<xsl:value-of select="number(MAX_TEMPERATURE)"/>,
		"attenuation": <xsl:value-of select="ATTENUATION"/>
	}
</xsl:template>


<xsl:template match="NOTES">
	<xsl:text>"notes": "</xsl:text>
	<xsl:call-template name="jsonString">
		<xsl:with-param name="string" select="."/>
	</xsl:call-template>
	<xsl:text>"</xsl:text>
</xsl:template>
	
<xsl:template match="STYLES">
	<xsl:text>"styles": [</xsl:text><xsl:apply-templates select="STYLE"/><xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="STYLE">
	<xsl:text>{
			"name":"</xsl:text><xsl:value-of select="NAME"/><xsl:text>",
			"category":</xsl:text><xsl:value-of select="CATEGORY_NUMBER"/><xsl:text>,
			"letter":"</xsl:text><xsl:value-of select="STYLE_LETTER"/><xsl:text>"
&#09;}
</xsl:text>
</xsl:template>

<xsl:template name="jsonString">
	<xsl:param name="string" select="''" />
	<xsl:call-template name="translateNewlines">
		<xsl:with-param name="string">
			<xsl:call-template name="translateDoubleQuotes">
				<xsl:with-param name="string" select="$string"/>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>
	
<xsl:template name="translateDoubleQuotes">
	<xsl:param name="string" select="''" />

	<xsl:choose>
		<xsl:when test="contains($string, '&quot;')">
			<xsl:text /><xsl:value-of select="substring-before($string, '&quot;')" />\"<xsl:call-template name="translateDoubleQuotes"><xsl:with-param name="string" select="substring-after($string, '&quot;')" /></xsl:call-template><xsl:text />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text /><xsl:value-of select="$string" /><xsl:text />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="translateNewlines">
	<xsl:param name="string" select="''" />

	<xsl:choose>
		<xsl:when test="contains($string, '&#10;')">
			<xsl:text /><xsl:value-of select="substring-before($string, '&#10;')" />\n<xsl:call-template name="translateNewlines"><xsl:with-param name="string" select="substring-after($string, '&#10;')" /></xsl:call-template><xsl:text />
		</xsl:when>
		<xsl:otherwise>
			<xsl:text /><xsl:value-of select="$string" /><xsl:text />
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

