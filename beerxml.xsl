<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:exslt="http://exslt.org/common">

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
		  <div id="header">
			  <h1><xsl:value-of select="NAME" disable-output-escaping="yes"/></h1>
			  <xsl:apply-templates select="STYLES"/>
			  <div>
				  <span class="headerkey"><xsl:text>Type: </xsl:text></span>
				  <span class="headerval"><xsl:value-of select="TYPE"/></span>
			  </div>
		  
			  <div>
				  <span class="headerkey">Batch size:</span>
				  <span class="headerval">
					  <xsl:call-template name="format-volume">
						  <xsl:with-param name="liters" select="BATCH_SIZE"/>
					  </xsl:call-template>
				  </span>
			  </div>

			  <!-- <div>
				  <span class="headerkey">Boil Volume:</span>
				  <span class="headerval">
					  <xsl:call-template name="format-volume">
						  <xsl:with-param name="liters" select="BOIL_SIZE"/>
					  </xsl:call-template>
					  </span>
			  </div>

			  <div>
				  <span class="headerkey"><xsl:text>Boil time:</xsl:text></span>
				  <span class="headerval">
					  <xsl:value-of select="BOIL_TIME"/><xsl:text> minutes</xsl:text>
				  </span>
			  </div>
			  
			  <div>
				  <span class="headerkey"><xsl:text>Brewhouse Efficiency:</xsl:text></span>
				  <span class="headerval"><xsl:value-of select="EFFICIENCY"/><xsl:text>%</xsl:text></span>
			  </div> -->
			  
			  <xsl:variable name="foo">	
			  	<xsl:for-each select="FERMENTABLES/FERMENTABLE">
			  		<ppg><xsl:value-of select="AMOUNT * 2.20462 * (YIELD div 100 * 46)"/></ppg>
			  	</xsl:for-each>
			</xsl:variable>
			  <xsl:variable name="totppg" select="sum(exslt:node-set($foo)/ppg)"/>
			  
			  <xsl:variable name="CALC_OG_GU" 
				select="($totppg * EFFICIENCY div (BATCH_SIZE * 0.264172)) div 100"/>
  			  <xsl:variable name="CALC_FG_GU" 
  				select="$CALC_OG_GU - ((EFFICIENCY div 100) * $CALC_OG_GU)"/>

			  <div>
				  <span class="headerkey"><xsl:text>OG:</xsl:text></span>
				  <span class="headerval"><xsl:value-of select="format-number($CALC_OG_GU div 1000 + 1,&quot;#.000&quot;)"/></span>
			  </div>
			  
			  <div>
				  <span class="headerkey"><xsl:text>FG:</xsl:text></span>
				  <span class="headerval"><xsl:value-of select="format-number($CALC_FG_GU div 1000 + 1,&quot;#.000&quot;)"/></span>
			  </div>

			  <div>
				  <span class="headerkey"><xsl:text>ABV:</xsl:text></span>
				  <span class="headerval"><xsl:value-of select="format-number(($CALC_OG_GU - $CALC_FG_GU) * 131 div 1000,&quot;#.##&quot;)"/>%</span>
			  </div>
			  
			  <div>
				  <span class="headerkey"><xsl:text>ADF:</xsl:text></span>
				  <span class="headerval"><xsl:value-of select="format-number((1 - ($CALC_FG_GU div $CALC_OG_GU)) * 100,&quot;#.##&quot;)"/>%</span>
			  </div>
			  
				<div>
					<!-- From http://www.mrmalty.com/pitching.php:
		
					(0.75 million) X (milliliters of wort) X (degrees Plato of the wort)  
			
					2x as much for lagers
		
					-->
					<xsl:variable name="YEAST_CELLS_REQD" select="0.75 * (BATCH_SIZE * 1000) * ($CALC_OG_GU div 4) div 1000 * ((STYLES/STYLE/CATEGORY_NUMBER &lt; 6) + 1)"/>
					<span class="headerkey">Yeast starter:</span>
					<span class="headerval">
						<xsl:value-of select="format-number($YEAST_CELLS_REQD div 2.5 * (1 div .75),&quot;#&quot;)"/>ml  (assuming 75% viability) of yeast slurry,
						<xsl:value-of select="format-number($YEAST_CELLS_REQD,&quot;#&quot;)"/>B cells
					</span>
				</div>
		
			</div>

	      <div id="ingredients">
			  <xsl:apply-templates select="FERMENTABLES"/>
			  <xsl:apply-templates select="HOPS"/>
			  <xsl:apply-templates select="MISCS"/>
			  <xsl:apply-templates select="YEASTS"/>
		  </div>
		  
		  <!-- <div id="mashprofile">
			  <xsl:apply-templates select="MASH"/>
		  </div> -->
		  
		  <xsl:apply-templates select="NOTES"/>

</xsl:template>


<xsl:template match="FERMENTABLES">
	<div id="fermentables">
		<div class="total_weight">
			<!-- Total weight should be in decimal format -->
			<xsl:call-template name="format-weight">
				<xsl:with-param name="decimal_only" select="1"/>
				<xsl:with-param name="kgs" select="sum(FERMENTABLE[YIELD &gt; 0]/AMOUNT)"/>
			</xsl:call-template>
		</div>
		<table>
			<xsl:apply-templates select="FERMENTABLE"/>
		</table>
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
			<div class="srm"><xsl:value-of select="format-number(COLOR,&quot;#&quot;)"/></div>
		</td>
	</tr>
</xsl:template>

<xsl:template match="MISCS">
	<table id="miscellaneous">
		<xsl:apply-templates select="MISC"/>
	</table>
</xsl:template>

<xsl:template match="MISC">
	<tr>
		<td>
			<xsl:call-template name="format-weight">
				<xsl:with-param name="kgs" select="AMOUNT"/>
			</xsl:call-template>
		</td>
		<td><xsl:value-of select="NAME"/></td>
		<td><xsl:value-of select="format-number(TIME,&quot;#&quot;)"/> min</td>
	</tr>
</xsl:template>
	
<xsl:template match="HOPS">
	<div id="hops">
		<div class="total_weight">
			<!-- Total weight should be in decimal format -->
			<xsl:call-template name="format-weight">
				<xsl:with-param name="decimal_only" select="1"/>
				<xsl:with-param name="kgs" select="sum(HOP/AMOUNT)"/>
			</xsl:call-template>
		</div>
		<table>
			<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Mash'"/></xsl:call-template>
			<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'First Wort'"/></xsl:call-template>
			<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Boil'"/></xsl:call-template>
			<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Aroma'"/></xsl:call-template>
			<xsl:call-template name="display-hops"><xsl:with-param name="use" select="'Dry Hop'"/></xsl:call-template>
		</table>
	</div>
</xsl:template>

<xsl:template name="display-hops">
	<xsl:param name="use"/>
	<xsl:if test="count(key('hops-by-use',$use)) > 0">
	<tr><th><xsl:value-of select="$use"/></th></tr>
	<xsl:for-each select="key('hops-by-use',$use)">
		<xsl:apply-templates select="."/>
	</xsl:for-each>
	</xsl:if>
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
			<xsl:value-of select="format-number(ALPHA,&quot;#.##&quot;)"/>%&#945;
		</td>
		<td>
			<xsl:value-of select="FORM"/>
		</td>
		<td>
			<xsl:if test="USE = 'Boil'">
				<xsl:value-of select="format-number(TIME,&quot;#&quot;)"/> min
			</xsl:if>
			<xsl:if test="USE = 'Dry Hop'">
				<xsl:value-of select="format-number(TIME div (60 * 24),&quot;#&quot;)"/> days
			</xsl:if>
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
		<xsl:value-of select="LABORATORY"/><xsl:text> </xsl:text><xsl:value-of select="PRODUCT_ID"/>
		(<xsl:value-of select="NAME"/>)
		<div class="temperaturerange">
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" select="MIN_TEMPERATURE"/>
			</xsl:call-template>
				-
			<xsl:call-template name="format-temperature">
				<xsl:with-param name="celsius" select="MAX_TEMPERATURE"/>
			</xsl:call-template>
		</div>			
		<div class="attenuation">
			<xsl:value-of select="ATTENUATION"/>%
		</div>
	</div>
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
	<div class="style"><xsl:value-of select="NAME"/>
		<span class="styleid">
			<xsl:text>(</xsl:text>
			<xsl:value-of select="CATEGORY_NUMBER"/>
			<xsl:value-of select="STYLE_LETTER"/>
			<xsl:text>)</xsl:text>
		</span>
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


</xsl:stylesheet>
