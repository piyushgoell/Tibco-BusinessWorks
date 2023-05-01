<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:json="http://www.ibm.com/xmlns/prod/2009/jsonx"
    exclude-result-prefixes="json">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
        <root>
            <xsl:apply-templates select="json:Object"/>
        </root>
    </xsl:template>

    <xsl:template match="json:Array">
        <array>
            <xsl:apply-templates select="*"/>
        </array>
    </xsl:template>

    <xsl:template match="json:Object">
        <object>
            <xsl:apply-templates select="*"/>
        </object>
    </xsl:template>

    <xsl:template match="json:Number">
        <number>
            <xsl:value-of select="."/>
        </number>
    </xsl:template>

    <xsl:template match="json:Boolean">
        <boolean>
            <xsl:value-of select="."/>
        </boolean>
    </xsl:template>

    <xsl:template match="json:String">
        <string>
            <xsl:value-of select="."/>
        </string>
    </xsl:template>

    <xsl:template match="json:Null">
        <null>
            <xsl:text>null</xsl:text>
        </null>
    </xsl:template>

</xsl:stylesheet>
