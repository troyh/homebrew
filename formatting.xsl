<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="format-weight">
	<xsl:param name="kgs"/>
	<xsl:param name="decimal_only" select="false"/>
	<div class="weight">
		<div class="english">
			<xsl:choose>
				<xsl:when test="$kgs &lt; 0.453592"><!-- less than 1 pound? -->
					<xsl:value-of select="format-number(($kgs * 2.20462 * 16) mod 16,&quot;#.##&quot;)"/> oz
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$decimal_only != 0">
							<xsl:value-of select="format-number($kgs * 2.20462,&quot;#.##&quot;)"/> lbs 
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number($kgs * 2.20462,&quot;#&quot;)"/> lbs 
							<xsl:variable name="oz" select="format-number($kgs * 2.20462 * 16,&quot;#.##&quot;) mod 16"/>
							<xsl:choose>
								<xsl:when test="$oz &gt; 0">
									<xsl:value-of select="format-number($oz,&quot;#.##&quot;)"/> oz
								</xsl:when>
							</xsl:choose>
						</xsl:otherwise>
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

<xsl:template name="format-volume">
	<xsl:param name="liters"/>
	<xsl:choose>
		<xsl:when test="string($liters) = 'NaN' or string-length($liters) = 0">
			<span class="english">____ gallons</span>
			<span class="metric">(____L)</span>
		</xsl:when>
		<xsl:otherwise>
			<span class="volume">
				<span class="english"><xsl:value-of select="format-number($liters * 0.264172,&quot;#.##&quot;)"/> gallons</span>
				<span class="metric">(<xsl:value-of select="format-number($liters,&quot;#.#&quot;)"/>L)</span>
			</span>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="format-temperature">
	<xsl:param name="fahrenheit"/>
	<xsl:param name="celsius" select="($fahrenheit - 32) div 1.8"/>
	<span class="temperature">
		<xsl:choose>
			<xsl:when test="string($celsius) = 'NaN' or string-length($celsius) = 0">
				<span class="fahrenheit">____</span>
				<span class="celsius">____</span>
			</xsl:when>
			<xsl:otherwise>
				<span class="fahrenheit"><xsl:value-of select="format-number(($celsius * 9) div 5 + 32,&quot;#&quot;)"/></span>
				<span class="celsius"><xsl:value-of select="format-number($celsius,&quot;#&quot;)"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</span>
</xsl:template>

<xsl:template name="format-percent">
	<xsl:param name="value"/>
	<xsl:param name="precision"/>
	<span class="percent">
		<xsl:choose>
			<xsl:when test="string(number($value)) = 'NaN'"><xsl:text>&#160;</xsl:text>
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
