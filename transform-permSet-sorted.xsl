<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sfdc="http://soap.sforce.com/2006/04/metadata">
	<xsl:output method="text" encoding="iso-8859-1"/>
	<!-- <xsl:strip-space elements="*" /> -->

	<xsl:template match="sfdc:PermissionSet">

		<xsl:for-each select="sfdc:applicationVisibilities">
			<xsl:sort select="sfdc:application"/>
			<xsl:value-of select="local-name()"/>
			<xsl:text>[</xsl:text>

				<xsl:value-of select="name(sfdc:application)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:application"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:visible)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:visible"/>

			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:classAccesses">
			<xsl:sort select="sfdc:apexClass"/>
			<xsl:value-of select="local-name()"/>
			<xsl:text>[</xsl:text>

				<xsl:value-of select="name(sfdc:apexClass)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:apexClass"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:enabled)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:enabled"/>

			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:fieldPermissions">
			<xsl:sort select="sfdc:field"/>

			<xsl:value-of select="local-name()"/>
			<xsl:text>[</xsl:text>

				<xsl:value-of select="name(sfdc:field)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:field"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:editable)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:editable"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:readable)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:readable"/>

			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:objectPermissions">
			<xsl:sort select="sfdc:object"/>
			<xsl:value-of select="local-name()"/>
			<xsl:text>[</xsl:text>

				<xsl:value-of select="name(sfdc:object)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:object"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:allowCreate)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:allowCreate"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:allowDelete)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:allowDelete"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:allowEdit)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:allowEdit"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:allowRead)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:allowRead"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:modifyAllRecords)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:modifyAllRecords"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:viewAllRecords)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:viewAllRecords"/>

			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:recordTypeVisibilities">
			<xsl:sort select="sfdc:recordType"/>
			<xsl:value-of select="local-name()"/>
			<xsl:text>[</xsl:text>

				<xsl:value-of select="name(sfdc:recordType)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:recordType"/><xsl:text>,</xsl:text>

				<xsl:value-of select="name(sfdc:visible)"/><xsl:text>:</xsl:text>
				<xsl:value-of select="sfdc:visible"/><xsl:text>,</xsl:text>

			<xsl:text>]</xsl:text>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:hasActivationRequired">
			<xsl:value-of select="local-name()"/><xsl:text>:</xsl:text>
			<xsl:value-of select="text()"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>


		<xsl:for-each select="sfdc:label">
			<xsl:value-of select="local-name()"/><xsl:text>:</xsl:text>
			<xsl:value-of select="text()"/>
			<xsl:text>&#xa;</xsl:text>
		</xsl:for-each>

	</xsl:template>
</xsl:stylesheet>
