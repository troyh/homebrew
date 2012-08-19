<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/RECIPES">
	<xsl:apply-templates select="*"/>
</xsl:template>
	
<xsl:template match="RECIPE">
  <html>
	  <head>
		  <title><xsl:value-of select="NAME"/></title>
	  </head>
	  <body>
		  <h1><xsl:value-of select="NAME"/></h1>
		  <xsl:apply-templates select="STYLES"/>
		  <div><xsl:text>Type: </xsl:text><xsl:value-of select="TYPE"/></div>
		  
		  <div>Batch size: 
			  <xsl:value-of select="format-number(BATCH_SIZE * 0.264172,&quot;#.##&quot;)"/><xsl:text> Gallons (</xsl:text>
			  <xsl:value-of select="format-number(BATCH_SIZE,&quot;#.##&quot;)"/><xsl:text>L)</xsl:text></div>

		  <div>BV: 
			  <xsl:value-of select="format-number(BOIL_SIZE * 0.264172,&quot;#.##&quot;)"/><xsl:text> Gallons (</xsl:text>
			  <xsl:value-of select="format-number(BOIL_SIZE,&quot;#.##&quot;)"/><xsl:text>L)</xsl:text></div>
			  
		  <div><xsl:text>Boil time: </xsl:text><xsl:value-of select="BOIL_TIME"/><xsl:text> minutes</xsl:text></div>
		  <div><xsl:text>Efficiency: </xsl:text><xsl:value-of select="EFFICIENCY"/><xsl:text>%</xsl:text></div>
		  <div><xsl:text>OG: </xsl:text><xsl:value-of select="OG"/></div>
		  <div><xsl:text>FG: </xsl:text><xsl:value-of select="FG"/></div>
		  
		  <xsl:apply-templates select="FERMENTABLES"/>
		  <xsl:apply-templates select="HOPS"/>
		  <xsl:apply-templates select="YEASTS"/>
		  <xsl:apply-templates select="NOTES"/>

	  </body>
  </html>
</xsl:template>

<xsl:template match="FERMENTABLES">
	<h2>Malt</h2>
	<xsl:apply-templates select="FERMENTABLE"/>
</xsl:template>

<xsl:template match="FERMENTABLE">
	<div>
		<xsl:value-of select="format-number(AMOUNT * 2.20462, &quot;#.##&quot;)"/>
		<xsl:text> lbs (</xsl:text>
		<xsl:value-of select="format-number(AMOUNT,&quot;#.##&quot;)"/>
		<xsl:text>kg) </xsl:text>
		<xsl:value-of select="NAME"/>
	</div>
</xsl:template>
	
<xsl:template match="HOPS">
	<h2>Hops</h2>
	<h3>Boil</h3>
	<xsl:apply-templates select="HOP[USE=&quot;Boil&quot;]"/>
	<h3>Dry hops</h3>
	<xsl:apply-templates select="HOP[USE=&quot;Dry Hop&quot;]"/>
</xsl:template>

<xsl:template match="HOP">
	<div>
		<xsl:value-of select="format-number(AMOUNT * 2.20462 * 16,&quot;#.##&quot;)"/>
		<xsl:text>oz (</xsl:text>
		<xsl:value-of select="format-number(AMOUNT,&quot;#.##&quot;)"/>
		<xsl:text>kg) </xsl:text>
		<xsl:value-of select="NAME"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="ALPHA"/>%&#945;
		<xsl:text> </xsl:text>
		<xsl:value-of select="FORM"/>
		<xsl:text> [</xsl:text>
		<xsl:value-of select="TIME"/>
		<xsl:text> min] </xsl:text>
	</div>
</xsl:template>

<xsl:template match="YEASTS">
	<h2>Yeast</h2>
	<xsl:apply-templates select="YEAST"/>
</xsl:template>

<xsl:template match="YEAST">
	<div>
		<xsl:value-of select="AMOUNT * 1000"/>
		<xsl:text>ml </xsl:text>
		<xsl:value-of select="LABORATORY"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="PRODUCT_ID"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="NAME"/>
	</div>
</xsl:template>

<xsl:template match="NOTES">
	<div>
		<h2>Notes</h2>
		<div><xsl:value-of select="."/></div>
	</div>
</xsl:template>
	
<xsl:template match="STYLES">
	<div>Style:
		<xsl:apply-templates select="STYLE"/>
	</div>
</xsl:template>

<xsl:template match="STYLE">
		<xsl:value-of select="NAME"/>
</xsl:template>
	

</xsl:stylesheet>