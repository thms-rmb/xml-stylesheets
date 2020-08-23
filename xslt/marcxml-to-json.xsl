<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:map="http://www.w3.org/2005/xpath-functions/map"
		xmlns:marc="http://www.loc.gov/MARC21/slim"
		version="3.0">
  <xsl:output method="json" />

  <xsl:template match="marc:collection">
    <xsl:variable name="records" as="map(*)*">
      <xsl:apply-templates select="marc:record" />
    </xsl:variable>

    <xsl:sequence select="array { $records }" />
  </xsl:template>

  <xsl:template match="marc:record">
    <xsl:variable name="fields" as="map(*)*">
      <xsl:apply-templates select="marc:controlfield | marc:datafield" />
    </xsl:variable>

    <xsl:sequence select="map {
                            'leader': marc:leader/text(),
                            'fields': array { $fields } }" />
  </xsl:template>

  <xsl:template match="marc:controlfield">
    <xsl:sequence select="map { @tag: text() }" />
  </xsl:template>

  <xsl:template match="marc:datafield">
    <xsl:variable name="subfields"
		  select="array {
                            for $s in marc:subfield
                            return map { $s/@code: $s/text() } }" />
    <xsl:sequence select="map {
                            @tag: map {
                              'subfields': $subfields,
                              'ind1': string(@ind1), 
                              'ind2': string(@ind2) } }" />
  </xsl:template>
</xsl:stylesheet>
