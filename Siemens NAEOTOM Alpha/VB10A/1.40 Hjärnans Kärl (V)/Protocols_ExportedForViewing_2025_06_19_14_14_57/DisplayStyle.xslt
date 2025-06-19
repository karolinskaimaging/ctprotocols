<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" doctype-system="about:legacy-compat" encoding="UTF-8" indent="yes" />
  <xsl:template match="/">
    <html>
      <head>
        <title>Scan Protocol Lists</title>
        <link href="DisplayStyle.css" rel="stylesheet" type="text/css" />
      </head>
      <body style="overflow-y:auto">
        <!--start to show the file -->
        <xsl:apply-templates select="ProtocolList" />
      </body>
    </html>
  </xsl:template>

  <!-- List Protocol -->
  <xsl:template match="ProtocolList">
    <!-- Column Header Table -->
    <div style="top:expression(body.scrollTop); position:absolute; z-index:1; overflow-x:hidden; overflow-y:hidden; height:160; word-break:keep-all;">
      <table border="1" bgcolor="#4B61E9" bordercolor="#B2BAEC">
        <tbody>
          <tr>
		    <xsl:for-each select="SpecialColumnHead/*">
			  <td class="1stcolumnheadcell" height="155">
			    <xsl:value-of select="." />
			  </td>
			</xsl:for-each>
            <xsl:for-each select="ColumnHead/*">
              <td class="1stcolumnheadcell" height="155">
                <xsl:value-of select ="."/>
              </td>
            </xsl:for-each>
          </tr>
          <!--show content-->
          <xsl:for-each select="Mode">
            <xsl:apply-templates select="Folder"/>
          </xsl:for-each>
        </tbody>
      </table>
    </div>
  </xsl:template>

  <!-- Folder Node-->
  <xsl:template match="Folder">
	<!-- Show Siemens Protocols in one line -->
    <tr>
      <th colspan="150" class="user" align="left">
        <xsl:value-of select="FolderName" />
      </th>
    </tr>
    <xsl:for-each select="Body">
      <xsl:apply-templates select="Region" />
    </xsl:for-each>
  </xsl:template>
  <!-- Region Node-->
  <xsl:template match="Region">
	<tr>
	  <td class="region">
	    <xsl:value-of select="RegionName"/>
	  </td>
	  <xsl:for-each select="Protocol">
	    <xsl:choose>
		  <xsl:when test="position()!=1">
		    <xsl:call-template name="GenCell"/>
		  </xsl:when>
		</xsl:choose>
        <xsl:call-template name="protocolTemplate"/>
	  </xsl:for-each>
      
	</tr>
  </xsl:template>

  <xsl:template name="protocolTemplate">
    <xsl:for-each select="ScanEntry[@ScanType='Protocol']">
      <xsl:call-template name="protocolRowTemplate"/>
      <xsl:for-each select="ScanEntry[@ScanType='Range']">
        <xsl:call-template name="rangeRowTemplate"/>
		    <xsl:for-each select="ScanEntry[@ScanType='ReconCompound']">
          <xsl:call-template name="reconCompoundRowTemplate">
          </xsl:call-template>
			</xsl:for-each>
        </xsl:for-each>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="protocolRowTemplate">
    <!--Print protocol name-->
    <xsl:call-template name="GenCell">
      <xsl:with-param name="CellValue" select="Name" />
      <xsl:with-param name="Style">ProtocolCell</xsl:with-param>
    </xsl:call-template>
    <!--Indent range name-->
    <xsl:call-template name="GenCell"/>
    <!--Indent recon name-->
    <xsl:call-template name="GenCell"/>
	
	
    <!--Print protocol cells-->
    <xsl:for-each select="*[not(self::ScanEntry or self::Name)]">
	   <xsl:choose>
	 <xsl:when test="./@rowspan !=''">
	  <td class="ItemCell">
	   <xsl:attribute name="rowspan">
	  <xsl:value-of select="@rowspan"/>
	</xsl:attribute>
	   <xsl:value-of select="content" disable-output-escaping="yes" />
	 </td>
	 </xsl:when>
	 <xsl:otherwise>
	  <xsl:call-template name="GenCell">
           <xsl:with-param name="CellValue" select="." />
           <xsl:with-param name="Style" select="''"/>
         </xsl:call-template>
	 </xsl:otherwise>
	</xsl:choose>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="rangeRowTemplate">
    <tr>
	  <xsl:call-template name="GenCell"/>
      <!--Indent protocol name-->
      <xsl:call-template name="GenCell"/>
      <!--Print range name-->
      <xsl:call-template name="GenCell">
        <xsl:with-param name="CellValue" select="Name" />
        <xsl:with-param name="Style" select="''"/>
      </xsl:call-template>
      <!--Indent recon name-->
      <xsl:call-template name="GenCell"/>
      <!--Print range cells-->
      <xsl:for-each select="*[not(self::ScanEntry or self::Name or self::ProtocolDescription or self::Indication)]">
        <xsl:call-template name="GenCell">
          <xsl:with-param name="CellValue" select="." />
          <xsl:with-param name="Style" select="''"/>
        </xsl:call-template>
      </xsl:for-each>
    </tr>
  </xsl:template>
 
  <xsl:template name="reconCompoundRowTemplate">
    <tr>
	  <xsl:call-template name="GenCell"/>
      <!--Indent protocol name-->
      <xsl:call-template name="GenCell"/>
      <!--Indent range name-->
      <xsl:call-template name="GenCell"/>
      <!--Print recon name and parameters-->
      <xsl:for-each select="*[not(self::ScanEntry or self::ProtocolDescription or self::Indication)]">
            <xsl:call-template name="GenCellReconCompound">
          <xsl:with-param name="CellValue" select="." />
          <xsl:with-param name="Style" select="''"/>
        </xsl:call-template>
      </xsl:for-each>
    </tr>
  </xsl:template>

  <xsl:template name="GenCell">
    <!-- GenCell Function -->
    <xsl:param name="Style" />
    <xsl:param name="CellValue" />
    <!-- Paramter defination -->
    <xsl:choose>
      <xsl:when test="$CellValue=''">
        <td>
          <br/>
        </td>
        <!-- insert a blank space -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$CellValue='!null'">
            <td>
              <br/>
            </td>
            <!-- insert a blank space -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$Style='ProtocolCell'">
                <td class="ProtocolCell">
                  <xsl:value-of select="$CellValue" disable-output-escaping="yes"/>
                </td>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="$Style='NumberCell'">
                      <td class="ItemCell" align="right">
                        <xsl:value-of select="$CellValue" disable-output-escaping="yes"/>
                      </td>
                    </xsl:when>
                    <xsl:otherwise>
                      <td class="ItemCell">
                        <xsl:value-of select="$CellValue" disable-output-escaping="yes"/>
                      </td>
                    </xsl:otherwise>
                  </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <!-- export the string -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="GenCellReconCompound">
    <!-- GenCell Function -->
    <xsl:param name="Style" />
    <xsl:param name="CellValue" />
    <!-- Paramter defination -->
    <xsl:choose>
      <xsl:when test="$CellValue=''">
        <td>
          <br/>
        </td>
        <!-- insert a blank space -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$CellValue='!null'">
            <td>
              <br/>
            </td>
            <!-- insert a blank space -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$Style='ProtocolCell'">
                <td class="ProtocolCell">
                  <xsl:value-of select="$CellValue" />
                </td>
              </xsl:when>
              <xsl:otherwise>
                <xsl:choose>
                  <xsl:when test="$Style='NumberCell'">
                    <td class="ItemCell" align="right">
                      <xsl:value-of select="$CellValue" />
                    </td>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="./@NoOfSubRecons != ''">
                        <td>
                          <table>
                            <tbody>
                              <xsl:for-each select="*[self::SubRecon]">
                                <tr>
                                  <xsl:attribute name="height">100</xsl:attribute>
                                  <td class="ItemCell">
                                    <xsl:attribute name="width">100</xsl:attribute>
                                    <xsl:value-of select="." />
                                  </td>
                                </tr>
                              </xsl:for-each>
                            </tbody>
                          </table>
                        </td>
                      </xsl:when>
                      <xsl:otherwise>
                        <td class="ItemCell">
                          <xsl:value-of select="$CellValue" />
                        </td>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
            <!-- export the string -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>