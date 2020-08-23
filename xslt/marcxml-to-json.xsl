<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:map="http://www.w3.org/2005/xpath-functions/map"
		xmlns:marc="http://www.loc.gov/MARC21/slim"
		version="3.0">
  <xsl:output method="json" />

  <!--
      Transforms MARCXML into a JSON representation according to the
      proposal outlined in
      https://github.com/marc4j/marc4j/wiki/MARC-in-JSON-Description
  -->

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
			    'leader': marc:leader => string() => normalize-space(),
			    'fields': array { $fields } }" />
  </xsl:template>

  <xsl:template match="marc:controlfield">
    <xsl:sequence select="map {
			    @tag: string() => normalize-space() }" />
  </xsl:template>

  <xsl:template match="marc:datafield">
    <xsl:variable name="subfields"
		  select="array {
			    for $s in marc:subfield
			    return map {
			      $s/@code: $s => string() => normalize-space() } }" />

    <xsl:sequence select="map {
			    @tag: map {
			      'subfields': $subfields,
			      'ind1': @ind1 => string(),
			      'ind2': @ind2 => string() } }" />
  </xsl:template>
</xsl:stylesheet>
