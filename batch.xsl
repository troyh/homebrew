<?xml version="1.0" encoding="ISO-8859-1"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:include href="beerxml.xsl"/>

<xsl:template match="/batch">
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
			<div id="topnav">
				<a href="../index.html">Home</a>
			</div>
			<xsl:apply-templates select="*"/>
		</body>
	</html>
</xsl:template>

<xsl:template match="recipe/beerxml">
	<xsl:apply-templates select="*"/>
</xsl:template>
	
<xsl:template match="results">
	<div id="results">
		<h2>Results</h2>
		<div>
			<span class="headerkey"><xsl:text>Strike:</xsl:text>
				<span class="headercode"><xsl:text>ST</xsl:text></span>
				<span class="headercode"><xsl:text>SV</xsl:text></span>
			</span>
			<span class="headerval">
				<xsl:call-template name="format-volume">
					<xsl:with-param name="liters" select="mash/infusion/strike/@volume"/>
				</xsl:call-template>
				@
				<xsl:call-template name="format-temperature">
					<xsl:with-param name="celsius" select="mash/infusion/strike/@temp"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Mash:</xsl:text></span>
			<span class="headerval">
				<xsl:value-of select="mash/@duration"/> minutes at
				<xsl:call-template name="format-temperature">
					<xsl:with-param name="celsius" select="mash/measurement/@temp[1]"/>
				</xsl:call-template>
				<xsl:text>, average of </xsl:text>
				<xsl:call-template name="format-temperature">
					<xsl:with-param name="celsius" 
						select="sum(mash/measurement/@temp) div count(mash/measurement/@temp)"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Potential PPG:</xsl:text></span>
			<span class="headerval">
				<xsl:value-of select="format-number(sum(../recipe/data/ppg),&quot;#&quot;)"/>
				(<xsl:value-of 
					select="format-number(sum(../recipe/data/ppg) * ../recipe/beerxml/RECIPE/EFFICIENCY div 100,&quot;#&quot;)"/> required)
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Boil:</xsl:text>
				<span class="headercode"><xsl:text>BV</xsl:text></span>
				<span class="headercode"><xsl:text>BG</xsl:text></span>
				<span class="headercode"><xsl:text>BT</xsl:text></span>
				<span class="headercode"><xsl:text>EV</xsl:text></span>
			</span>
			<span class="headerval">
				<xsl:call-template name="format-volume">
					<xsl:with-param name="liters" select="boil/@volume"/>
				</xsl:call-template>
				for 
				<xsl:if test="string-length(boil/@time) = 0">____</xsl:if>
				<xsl:value-of select="boil/@time"/> 
				minutes &#8594; 
				<xsl:call-template name="format-volume">
					<xsl:with-param name="liters" select="boil/@end_volume"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Evaporation rate:</xsl:text></span>
			<span class="headerval">
				<xsl:call-template name="format-volume">
					<xsl:with-param name="liters" select="(boil/@volume - boil/@end_volume) div (boil/@time div 60)"/>
				</xsl:call-template>
				per hour
				(<xsl:call-template name="format-percent">
					<xsl:with-param name="value" 
						select="(boil/@volume - boil/@end_volume) div boil/@volume div (boil/@time div 60)"/>
				</xsl:call-template>)
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Final Volume:</xsl:text>
				<span class="headercode"><xsl:text>FV</xsl:text></span>
			</span>
			<span class="headerval">
				<xsl:call-template name="format-volume">
					<xsl:with-param name="liters" select="gravity/@volume"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>OG:</xsl:text>
				<span class="headercode"><xsl:text>OG</xsl:text></span>
			</span>
			<span class="headerval">
				<xsl:if test="string-length(gravity/@og) = 0">&#160;</xsl:if>
				<xsl:value-of select="gravity/@og"/>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>FG:</xsl:text>
				<span class="headercode"><xsl:text>FG</xsl:text></span>
			</span>
			<span class="headerval">
				<xsl:if test="string-length(gravity/@fg) = 0">&#160;</xsl:if>
				<xsl:value-of select="gravity/@fg"/>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>ABV:</xsl:text></span> 
			<span class="headerval">
				<xsl:call-template name="format-percent">
					<xsl:with-param name="value" select="(((gravity/@og - 1) * 1000) - ((gravity/@fg - 1) * 1000)) * 131 div 100000"/>
					<xsl:with-param name="precision" select="2"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Mash efficiency:</xsl:text></span>
			<span class="headerval">
				<xsl:call-template name="format-percent">
					<xsl:with-param name="value" select="(((boil/@sg - 1) * 1000) * (boil/@volume * 0.264172)) div sum(../recipe/data/ppg)"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Brewhouse efficiency:</xsl:text></span>
			<span class="headerval">			
				<xsl:call-template name="format-percent">
					<xsl:with-param name="value" select="(((gravity/@og - 1) * 1000) * (gravity/@volume * 0.264172)) div sum(../recipe/data/ppg)"/>
				</xsl:call-template>
			</span>
		</div>
		<div>
			<span class="headerkey"><xsl:text>Apparent Attenuation:</xsl:text></span>
			<span class="headerval">
				<xsl:call-template name="format-percent">
					<xsl:with-param name="value" select="(((gravity/@og - 1) * 1000) - ((gravity/@fg - 1) * 1000)) div ((gravity/@og - 1) * 1000)"/>
				</xsl:call-template>
			</span>
		</div>
	</div>
</xsl:template>

<xsl:template match="log">
	<div id="brewlog">
		<h1>Brew log</h1>
		<xsl:apply-templates match="tumblr/tumblelog/posts"/>
	</div>
</xsl:template>

<xsl:template match="posts">
	<xsl:for-each select="post">
		<xsl:sort select="@unix-timestamp"/>
		<div class="post">
			<div class="postbody">
				<div class="logdate"><xsl:value-of select="@date"/></div>
				<xsl:apply-templates match="*"/>
			</div>
		</div>
	</xsl:for-each>
</xsl:template>

<xsl:template match="photo-caption">
	<div class="posttext"><xsl:value-of select="." disable-output-escaping="yes"/></div>
</xsl:template>

<xsl:template match="photo-url[@max-width=&quot;250&quot;]">
	<div class="photo">
		<xsl:element name="img">
			<xsl:attribute name="src">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:element>
	</div>
	<xsl:call-template name="all-photos"/>
</xsl:template>

<xsl:template name="all-photos">
	<div class="photosizeoptions">All photo sizes:
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
	<div class="posttext"><xsl:value-of select="." disable-output-escaping="yes"/></div>
</xsl:template>

<xsl:template match="tag">
	<!-- <div>Tag:<xsl:value-of select="."/></div> -->
</xsl:template>

<xsl:template match="data">
</xsl:template>

</xsl:stylesheet>