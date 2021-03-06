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
		  <link rel="stylesheet" type="text/css" href="recipe.css" />
	  </head>
	  <body>
		  <div id="header">
			  <h1><xsl:value-of select="NAME"/></h1>
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

	  </body>
  </html>
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

<xsl:template match="MASH">
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
</xsl:template>

<xsl:template name="format-volume">
	<xsl:param name="liters"/>
	<xsl:value-of select="format-number($liters * 0.264172,&quot;#.##&quot;)"/> gallons
	(<xsl:value-of select="format-number($liters,&quot;#.##&quot;)"/>L)
</xsl:template>

<xsl:template name="format-temperature">
	<xsl:param name="celsius"/>
	<xsl:value-of select="format-number(($celsius * 9) div 5 + 32,&quot;#&quot;)"/>&#176;F
	(<xsl:value-of select="format-number($celsius,&quot;#&quot;)"/>&#176;C)
</xsl:template>

<xsl:template match="NOTES">
	<div id="notes">
		<h1>Notes</h1>
		<div class="note"><xsl:value-of select="."/></div>
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


</xsl:stylesheet>