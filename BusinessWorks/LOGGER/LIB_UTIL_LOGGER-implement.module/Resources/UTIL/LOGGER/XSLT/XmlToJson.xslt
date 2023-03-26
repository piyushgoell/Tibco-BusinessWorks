<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output method="text" omit-xml-declaration="yes" encoding="utf-8"/>
    
    <!-- Template to convert XML to JSON -->
    <xsl:template match="/">
        <xsl:text>{</xsl:text>
        <xsl:apply-templates select="*" mode="root"/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <!-- Template to process elements at the root level -->
    <xsl:template match="*" mode="root">
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
        <xsl:text></xsl:text>
    </xsl:template>

    <!-- Template to process child elements as an array -->
    <xsl:template match="*" mode="array">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="*" mode="value"/>
        <xsl:text>]</xsl:text>
    </xsl:template>

    <!-- Template to process element values -->
    <xsl:template match="*" mode="value">
        <xsl:variable name="key" select="local-name()"/>
        <xsl:variable name="value" select="."/>
        <xsl:text>"</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>":</xsl:text>
        <xsl:choose>
            <xsl:when test="$value = ''">
                <xsl:text>null</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
        <xsl:text></xsl:text>
    </xsl:template>

</xsl:stylesheet>
