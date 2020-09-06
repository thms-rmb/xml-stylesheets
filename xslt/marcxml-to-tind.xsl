<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:tind="https://tind.io/xsl"
		xmlns:marc="http://www.loc.gov/MARC21/slim"
		xmlns="http://www.loc.gov/MARC21/slim"
		version="3.0">
  <!--
      Transforms standard MARCXML into TIND MARCXML according to these
      rules:
      - Spaces in controlfields are rendered with a backslash ('\')
      - The leader element is replaced with a controlfield with tag
        000
  -->

  <xsl:mode on-no-match="shallow-copy" />

  <xsl:function name="tind:normalize-text" as="xs:string">
    <xsl:param name="content" as="xs:string" />
    <xsl:sequence select="replace($content => normalize-space(),
                                  ' ',
				  '\\')" />
  </xsl:function>

  <xsl:template match="marc:leader">
    <xsl:variable name="name" select="let $prefix := substring-before(name(), ':')
                                      return
				        if ($prefix)
					then $prefix || ':controlfield'
					else 'controlfield'" />
    <xsl:element name="{$name}">
      <xsl:attribute name="tag" select="'000'" />
      <xsl:value-of select="tind:normalize-text(.)" />
    </xsl:element>
  </xsl:template>

  <xsl:template match="marc:controlfield">
    <xsl:copy select=".">
      <xsl:apply-templates select="@*" />
      <xsl:value-of select="tind:normalize-text(.)" />
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
