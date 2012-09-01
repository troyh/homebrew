<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/batch">
	<html>
		<head>
			<title>
				<xsl:if test="string-length(recipe/beerxml/RECIPE/NAME) = 0">No title</xsl:if>
				<xsl:value-of select="recipe/beerxml/RECIPE/NAME" disable-output-escaping="yes"/>
			</title>
			<link rel="stylesheet" type="text/css" href="recipe.css" />
			<script src="../../js/tumblr.js" />
		</head>
		<body>
			<xsl:apply-templates select="*"/>
		</body>
	</html>
</xsl:template>
	
<xsl:template match="recipe/beerxml/RECIPE">
		  <div id="header">
			  <h1><xsl:value-of select="NAME" disable-output-escaping="yes"/></h1>
			  <xsl:apply-templates select="STYLES"/>
			  <div><xsl:text>Type: </xsl:text><xsl:value-of select="TYPE"/></div>
		  
			  <div>Batch size: 
				  <xsl:value-of select="format-number(BATCH_SIZE * 0.264172,&quot;#.##&quot;)"/><xsl:text> Gallons (</xsl:text>
				  <xsl:value-of select="format-number(BATCH_SIZE,&quot;#.##&quot;)"/><xsl:text>L)</xsl:text></div>

			  <div>Boil Volume: 
				  <xsl:value-of select="format-number(BOIL_SIZE * 0.264172,&quot;#.##&quot;)"/><xsl:text> Gallons (</xsl:text>
				  <xsl:value-of select="format-number(BOIL_SIZE,&quot;#.##&quot;)"/><xsl:text>L)</xsl:text></div>
			  
			  <div><xsl:text>Boil time: </xsl:text><xsl:value-of select="BOIL_TIME"/><xsl:text> minutes</xsl:text></div>
			  <div><xsl:text>End of Boil Volume: </xsl:text><xsl:value-of select="BOIL_TIME"/><xsl:text> minutes</xsl:text></div>
			  <div><xsl:text>Final Volume: </xsl:text><xsl:value-of select="BOIL_TIME"/><xsl:text> minutes</xsl:text></div>
			  <div><xsl:text>Brewhouse Efficiency: </xsl:text><xsl:value-of select="EFFICIENCY"/><xsl:text>%</xsl:text></div>
			  <div><xsl:text>OG: </xsl:text><xsl:value-of select="OG"/></div>
			  <div><xsl:text>FG: </xsl:text><xsl:value-of select="FG"/></div>
		  </div>

	      <div id="ingredients">
			  <xsl:apply-templates select="FERMENTABLES"/>
			  <xsl:apply-templates select="HOPS"/>
			  <xsl:apply-templates select="YEASTS"/>
		  </div>
		  
		  <div id="mashprofile">
			  <xsl:apply-templates select="MASH"/>
		  </div>
		  
		  <xsl:apply-templates select="NOTES"/>

</xsl:template>

<xsl:template match="results">
	<h2>Results</h2>
	<div>
		<div>Strike: 
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="mash/infusion/strike/@volume"/>
			</xsl:call-template>
			@
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" select="mash/infusion/strike/@temp"/>
			</xsl:call-template>
		</div>
		<div>Mash: <xsl:value-of select="mash/@duration"/> minutes at
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" select="mash/measurement/@temp[1]"/>
			</xsl:call-template>
			<xsl:text>, average of </xsl:text>
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" 
					select="sum(mash/measurement/@temp) div count(mash/measurement/@temp)"/>
			</xsl:call-template>
		</div>
		<div>Boil: 
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="boil/@volume"/>
			</xsl:call-template>
			for <xsl:value-of select="boil/@time"/> minutes &#8594; 
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="boil/@end_volume"/>
			</xsl:call-template>
		</div>
		<div>Evaporation rate: 
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="(boil/@volume - boil/@end_volume) div (boil/@time div 60)"/>
			</xsl:call-template>
			per hour
			(<xsl:call-template name="format-percent">
				<xsl:with-param name="value" 
					select="(boil/@volume - boil/@end_volume) div boil/@volume div (boil/@time div 60)"/>
			</xsl:call-template>)
		</div>
		<div>Final Volume: 
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="gravity/@volume"/>
			</xsl:call-template>
		</div>
		<div>OG: <xsl:value-of select="gravity/@og"/></div>
		<div>FG: <xsl:value-of select="gravity/@fg"/></div>
		<div>ABV: 
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((gravity/@og - 1) * 1000) - ((gravity/@fg - 1) * 1000)) * 131 div 100000"/>
				<xsl:with-param name="precision" select="2"/>
			</xsl:call-template>
		</div>
		<div>Mash efficiency: 
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((boil/@sg - 1) * 1000) * (boil/@volume * 0.264172)) div sum(../recipe/data/ppg)"/>
			</xsl:call-template>
		</div>
		<div>Brewhouse efficiency: 
			<xsl:call-template name="format-percent">
				<xsl:with-param name="value" select="(((gravity/@og - 1) * 1000) * (gravity/@volume * 0.264172)) div sum(../recipe/data/ppg)"/>
			</xsl:call-template>
		</div>
		<div>Apparent Attenuation: <xsl:value-of select="format-number((((gravity/@og - 1) * 1000) - ((gravity/@fg - 1) * 1000)) div ((gravity/@og - 1) * 1000) * 100,&quot;#&quot;)"/>%</div>
	</div>
</xsl:template>

<xsl:template match="FERMENTABLES">
	<div id="fermentables">
		<div class="total_weight">
			<xsl:call-template name="format-weight">
				<xsl:with-param name="kgs" select="sum(FERMENTABLE/AMOUNT)"/>
			</xsl:call-template>
		</div>
		<table>
			<xsl:apply-templates select="FERMENTABLE"/>
		</table>
	</div>
</xsl:template>

<xsl:template name="format-weight">
	<xsl:param name="kgs"/>
	<div class="weight">
		<div class="english">
			<xsl:choose>
				<xsl:when test="$kgs &lt; 2.20462">
					<xsl:value-of select="format-number(($kgs * 2.20462 * 16) mod 16,&quot;#.##&quot;)"/> oz
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="format-number($kgs * 2.20462,&quot;#&quot;)"/> lbs 
					<xsl:variable name="oz" select="format-number($kgs * 2.20462 * 16,&quot;#.##&quot;) mod 16"/>
					<xsl:choose>
						<xsl:when test="$oz &gt; 0">
							<xsl:value-of select="$oz"/> oz
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<!-- <div class="decimal"><xsl:value-of select="format-number($kgs * 2.20462,&quot;#.##&quot;)"/> lbs</div>  -->
		</div>
		<div class="metric">
			<xsl:choose>
				<xsl:when test="$kgs &lt; 1.0">
					(<xsl:value-of select="format-number($kgs * 1000,&quot;#&quot;)"/>g)
				</xsl:when>
				<xsl:otherwise>
					(<xsl:value-of select="format-number($kgs,&quot;#.##&quot;)"/>kg)
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</div>
</xsl:template>

<xsl:template match="FERMENTABLE">
	<tr class="fermentable">
		<td>
			<div class="amount">
				<xsl:call-template name="format-weight">
					<xsl:with-param name="kgs" select="AMOUNT"/>
				</xsl:call-template>
			</div>
		</td>
		<td>
			<div class="pct"><xsl:value-of select="format-number(AMOUNT div sum(../FERMENTABLE/AMOUNT) * 100,&quot;#.##&quot;)"/>%</div>
		</td>
		<td>
			<div class="name"><xsl:value-of select="NAME"/></div>
			(<xsl:value-of select="format-number(COLOR,&quot;#.0&quot;)"/> SRM)
		</td>
	</tr>
</xsl:template>
	
<xsl:template match="HOPS">
	<div id="hops">
		<table>
			<xsl:apply-templates select="HOP[USE=&quot;Boil&quot;]"/>
			<tr><td></td></tr>
			<xsl:apply-templates select="HOP[USE=&quot;Dry Hop&quot;]"/>
		</table>
	</div>
</xsl:template>

<xsl:template match="HOP">
	<tr class="hop">
		<td>
			<xsl:call-template name="format-weight">
				<xsl:with-param name="kgs" select="AMOUNT"/>
			</xsl:call-template>
		</td>
		<td>
			<xsl:value-of select="NAME"/>
		</td>
		<td>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="ALPHA"/>%&#945;
			<xsl:text>] </xsl:text>
		</td>
		<td>
			<xsl:value-of select="FORM"/>
		</td>
		<td>
			<xsl:text> [</xsl:text>
			<xsl:value-of select="TIME"/>
			<xsl:text> min] </xsl:text>
		</td>
	</tr>
</xsl:template>

<xsl:template match="YEASTS">
	<div id="yeasts">
		<xsl:apply-templates select="YEAST"/>
	</div>
</xsl:template>

<xsl:template match="YEAST">
	<div class="yeast">
		<xsl:value-of select="AMOUNT * 1000"/>
		<xsl:text>ml </xsl:text>
		<xsl:value-of select="NAME"/>
		(<xsl:value-of select="LABORATORY"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="PRODUCT_ID"/>)
	</div>
</xsl:template>

<!-- <xsl:template match="MASH">
	<xsl:variable name="total_grain_weight" select="sum(//FERMENTABLES/FERMENTABLE/AMOUNT)"/>
	<h1>Mash Profile</h1>
	<div>Name: <xsl:value-of select="NAME"/></div>
	<div>Total Grain Weight: 
		<xsl:call-template name="format-weight">
			<xsl:with-param name="kgs" select="$total_grain_weight"/>
		</xsl:call-template>
	</div>
	<div>Mash Thickness: 
		<xsl:call-template name="format-volume">
			<xsl:with-param name="liters" select="MASH_THICKNESS"/>
		</xsl:call-template>
		per kg
	</div>
	Mash volume: <xsl:call-template name="format-volume">
		<xsl:with-param name="liters" select="MASH_THICKNESS * $total_grain_weight"/>
	</xsl:call-template>
	<div>Sparge Water: 
		<xsl:call-template name="format-volume">
			<xsl:with-param name="liters" select="MASH_THICKNESS"/>
		</xsl:call-template>
	</div>
	<div>Sparge Temperature: 
		<xsl:call-template name="format-temperature">
			<xsl:with-param name="celsius" select="SPARGE_TEMP"/>
		</xsl:call-template>
	</div>
	<div>Grain Temperature: 
		<xsl:call-template name="format-temperature">
			<xsl:with-param name="celsius" select="GRAIN_TEMP"/>
		</xsl:call-template>
	</div>

	<div id="mash_steps">
		<xsl:apply-templates select="MASH_STEPS"/>
	</div>
</xsl:template>

<xsl:template match="MASH_STEPS">
	<table>
		<xsl:apply-templates select="MASH_STEP"/>
	</table>
</xsl:template>
	
<xsl:template match="MASH_STEP">
	<tr>
		<td>
			<xsl:value-of select="NAME"/>
		</td>
		<td>
			<xsl:value-of select="TYPE"/>
		</td>
		<td>
			<xsl:call-template name="format-volume">
				<xsl:with-param name="liters" select="INFUSE_AMOUNT"/>
			</xsl:call-template>
		</td>
		<td>
			of water at
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" select="STEP_TEMP"/>
			</xsl:call-template>
		</td>
		<td>
			<xsl:value-of select="STEP_TIME"/> min
		</td>
	</tr>
</xsl:template> -->

<xsl:template name="format-volume">
	<xsl:param name="liters"/>
	<span class="volume">
		<span class="english"><xsl:value-of select="format-number($liters * 0.264172,&quot;#.##&quot;)"/> gallons</span>
		<span class="metric">(<xsl:value-of select="format-number($liters,&quot;#.#&quot;)"/>L)</span>
	</span>
</xsl:template>

<xsl:template name="format-temperature">
	<xsl:param name="celsius"/>
	<xsl:value-of select="format-number(($celsius * 9) div 5 + 32,&quot;#&quot;)"/>
	<xsl:text>&#176;F(</xsl:text>
	<xsl:value-of select="format-number($celsius,&quot;#&quot;)"/>
	<xsl:text>&#176;C)</xsl:text>
</xsl:template>

<xsl:template name="format-percent">
	<xsl:param name="value"/>
	<xsl:param name="precision"/>
	<span class="percent">
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
	</span>
</xsl:template>

<xsl:template match="NOTES">
	<div id="notes">
		<h1>Notes</h1>
		<div class="note"><xsl:value-of select="." disable-output-escaping="yes"/></div>
	</div>
</xsl:template>
	
<xsl:template match="STYLES">
	<div id="styles">
		<xsl:apply-templates select="STYLE"/>
	</div>
</xsl:template>

<xsl:template match="STYLE">
		<div class="style"><xsl:value-of select="NAME"/></div>
</xsl:template>

<xsl:template match="log">
	<h1>Brew log</h1>
	<xsl:apply-templates match="tumblr/tumblelog/posts"/>
</xsl:template>

<xsl:template match="posts">
	<xsl:for-each select="post">
		<xsl:sort select="@unix-timestamp"/>
		<div>
			<div class="logdate"><xsl:value-of select="@date"/></div>
			<xsl:apply-templates match="*"/>
		</div>
	</xsl:for-each>
</xsl:template>

<xsl:template match="photo-caption">
	<div><xsl:value-of select="." disable-output-escaping="yes"/></div>
</xsl:template>

<xsl:template match="photo-url[@max-width=&quot;250&quot;]">
	<div>
		<xsl:element name="img">
			<xsl:attribute name="src">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:element>
	</div>
	<xsl:call-template name="all-photos"/>
</xsl:template>

<xsl:template name="all-photos">
	<div>All photo sizes:
		<xsl:for-each select="../photo-url">
			<!-- <xsl:choose>
				<xsl:when test="position() = 1">All photos: </xsl:when>
				<xsl:when test="position() != 1">, </xsl:when>
			</xsl:choose> -->
			<xsl:text> </xsl:text>
			<xsl:element name="a">
				<xsl:attribute name="href">
					<xsl:value-of select="."/>
				</xsl:attribute>
				<xsl:value-of select="@max-width"/>
			</xsl:element>
		</xsl:for-each>
	</div>
</xsl:template>
	
<xsl:template match="photo-url">
	<!-- <div>
		<xsl:element name="a">
			<xsl:attribute name="href">
				<xsl:value-of select="."/>
			</xsl:attribute>
			<xsl:value-of select="@max-width"/>
		</xsl:element>
	</div> -->
</xsl:template>

<xsl:template match="video-caption">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>
	
<xsl:template match="video-player">
	<xsl:value-of select="." disable-output-escaping="yes"/>
</xsl:template>
	
<xsl:template match="regular-body">
	<div><xsl:value-of select="." disable-output-escaping="yes"/></div>
</xsl:template>

<xsl:template match="tag">
	<!-- <div>Tag:<xsl:value-of select="."/></div> -->
</xsl:template>

<xsl:template match="data">
</xsl:template>

</xsl:stylesheet>