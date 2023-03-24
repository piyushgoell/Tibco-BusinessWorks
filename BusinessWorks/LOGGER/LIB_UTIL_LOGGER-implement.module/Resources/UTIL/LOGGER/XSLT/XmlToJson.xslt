<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
	
	<xsl:output method="text" encoding="utf-8"/>
    <!-- Template to convert XML to JSON -->
    
    <xsl:template match="/">
        <xsl:text>{&#xa;</xsl:text>
        <xsl:apply-templates select="*" mode="root"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <!-- Template to process elements at the root level -->
    <xsl:template match="*" mode="root">
    <!--  Skip root element
        <xsl:text>&#x9;"</xsl:text>
        <xsl:value-of select="local-name()"/>
        <xsl:text>": </xsl:text> 
      -->
        <xsl:choose>
            <xsl:when test="count(*) &gt; 0">
                <xsl:apply-templates select="*" mode="array"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="value"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <!-- Template to process child elements as an array -->
    <xsl:template match="*" mode="array">
        <xsl:text>[&#xa;</xsl:text>
        <xsl:apply-templates select="*" mode="value"/>
        <xsl:text>&#x9;]</xsl:text>
    </xsl:template>

    <!-- Template to process element values -->
    <xsl:template match="*" mode="value">
        <xsl:variable name="key" select="local-name()"/>
        <xsl:variable name="value" select="."/>
        <xsl:text>&#x9;&#x9;"</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>": </xsl:text>
        <xsl:choose>
            <xsl:when test="$value = ''">
                <xsl:text>null</xsl:text>
            </xsl:when>
            <xsl:when test="not(number($value)) and ($value castable as xs:double)">
                <xsl:value-of select="number($value)"/>
            </xsl:when>
            <xsl:when test="not($value castable as xs:double)">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$value"/>
                <xsl:text>"</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
